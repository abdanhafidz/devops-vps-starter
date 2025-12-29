#!/usr/bin/env bash
set -e

source ../../config/secrets/github.info.env
source ../../config/secrets/github.auth.env

if [[ "$GITHUB_AUTH_TYPE" == "https" ]]; then
  export GITHUB_REPO_URL="https://${GITHUB_OWNER}:${GITHUB_TOKEN}@github.com/${GITHUB_OWNER}/${GITHUB_REPO}.git"
else
  export GITHUB_REPO_URL="git@github.com:${GITHUB_OWNER}/${GITHUB_REPO}.git"
fi

echo "GITHUB_REPO_URL=${GITHUB_REPO_URL}"
