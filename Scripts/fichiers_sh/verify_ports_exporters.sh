#!/bin/bash

#script de confirmation post_calibage : lister les ports modifier / vérifier que chaque exporter est à l'écoute et que grafana les voit via prometheus

# Ports configurés manuellement dans Prometheus + exporters
declare -A services_ports=(
  ["prometheus"]="9091"
  ["blackbox_exporter"]="9116"
  ["node_exporter"]="9101"
  ["telegraf_exporter"]="9273"
)

echo "🔍 Vérification des services en écoute sur les ports personnalisés :"
for service in "${!services_ports[@]}"; do
    port=${services_ports[$service]}
    echo -n "🟡 $service → Port $port : "
    if ss -tulpn | grep ":$port" > /dev/null; then
        echo "🟢 En écoute"
    else
        echo "🔴 Non détecté"
    fi
done

echo ""
echo "📦 Vérification de la cible Prometheus :"
curl -s "http://localhost:9091/-/targets" | grep -E '"health"|scrapeUrl' | sed 's/^[ \t]*//'

# droit d'execution: chmod +x verify_ports_exporters.sh
