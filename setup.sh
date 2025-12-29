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
  software-properties-common \
  fail2ban

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
# Firewall (UFW)
# ============================
echo "🔥 Configuring firewall..."
ufw allow OpenSSH
ufw allow 80
ufw allow 443
ufw --force enable

# ============================
# SSH Hardening
# ============================
echo "🔐 Hardening SSH..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# ============================
# App Directories
# ============================
echo "📂 Creating data directories..."
# Ensure permissions for mapped volumes if needed (simplified here)
# chown -R 1000:1000 app/sysadmin/uptimekuma

# ============================
# Final check
# ============================
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "1. Create a .env file with POSTGRES_PASSWORD"
echo "2. Run: docker compose up -d"
