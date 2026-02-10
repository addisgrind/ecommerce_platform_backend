#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-https://api.enterprise-retail.internal}"
ALERT_WEBHOOK="${ALERT_WEBHOOK:-https://hooks.enterprise-retail.internal/alerts/backend}"
SERVICES=("/healthz" "/api/v1/auth/health" "/api/v1/catalog/health" "/api/v1/orders/health")
LATENCY_THRESHOLD_MS=800

now_utc() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

emit_alert() {
  local endpoint="$1"
  local status_code="$2"
  local latency_ms="$3"

  curl -sS -X POST "${ALERT_WEBHOOK}" \
    -H "Content-Type: application/json" \
    -d "{\"timestamp\":\"$(now_utc)\",\"endpoint\":\"${endpoint}\",\"status_code\":${status_code},\"latency_ms\":${latency_ms},\"severity\":\"critical\"}" >/dev/null
}

for endpoint in "${SERVICES[@]}"; do
  start_ms=$(date +%s%3N)
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}${endpoint}")
  end_ms=$(date +%s%3N)
  latency_ms=$((end_ms - start_ms))

  echo "[$(now_utc)] endpoint=${endpoint} status=${status_code} latency_ms=${latency_ms}"

  if [[ "${status_code}" -ge 500 || "${latency_ms}" -gt "${LATENCY_THRESHOLD_MS}" ]]; then
    emit_alert "${endpoint}" "${status_code}" "${latency_ms}"
  fi

done
