#!/bin/bash

echo "🔄 Updating services..."

git pull origin main

docker compose pull
docker compose up -d --build --remove-orphans
docker image prune -f

echo "✅ Update complete!"
