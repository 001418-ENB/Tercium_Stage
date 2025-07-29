#!/bin/bash
# check_prometheus_structure.sh – Vérifie l’arborescence Prometheus binaire

# Répertoires attendus
OPT_DIR="/opt/prometheus"
ETC_DIR="/etc/prometheus"
BINARIES=("prometheus" "promtool")
CONFIG="$ETC_DIR/prometheus.yml"

echo "🔍 Vérification de l’installation Prometheus (/opt et /etc)..."

# Vérifie les binaires
for bin in "${BINARIES[@]}"; do
    if [ ! -f "$OPT_DIR/$bin" ]; then
        echo "❌ Binaire manquant : $OPT_DIR/$bin"
    else
        echo "✅ $bin présent"
    fi
done

# Vérifie le fichier de configuration
if [ ! -f "$CONFIG" ]; then
    echo "❌ Fichier de configuration manquant : $CONFIG"
else
    echo "✅ Fichier de configuration trouvé : $CONFIG"
fi

# Vérifie les consoles
for folder in "consoles" "console_libraries"; do
    if [ ! -d "$ETC_DIR/$folder" ]; then
        echo "⚠️ Dossier $folder manquant dans $ETC_DIR"
    else
        echo "✅ Dossier $folder présent dans $ETC_DIR"
    fi
done

# Vérifie la base de données Prometheus
if [ ! -d "$OPT_DIR/data" ]; then
    echo "⚠️ Dossier /data manquant dans $OPT_DIR"
else
    echo "✅ Dossier de données présent"
fi
