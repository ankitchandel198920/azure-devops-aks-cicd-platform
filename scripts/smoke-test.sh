#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:?Usage: smoke-test.sh <namespace> <release-name>}"
RELEASE_NAME="${2:?Usage: smoke-test.sh <namespace> <release-name>}"

echo "Verifying rollout status in namespace ${NAMESPACE}..."
kubectl rollout status deployment/orders-backend -n "${NAMESPACE}" --timeout=120s
kubectl rollout status deployment/web-frontend -n "${NAMESPACE}" --timeout=120s

echo "Checking Helm release status..."
helm status "${RELEASE_NAME}" -n "${NAMESPACE}"

echo "Running in-cluster HTTP smoke check against backend and frontend..."
kubectl run "smoke-${RANDOM}" \
  --namespace="${NAMESPACE}" \
  --rm -i --restart=Never \
  --image=curlimages/curl:8.10.1 \
  --command -- sh -c "
    curl -sf http://orders-backend:8080/healthz &&
    curl -sf http://orders-backend:8080/api/v1/orders &&
    curl -sf http://web-frontend:80/healthz
  "
echo "Smoke tests passed for ${NAMESPACE}."
