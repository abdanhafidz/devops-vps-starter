#!/usr/bin/env bash
set -e

OUTPUT="../../config/secrets/github.info.env"

echo "📦 GitHub Repository Information"
echo "==============================="

read -rp "GitHub Owner / Organization: " GITHUB_OWNER
read -rp "GitHub Repository Name: " GITHUB_REPO
read -rp "Default Branch [main]: " GITHUB_BRANCH
GITHUB_BRANCH=${GITHUB_BRANCH:-main}

cat > "$OUTPUT" <<EOF
# ============================
# GitHub Repository Info
# ============================

GITHUB_OWNER=${GITHUB_OWNER}
GITHUB_REPO=${GITHUB_REPO}
GITHUB_BRANCH=${GITHUB_BRANCH}
EOF

chmod 644 "$OUTPUT"

echo "✅ Repository information saved to:"
echo "   $OUTPUT"
