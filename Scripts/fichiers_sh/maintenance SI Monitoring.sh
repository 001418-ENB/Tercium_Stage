#!/bin/bash
# extract_probe.sh - Surveillance active Prometheus (métriques critiques)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/prometheus_checks.log"

# Fonction de journalisation
log() {
    echo "$TIMESTAMP - $1" >> "$LOGFILE"
}

# 1. probe_success
PROBE=$(curl -s http://localhost:9091/api/v1/query?query=probe_success | jq -r '.data.result[] | select(.value[1] == "0") | "FAIL: " + .metric.instance')
if [[ -n "$PROBE" ]]; then
    log "🔴 ALERTE : probe_success = 0 sur : $PROBE"
else
    log "✅ probe_success OK"
fi

# 2. node_cpu_seconds_total (global CPU % usage approx)
CPU_IDLE=$(curl -s http://localhost:9091/api/v1/query?query=rate(node_cpu_seconds_total{mode="idle"}[1m]) | jq -r '.data.result[0].value[1]')
CPU_USAGE=$(echo "100 - ($CPU_IDLE * 100)" | bc -l)
if (( $(echo "$CPU_USAGE > 85.0" | bc -l) )); then
    log "⚠️ CPU usage > 85% : $CPU_USAGE%"
else
    log "✅ CPU usage OK : $CPU_USAGE%"
fi

# 3. node_memory_Active_bytes
MEM_USED=$(curl -s http://localhost:9091/api/v1/query?query=node_memory_Active_bytes | jq -r '.data.result[0].value[1]')
MEM_TOTAL=$(curl -s http://localhost:9091/api/v1/query?query=node_memory_MemTotal_bytes | jq -r '.data.result[0].value[1]')
MEM_PCT=$(echo "($MEM_USED/$MEM_TOTAL)*100" | bc -l)
if (( $(echo "$MEM_PCT > 80.0" | bc -l) )); then
    log "⚠️ RAM usage > 80% : $MEM_PCT%"
else
    log "✅ RAM usage OK : $MEM_PCT%"
fi

# 4. probe_http_duration_seconds (latence HTTP)
LATENCY=$(curl -s http://localhost:9091/api/v1/query?query=probe_http_duration_seconds | jq -r '.data.result[0].value[1]')
if (( $(echo "$LATENCY > 1.5" | bc -l) )); then
    log "⚠️ Latence HTTP > 1.5s : $LATENCY s"
else
    log "✅ Latence HTTP OK : $LATENCY s"
fi

log "-- Fin du cycle de test --\n"
