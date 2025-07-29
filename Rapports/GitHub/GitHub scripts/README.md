# 📡 jitsi-meet-infra

Ce dépôt contient l’ensemble des fichiers critiques de configuration, scripts et automatisations nécessaires pour déployer et maintenir une instance **Jitsi-Meet** sur une infrastructure distante (ex : Infomaniak).

---

## 🧩 Objectifs

- Versionner les fichiers de configuration critiques : `jitsi`, `prosody`, `nginx`, etc.
- Automatiser les transferts vers un serveur distant via `rsync` sécurisé (SSH)
- Permettre un **déploiement manuel ou CI/CD via GitHub Actions**
- Proposer des scripts de **sauvegarde, vérification et rollback**
- Garantir une traçabilité de l’état post-déploiement

---

## 📁 Arborescence

