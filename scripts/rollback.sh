#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:?Usage: rollback.sh <namespace> <release-name> [revision]}"
RELEASE_NAME="${2:?Usage: rollback.sh <namespace> <release-name> [revision]}"
REVISION="${3:-0}"

echo "Current Helm history for ${RELEASE_NAME} in ${NAMESPACE}:"
helm history "${RELEASE_NAME}" -n "${NAMESPACE}"

if [ "${REVISION}" -gt 0 ]; then
  helm rollback "${RELEASE_NAME}" "${REVISION}" -n "${NAMESPACE}" --wait --timeout 5m
else
  helm rollback "${RELEASE_NAME}" -n "${NAMESPACE}" --wait --timeout 5m
fi

kubectl rollout status deployment/orders-backend -n "${NAMESPACE}" --timeout=120s
kubectl rollout status deployment/web-frontend -n "${NAMESPACE}" --timeout=120s
echo "Rollback verified successfully."
