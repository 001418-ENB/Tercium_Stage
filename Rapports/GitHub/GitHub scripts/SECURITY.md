# 🔐 SECURITY.md

## Objectif

Ce dépôt utilise un système de gestion de clés SSH sécurisé, avec séparation stricte des usages :

- 🔄 Git personnel ↔️ GitHub
- 📤 Déploiement manuel ↔️ Serveur Infomaniak
- 🤖 Déploiement automatisé (CI/CD) ↔️ Serveur Infomaniak

---

## 🔐 Clés SSH utilisées

| Clé | Rôle | Emplacement | Commentaires |
|-----|------|-------------|--------------|
| `id_rsa_github` | Git push/pull personnel | `~/.ssh/id_rsa_github` | Ajoutée à GitHub via interface |
| `id_rsa_infomaniak` | Connexion manuelle serveur | `~/.ssh/id_rsa_infomaniak` | Ajoutée avec `ssh-copy-id` |
| `github_action_rsa` | GitHub Actions → Serveur | Dans `Secrets` GitHub (`SSH_PRIVATE_KEY`) | Publique ajoutée sur le serveur |

---

## 🔐 Configuration du fichier SSH `~/.ssh/config`

```ssh
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_github

Host infomaniak
  HostName IP_INFOMANIAK
  User ubuntu
  IdentityFile ~/.ssh/id_rsa_infomaniak
