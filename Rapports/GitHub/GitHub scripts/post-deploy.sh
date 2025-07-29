#!/bin/bash

# === CONFIGURATION ===
REMOTE_USER="ubuntu"
REMOTE_HOST="IP_INFOMANIAK"
SSH_PORT=22

echo "[🔍] Vérification post-déploiement de l’instance..."

ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST << 'EOF'
echo "[✅] Connecté à $(hostname) - $(date)"

echo -e "\n[🧠] Uptime :"
uptime

echo -e "\n[🧩] Services Jitsi :"
sudo systemctl status prosody.service --no-pager | grep Active
sudo systemctl status jicofo.service --no-pager | grep Active
sudo systemctl status jitsi-videobridge2.service --no-pager | grep Active

echo -e "\n[🛰️] Ports ouverts :"
sudo ss -tuln | grep -E '443|4443|10000'

echo -e "\n[📝] Dernières erreurs dans /var/log :"
sudo tail -n 15 /var/log/syslog | grep -iE "fail|error|jitsi|prosody|jicofo"

EOF
