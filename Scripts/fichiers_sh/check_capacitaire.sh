#!/bin/bash
# Script de diagnostic capacitaire système – check_capacitaire.sh
# Enregistre les infos de charge système dans ~/monitoring/logs/capacitaire_YYYYMMDD_HHMM.log

LOG_DIR="$HOME/monitoring/logs"
mkdir -p "$LOG_DIR"
DATE=$(date +"%Y%m%d_%H%M")
LOG_FILE="$LOG_DIR/capacitaire_${DATE}.log"

{
  echo "===== CHECK CAPACITAIRE $(date) ====="
  echo ""
  echo "► Uptime et charge moyenne :"
  uptime
  echo ""
  echo "► Mémoire RAM utilisée :"
  free -h
  echo ""
  echo "► Utilisation du disque racine :"
  df -h /
  echo ""
  echo "► Adresse IP & Interfaces réseau :"
  ip a | grep inet
  echo ""
  echo "► Services Prometheus :"
  systemctl status prometheus.service --no-pager | head -n 10
  systemctl status node_exporter.service --no-pager | head -n 10
  systemctl status blackbox_exporter.service --no-pager | head -n 10
  echo ""
  echo "► Exporters accessibles depuis Prometheus :"
  curl -s http://localhost:9091/targets | grep -E 'job=|health' | sed 's/^[ \t]*//'
  echo ""
  echo "► TOP 5 CPU :"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
  echo ""
  echo "► TOP 5 RAM :"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
} > "$LOG_FILE"
