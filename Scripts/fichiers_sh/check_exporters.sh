#!/bin/bash
# 📡 Script de supervision des ports Prometheus & Exporters
# 🕒 Généré le : 2025-07-22 12:56:54
# ----------------------------------------------------------

echo "=== 🔎 Vérification avec ss (socket stat) ==="
sudo ss -tuln | grep -E ':9091|:9116|:9101|:9273'

echo -e "\n=== 🔎 Vérification avec netstat ==="
sudo netstat -tulnp | grep -E '9091|9116|9101|9273'

echo -e "\n=== 🔎 Scan NMAP local ==="
sudo nmap -sT -p 9091,9116,9101,9273 127.0.0.1

echo -e "\n=== 🔎 Export depuis Prometheus API ==="
curl -s http://localhost:9091/api/v1/targets | jq '.data.activeTargets[] | {instance, job, health, scrapeUrl, lastError}'

echo -e "\n=== ✅ Fin de vérification ==="
