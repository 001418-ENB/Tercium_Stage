#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Script de supervision : Redémarrage & état services Prometheus
# Auteur : [Nom de l'opérateur]
# Date : $(date +%F)
# Emplacement : /home/ubuntu/scripts/monitoring/check_and_restart_services.sh
# ─────────────────────────────────────────────────────────────

# Services à surveiller
services=(prometheus node_exporter blackbox_exporter telegraf)

# Relance des services
echo "[+] Redémarrage des services..."
for service in "${services[@]}"; do
  sudo systemctl restart $service
done

# Vérification des statuts
echo -e "\n[+] Vérification des statuts :"
for service in "${services[@]}"; do
  status=$(systemctl is-active $service)
  echo "$service : $status"
done

# Test des interfaces web en local et à distance
declare -A ports=(
  ["Prometheus"]=9091
  ["Node Exporter"]=9100
  ["Blackbox Exporter"]=9115
  ["Grafana"]=3000
)

IP_PUBLIQUE="37.156.46.238"
echo -e "\n[+] Vérification des interfaces HTTP :"
for name in "${!ports[@]}"; do
  port="${ports[$name]}"
  echo -e "\n-- $name ($port) --"
  curl -s --max-time 2 http://localhost:$port >/dev/null && echo "Local OK" || echo "Local KO"
  curl -s --max-time 2 http://$IP_PUBLIQUE:$port >/dev/null && echo "Distant OK" || echo "Distant KO"
done

# Export des résultats
rapport="rapport_etat_services_$(date +%Y%m%d_%H%M).log"
{
  echo "Service;Statut"
  for service in "${services[@]}"; do
    status=$(systemctl is-active $service)
    echo "$service;$status"
  done
} > "$rapport"

echo -e "\n[+] Rapport généré : $rapport"
