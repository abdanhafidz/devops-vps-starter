# Deployment Guide

## Prerequisites
- A Linux VPS (Ubuntu 20.04+ recommended)
- SSH Access
- Docker & Docker Compose (installed via `setup.sh`)

## Initial Setup

1. **Clone the Repository**
   ```bash
   git clone <your-repo-url> /opt/quzuu
   cd /opt/quzuu
   ```

2. **Run Bootstrap Script**
   This script installs Docker, sets up firewall, and hardens SSH.
   ```bash
   sudo chmod +x setup.sh
   sudo ./setup.sh
   ```

3. **Configure Environment**
   Calculated from `cmd/config`.
   - Edit `cmd/config/app.env` for general settings.
   - Edit files in `cmd/config/secrets/` for sensitive data.
   
   ```bash
   nano cmd/config/app.env
   nano cmd/config/secrets/postgres_passwd
   ```

## Launching Services

Start the entire stack:
```bash
docker compose up -d --build
```

### Accessing Services
- **Frontend / Main Site**: `http://<your-ip>`
- **Backend API**: `http://<your-ip>/api/`
- **Grafana**: `http://<your-ip>:3000` (Default login: admin / <value in secrets/grafana_admin_passwd>)
- **Uptime Kuma**: `http://<your-ip>:3001`
- **Supabase Studio**: `http://<your-ip>:3002`

