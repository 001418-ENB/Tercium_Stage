#!/bin/bash

# Script : change_prometheus_port.sh
# Objectif : Modifier le port Prometheus vers 9091 si systemd est utilisé.

PROM_PORT_OLD=9090
PROM_PORT_NEW=9091
SERVICE_FILE="/etc/systemd/system/prometheus.service"
BACKUP_FILE="/etc/systemd/system/prometheus.service.bak"

echo "[*] Vérification si le port $PROM_PORT_OLD est utilisé..."
if ss -tulpn | grep ":$PROM_PORT_OLD" > /dev/null; then
    echo "[!] Port $PROM_PORT_OLD utilisé (probablement par Jitsi)."
else
    echo "[✓] Port $PROM_PORT_OLD libre."
fi

if [ ! -f "$SERVICE_FILE" ]; then
    echo "[✘] Fichier systemd introuvable : $SERVICE_FILE"
    echo "→ Ce script ne prend en charge que les installations via systemd."
    exit 1
fi

echo "[*] Sauvegarde du fichier systemd dans : $BACKUP_FILE"
sudo cp "$SERVICE_FILE" "$BACKUP_FILE"

echo "[*] Modification du port dans le fichier systemd..."
sudo sed -i "s/--web.listen-address=\"0.0.0.0:$PROM_PORT_OLD\"/--web.listen-address=\"0.0.0.0:$PROM_PORT_NEW\"/" "$SERVICE_FILE"

echo "[*] Rechargement de systemd et redémarrage de Prometheus..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart prometheus

echo "[*] Ouverture du port $PROM_PORT_NEW dans le pare-feu UFW..."
sudo ufw allow "$PROM_PORT_NEW"/tcp

echo "[*] Vérification de l'écoute sur le nouveau port..."
if ss -tulpn | grep ":$PROM_PORT_NEW" > /dev/null; then
    echo "[✓] Prometheus écoute bien sur $PROM_PORT_NEW"
else
    echo "[✘] Problème détecté. Vérifiez le journal : sudo journalctl -u prometheus"
fi
