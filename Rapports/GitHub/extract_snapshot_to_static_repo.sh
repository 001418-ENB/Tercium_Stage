#!/bin/bash
# extract_snapshot_to_static_repo.sh
# Extrait les fichiers utiles depuis un snapshot monté vers le dépôt statique Git

SNAPSHOT_PATH="/mnt/snapshot_restore"
STATIC_REPO_PATH="$HOME/Documents/Tercium_Stage/Reserves_Statiques/jitsi-meet-infra_snapshot_$(date +%F)"

echo "[*] Création du dossier de snapshot local : $STATIC_REPO_PATH"
mkdir -p $STATIC_REPO_PATH/prometheus_config
mkdir -p $STATIC_REPO_PATH/consoles

echo "[*] Copie des fichiers de configuration Prometheus..."
cp $SNAPSHOT_PATH/etc/prometheus/*.yml $STATIC_REPO_PATH/prometheus_config/
cp -r $SNAPSHOT_PATH/opt/prometheus/consoles/* $STATIC_REPO_PATH/consoles/

echo "[✓] Extraction terminée. Pensez à valider ce commit dans le dépôt statique."
