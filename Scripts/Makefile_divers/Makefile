# Makefile pour automatiser les vérifications Prometheus & Exporters

# Variables
SCRIPTS_DIR=./scripts

# Cibles principales
check:
	@echo "▶️ Lancement de check_exporters.sh"
	@$(SCRIPTS_DIR)/check_exporters.sh

verify:
	@echo "▶️ Lancement de verify_ports_exporters.sh"
	@$(SCRIPTS_DIR)/verify_ports_exporters.sh

change:
	@echo "▶️ Lancement de change_prometheus_port.sh"
	@$(SCRIPTS_DIR)/change_prometheus_port.sh

all: check verify change
	@echo "✅ Tous les scripts exécutés."

help:
	@echo "Cibles disponibles :"
	@echo "  make check     → Vérifie les exporters (targets Prometheus)"
	@echo "  make verify    → Vérifie les ports des exporters"
	@echo "  make change    → Script de vérification des ports avec logique avancée"
	@echo "  make all       → Exécute toutes les vérifications"
