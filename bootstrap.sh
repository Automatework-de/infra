#!/usr/bin/env bash
set -euo pipefail

# === Variablen anpassen ===
DEPLOY_USER="silas"
SSH_PUBLIC_KEY_URL="https://github.com/silas.keys"
DOMAIN="backend.automatework.de"
ADMIN_EMAIL="silas@automatework.de"

# 1) User & SSH-Key
adduser --disabled-password --gecos "" "$DEPLOY_USER"
mkdir -p /home/"$DEPLOY_USER"/.ssh
curl -fsSL "$SSH_PUBLIC_KEY_URL" \
  > /home/"$DEPLOY_USER"/.ssh/authorized_keys
chown -R "$DEPLOY_USER":"$DEPLOY_USER" /home/"$DEPLOY_USER"/.ssh
chmod 700 /home/"$DEPLOY_USER"/.ssh
chmod 600 /home/"$DEPLOY_USER"/.ssh/authorized_keys

# 2) System-Update & Docker, UFW
apt update && apt upgrade -y
apt install -y docker.io ufw

# 3) Docker Compose
curl -fsSL \
  "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 4) UFW konfigurieren
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw --force enable

# 5) Caddy installieren & einrichten
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -fsSL 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | gpg --dearmor \
  > /usr/share/keyrings/caddy-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] \
  https://dl.cloudsmith.io/public/caddy/stable/debian any-version main" \
  > /etc/apt/sources.list.d/caddy-stable.list
apt update && apt install -y caddy

cat <<EOC > /etc/caddy/Caddyfile
$DOMAIN {
  encode gzip
  reverse_proxy unix//var/run/docker.sock
  tls $ADMIN_EMAIL
}
EOC
systemctl reload caddy
