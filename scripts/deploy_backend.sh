#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-production}"
IMAGE_TAG="${2:-$(date -u +%Y%m%d%H%M)}"
NAMESPACE="ecommerce-backend"
DEPLOYMENT="backend-api"
KUBECTL_CONTEXT="prod-cluster"

log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*"
}

log "Starting deployment env=${ENVIRONMENT} image_tag=${IMAGE_TAG}"

kubectl --context "${KUBECTL_CONTEXT}" -n "${NAMESPACE}" set image deployment/"${DEPLOYMENT}" \
  backend-api=registry.enterprise-retail.com/ecommerce/backend-api:"${IMAGE_TAG}"

kubectl --context "${KUBECTL_CONTEXT}" -n "${NAMESPACE}" rollout status deployment/"${DEPLOYMENT}" --timeout=180s

CURRENT_REVISION=$(kubectl --context "${KUBECTL_CONTEXT}" -n "${NAMESPACE}" rollout history deployment/"${DEPLOYMENT}" | tail -n 1 | awk '{print $1}')
log "Deployment complete revision=${CURRENT_REVISION}"
