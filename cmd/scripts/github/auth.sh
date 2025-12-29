#!/usr/bin/env bash
set -e

OUTPUT="../../config/secrets/github.auth.env"

echo "🔐 GitHub Authentication Setup"
echo "=============================="

echo "Choose authentication method:"
echo "1) HTTPS (Personal Access Token)"
echo "2) SSH Deploy Key"
read -rp "Selection [1/2]: " METHOD

if [[ "$METHOD" == "1" ]]; then
  read -rsp "GitHub Personal Access Token: " GITHUB_TOKEN
  echo ""

  cat > "$OUTPUT" <<EOF
# ============================
# GitHub Auth (HTTPS)
# ============================

GITHUB_AUTH_TYPE=https
GITHUB_TOKEN=${GITHUB_TOKEN}
EOF

elif [[ "$METHOD" == "2" ]]; then
  read -rp "SSH Private Key Path [~/.ssh/id_ed25519]: " SSH_KEY
  SSH_KEY=${SSH_KEY:-~/.ssh/id_ed25519}

  [[ ! -f "$SSH_KEY" ]] && echo "❌ SSH key not found" && exit 1

  cat > "$OUTPUT" <<EOF
# ============================
# GitHub Auth (SSH)
# ============================

GITHUB_AUTH_TYPE=ssh
GITHUB_SSH_KEY_PATH=${SSH_KEY}
EOF

else
  echo "❌ Invalid selection"
  exit 1
fi

chmod 600 "$OUTPUT"

echo "✅ Authentication config saved to:"
echo "   $OUTPUT"
