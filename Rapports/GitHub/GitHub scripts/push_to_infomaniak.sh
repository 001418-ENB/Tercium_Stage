#!/bin/bash

# CONFIGURATION
USER_REMOTE="ubuntu"
HOST_REMOTE="your-instance.infomaniak.com"
SSH_PORT=22

# Chemins locaux (adaptés au dépôt Git)
LOCAL_ETC="./etc"
LOCAL_OPT="./opt"

# Chemins distants sur l’instance
REMOTE_ETC="/etc"
REMOTE_OPT="/opt"

echo "[INFO] Début du transfert vers $HOST_REMOTE..."

# Transfert des fichiers de configuration
rsync -avz -e "ssh -p $SSH_PORT" "$LOCAL_ETC/" "$USER_REMOTE@$HOST_REMOTE:$REMOTE_ETC/"
rsync -avz -e "ssh -p $SSH_PORT" "$LOCAL_OPT/" "$USER_REMOTE@$HOST_REMOTE:$REMOTE_OPT/"

echo "[INFO] Transfert terminé avec succès."
