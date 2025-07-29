#!/bin/bash

# Charger la config .env si elle existe
if [ -f .env ]; then
    source .env
else
    echo "⚠️  Fichier .env manquant. Variables REMOTE_USER et REMOTE_HOST non chargées."
    exit 1
fi

# Valeurs par défaut si .env absent
REMOTE_USER=${REMOTE_USER:-ubuntu}
REMOTE_HOST=${REMOTE_HOST:-1.2.3.4}
SSH_PORT=${SSH_PORT:-22}

echo "🔍 Test de connexion SSH vers ${REMOTE_USER}@${REMOTE_HOST} (port ${SSH_PORT})..."

# Test SSH (non interactif)
ssh -o BatchMode=yes -p ${SSH_PORT} ${REMOTE_USER}@${REMOTE_HOST} "echo ✅ Connexion SSH réussie." 2>/dev/null

if [ $? -ne 0 ]; then
    echo "❌ Connexion SSH échouée. Vérifie la clé publique, l'adresse IP, ou le pare-feu."
    exit 2
else
    echo "🚀 Prêt pour le déploiement."
fi

chmod +x check-deploy.sh
