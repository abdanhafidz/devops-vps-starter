#!/bin/bash
set -e

# =========================
# CONFIG
# =========================
GIT_USER="git"
BASE_REPO_DIR="/home/$GIT_USER/repos"
BASE_DEPLOY_DIR="/opt/main/app"

REPOS=(
  "backend-production"
  "backend-development"
  "frontend-production"
  "frontend-development"
)

# =========================
# CREATE USER
# =========================
if ! id "$GIT_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$GIT_USER"
fi

# =========================
# SSH SETUP
# =========================
SSH_DIR="/home/$GIT_USER/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

if [ ! -f "$SSH_DIR/id_ed25519" ]; then
  sudo -u $GIT_USER ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -N ""
fi

cat "$SSH_DIR/id_ed25519.pub" >> "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R $GIT_USER:$GIT_USER "$SSH_DIR"

# =========================
# CREATE REPOS + HOOKS
# =========================
for REPO in "${REPOS[@]}"; do
  echo "🚀 Setting up $REPO"

  REPO_PATH="$BASE_REPO_DIR/$REPO.git"
  DEPLOY_PATH="$BASE_DEPLOY_DIR/$REPO"

  # Tentukan branch dari nama repo
  if [[ "$REPO" == *"-production" ]]; then
    BRANCH="production"
  else
    BRANCH="development"
  fi

  mkdir -p "$REPO_PATH" "$DEPLOY_PATH"
  chown -R $GIT_USER:$GIT_USER "$REPO_PATH" "$DEPLOY_PATH"

  if [ ! -d "$REPO_PATH/objects" ]; then
    sudo -u $GIT_USER git init --bare "$REPO_PATH"
  fi

  sudo -u $GIT_USER git --git-dir="$REPO_PATH" symbolic-ref HEAD "refs/heads/$BRANCH"

  # --------------------------
  # POST-RECEIVE HOOK
  # --------------------------
  HOOK="$REPO_PATH/hooks/post-receive"

  cat > "$HOOK" <<EOF
#!/bin/bash
set -e

BRANCH="$BRANCH"
DEPLOY_DIR="$DEPLOY_PATH"
GIT_DIR="$REPO_PATH"

echo "🚀 Deploying branch: \$BRANCH"
echo "📁 Target: \$DEPLOY_DIR"

mkdir -p "\$DEPLOY_DIR"
git --work-tree="\$DEPLOY_DIR" --git-dir="\$GIT_DIR" checkout -f "\$BRANCH"

echo "✅ Deploy completed for $REPO"
EOF

  chmod +x "$HOOK"
  chown -R $GIT_USER:$GIT_USER "$REPO_PATH"

done

# =========================
# OUTPUT PRIVATE KEY
# =========================
echo ""
echo "=============================================="
echo "✅ SETUP COMPLETE"
echo "=============================================="
echo ""
echo "🔐 PRIVATE KEY (PUT IN GITHUB ACTIONS):"
echo ""
cat "$SSH_DIR/id_ed25519"
echo ""
echo "=============================================="
echo "Repos ready:"
for r in "${REPOS[@]}"; do
  echo " - $BASE_REPO_DIR/$r.git"
done
