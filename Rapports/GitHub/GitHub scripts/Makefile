# Makefile – Automatisation des routines Jitsi-Meet vers Infomaniak

# Chargement du fichier .env
include .env

# Déclaration des cibles non-fichiers
.PHONY: help deploy push check backup rollback verify ci_test

# Cible par défaut
help:
	@echo "Commandes disponibles :"
	@echo "  make deploy             → Exécute push_to_infomaniak.sh"
	@echo "  make push               → Transfert /etc/ et /opt/ vers serveur"
	@echo "  make backup             → Crée un backup distant horodaté"
	@echo "  make rollback BACKUP=2025-07-28_1500"
	@echo "  make check              → Vérifie les services, ports et logs"
	@echo "  make verify             → Exécute le script post-deploy complet"
	@echo "  make ci_test            → Simule un push CI vers instance"

# Transfert manuel par rsync
push:
	rsync -avz -e "ssh -p $(SSH_PORT)" ./etc/ $(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_ETC)/
	rsync -avz -e "ssh -p $(SSH_PORT)" ./opt/ $(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_OPT)/

# Déploiement complet via script
deploy:
	bash scripts/push_to_infomaniak.sh

# Sauvegarde distante horodatée
backup:
	ssh -p $(SSH_PORT) $(REMOTE_USER)@$(REMOTE_HOST) "\
		sudo rsync -a $(REMOTE_ETC)/ $(REMOTE_BACKUP_ETC)/jitsi_$$(date +%F_%H%M)/ && \
		sudo rsync -a $(REMOTE_OPT)/ $(REMOTE_BACKUP_OPT)/jitsi_$$(date +%F_%H%M)/"

# Rollback à une version sauvegardée
rollback:
	@if [ -z "$(BACKUP)" ]; then \
		echo "❌ Usage : make rollback BACKUP=2025-07-28_1500"; exit 1; \
	fi
	bash scripts/rollback.sh $(BACKUP)

# Vérification manuelle via ssh
check:
	ssh -p $(SSH_PORT) $(REMOTE_USER)@$(REMOTE_HOST) "echo '[✓] Connexion réussie à $(REMOTE_HOST)'"

# Vérification complète post-déploiement
verify:
	bash scripts/post-deploy.sh

# Test CI simulé localement
ci_test:
	@echo "Simulation d’un push GitHub Actions vers $(REMOTE_HOST)"
	rsync -avz -e "ssh -p $(SSH_PORT)" ./etc/ $(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_ETC)/
