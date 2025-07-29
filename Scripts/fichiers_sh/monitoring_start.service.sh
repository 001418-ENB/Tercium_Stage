#!/bin/bash

# 📌 Variables
SERVICE_NAME="monitoring-start"
WORKDIR="/opt/monitoring"
MAKE_CMD="/usr/bin/make start"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

# 🛑 Vérifie si le dossier cible existe
if [ ! -d "$WORKDIR" ]; then
  echo "❌ Le dossier $WORKDIR est introuvable. Abandon."
  exit 1
fi

# 📄 Génère le fichier systemd
echo "📝 Création du service systemd : $SERVICE_PATH"
sudo tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Démarrage automatique de Prometheus + Exporters via Makefile
After=network.target

[Service]
Type=oneshot
WorkingDirectory=${WORKDIR}
ExecStart=${MAKE_CMD}
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# 🔄 Rechargement systemd
echo "🔄 Rechargement des unités systemd..."
sudo systemctl daemon-reexec

# ✅ Activation et démarrage immédiat
echo "🚀 Activation et lancement du service ${SERVICE_NAME}..."
sudo systemctl enable "${SERVICE_NAME}.service"
sudo systemctl start "${SERVICE_NAME}.service"

# 🔍 Vérification
echo ""
sudo systemctl status "${SERVICE_NAME}.service" --no-pager
