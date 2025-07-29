#!/bin/bash
# restore_prometheus_from_snapshot.sh
# Relance Prometheus depuis un snapshot monté

SNAPSHOT_PATH="/mnt/snapshot_restore"
PROMETHEUS_ETC="/etc/prometheus"
PROMETHEUS_OPT="/opt/prometheus"

echo "[*] Restauration des fichiers de configuration..."
sudo cp -r $SNAPSHOT_PATH/etc/prometheus/* $PROMETHEUS_ETC/
sudo cp -r $SNAPSHOT_PATH/opt/prometheus/* $PROMETHEUS_OPT/

echo "[*] Attribution des droits..."
sudo chown -R prometheus:prometheus $PROMETHEUS_ETC $PROMETHEUS_OPT

echo "[*] Redémarrage des services..."
sudo systemctl daemon-reexec
sudo systemctl restart prometheus
sudo systemctl restart prometheus-node-exporter

echo "[✓] Restauration terminée."
