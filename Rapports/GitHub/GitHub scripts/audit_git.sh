#!/bin/bash

echo "===== RAPPORT D'AUDIT GIT / GITHUB ====="
echo

# 1. Infos Git globales
echo "[CONFIG GIT GLOBALE]"
git config --global user.name
git config --global user.email
echo

# 2. Remotes
echo "[REMOTE(S) CONFIGURÉE(S)]"
git remote -v
echo

# 3. Premier commit (si le repo est initialisé)
if [ -d ".git" ]; then
    echo "[PREMIER COMMIT DÉTECTÉ]"
    git log --reverse --format="%h %an <%ae> %ad" | head -n 1
else
    echo "[INFO] Pas de dépôt Git initialisé dans ce répertoire."
fi
echo

# 4. Clés SSH présentes
echo "[CLÉS SSH DÉTECTÉES]"
ls -l ~/.ssh
echo

# 5. Test SSH vers GitHub
echo "[TEST DE CONNEXION SSH AVEC GITHUB]"
ssh -T git@github.com 2>&1 | grep -v "Hi" || echo "Connexion échouée ou clé non enregistrée."
echo

# 6. Empreinte SHA de la clé publique locale (si présente)
if [ -f ~/.ssh/id_rsa.pub ]; then
    echo "[EMPREINTE DE LA CLÉ PUBLIQUE LOCALE]"
    ssh-keygen -lf ~/.ssh/id_rsa.pub
else
    echo "Clé publique ~/.ssh/id_rsa.pub non trouvée."
fi

echo
echo "===== FIN DU RAPPORT ====="

chmod +x audit_git.sh
