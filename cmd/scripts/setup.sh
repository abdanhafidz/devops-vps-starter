#!/usr/bin/env bash
set -e

echo "🚀 Starting VPS bootstrap..."

# ============================
# Variables
# ============================
TIMEZONE="Asia/Jakarta"

# ============================
# Update system
# ============================
echo "📦 Updating system..."
apt update && apt upgrade -y

# ============================
# Basic packages
# ============================
echo "🛠 Installing base packages..."
apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  git \
  ufw \
  htop \
  unzip \
  jq \
  software-properties-common

# ============================
# Timezone
# ============================
echo "🕒 Setting timezone..."
timedatectl set-timezone $TIMEZONE

# ============================
# Docker installation
# ============================
echo "🐳 Installing Docker..."

if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh
fi

# Enable docker
systemctl enable docker
systemctl start docker

# ============================
# Docker Compose v2
# ============================
echo "📦 Installing Docker Compose plugin..."

mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ============================
# Firewall (UFW)
# ============================
echo "🔥 Configuring firewall..."

ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

# ============================
# Fail2ban (optional but recommended)
# ============================
echo "🛡 Installing fail2ban..."
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# ============================
# SSH Hardening
# ============================
echo "🔐 Hardening SSH..."

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

systemctl restart ssh

# ============================
# Final check
# ============================
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Add your SSH public key to ~/.ssh/authorized_keys"
echo "2. Clone your project repo"
echo "3. Run: docker compose up -d"
