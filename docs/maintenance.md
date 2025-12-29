# Maintenance Guide

## Updates

To update the application code and Docker images:
```bash
chmod +x app/scripts/update.sh
./app/scripts/update.sh
```

This script will:
1. Pull latest git changes.
2. Pull latest docker images.
3. Rebuild and restart containers.
4. Prune unused images.

## Backups

To backup the database and critical volumes:
```bash
chmod +x app/scripts/backup.sh
./app/scripts/backup.sh
```
Files are saved to `./backups/`.

## Logs

View logs for specific services:
```bash
docker compose logs -f backend
docker compose logs -f nginx
```

## Security Checklist
- [ ] SSH Password Authentication Disabled (Done by `setup.sh`)
- [ ] Firewall enabled (Done by `setup.sh`)
- [ ] Default passwords changed (Grafana, Postgres, Kuma)
- [ ] SSL/TLS Certificates configured (Recommended to use Nginx Proxy Manager or Certbot on host for 443)
