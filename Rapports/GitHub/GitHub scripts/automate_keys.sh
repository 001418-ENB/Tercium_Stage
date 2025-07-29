
---

## ⚙️ 2. Script `automate_keys.sh`

**Nom** : `automate_keys.sh`  
**Emplacement** : `scripts/automate_keys.sh`  
**Rôle** : Génère automatiquement les trois paires de clés avec nommage correct et rappelle les étapes post-génération.

```bash
#!/bin/bash

# === CONFIGURATION DES CHEMINS ===
SSH_DIR="$HOME/.ssh"
KEY_GITHUB="id_rsa_github"
KEY_INFOMANIAK="id_rsa_infomaniak"
KEY_CI="github_action_rsa"

# === GÉNÉRATION DES CLÉS ===

echo "[🔐] Génération de la clé pour GitHub..."
ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/$KEY_GITHUB" -C "github-local@machine" -N ""

echo "[🔐] Génération de la clé pour accès manuel Infomaniak..."
ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/$KEY_INFOMANIAK" -C "local-access@infomaniak" -N ""

echo "[🤖] Génération de la clé pour GitHub Actions (CI/CD)..."
ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/$KEY_CI" -C "gh-actions@jitsi-infra" -N ""

# === CHMOD DE SÉCURITÉ ===

chmod 600 "$SSH_DIR/$KEY_GITHUB" "$SSH_DIR/$KEY_INFOMANIAK" "$SSH_DIR/$KEY_CI"
chmod 644 "$SSH_DIR/$KEY_GITHUB.pub" "$SSH_DIR/$KEY_INFOMANIAK.pub" "$SSH_DIR/$KEY_CI.pub"

# === RAPPEL POST-GÉNÉRATION ===

echo ""
echo "[ℹ️] Étapes suivantes manuelles :"
echo "1. Ajouter la clé publique GITHUB dans : https://github.com/settings/ssh"
echo "2. Copier la clé publique INFOMANIAK sur le serveur avec :"
echo "   ssh-copy-id -i $SSH_DIR/$KEY_INFOMANIAK.pub ubuntu@IP_INFOMANIAK"
echo "3. Ajouter la clé publique CI dans ~/.ssh/authorized_keys sur le serveur :"
echo "   cat $SSH_DIR/$KEY_CI.pub >> ~/.ssh/authorized_keys"
echo "4. Ajouter la clé privée CI dans GitHub Actions → Secrets → SSH_PRIVATE_KEY"

echo "[✅] Toutes les clés sont prêtes."

# chmod +x scripts/automate_keys.sh
# ./scripts/automate_keys.sh
