#!/bin/bash

# === CONFIGURATION ===
REMOTE_USER="ubuntu"
REMOTE_HOST="IP_INFOMANIAK"
SSH_PORT=22
BACKUP_DATE="$1"  # Exemple : 2025-07-28_1500

if [ -z "$BACKUP_DATE" ]; then
  echo "❌ Usage : rollback.sh <DATE_BACKUP ex: 2025-07-28_1500>"
  exit 1
fi

echo "[⚠️] Lancement du rollback vers la version $BACKUP_DATE"

ssh -p $SSH_PORT $REMOTE_USER@$REMOTE_HOST << EOF

# === RESTAURATION ===

echo "[⏪] Restauration de /etc/jitsi depuis /backup/etc/jitsi_$BACKUP_DATE"
sudo rsync -av --delete /backup/etc/jitsi_$BACKUP_DATE/ /etc/jitsi/

echo "[⏪] Restauration de /opt/jitsi depuis /backup/opt/jitsi_$BACKUP_DATE"
sudo rsync -av --delete /backup/opt/jitsi_$BACKUP_DATE/ /opt/jitsi/

# === REDEMARRAGE DES SERVICES ===

echo "[🔁] Redémarrage des services Jitsi"
sudo systemctl restart prosody
sudo systemctl restart jicofo
sudo systemctl restart jitsi-videobridge2

EOF

echo "[✅] Rollback vers $BACKUP_DATE terminé."
