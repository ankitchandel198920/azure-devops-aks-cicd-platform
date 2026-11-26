#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:?Usage: cleanup.sh <dev|staging|prod>}"
NAMESPACE="microservices-${ENVIRONMENT}"
RELEASE_NAME="enterprise-microservices"

echo "WARNING: This removes Helm release '${RELEASE_NAME}' in '${NAMESPACE}' and destroys Terraform resources for '${ENVIRONMENT}'."
read -r -p "Type '${ENVIRONMENT}' to confirm cleanup: " CONFIRM
if [ "${CONFIRM}" != "${ENVIRONMENT}" ]; then
  echo "Confirmation mismatch. Aborting."
  exit 1
fi

if kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1; then
  helm uninstall "${RELEASE_NAME}" -n "${NAMESPACE}" || true
  kubectl delete namespace "${NAMESPACE}" --wait=false || true
fi

cd "$(dirname "$0")/../terraform"
terraform init -backend-config="environments/backend-${ENVIRONMENT}.hcl" -reconfigure
terraform destroy -var-file="environments/${ENVIRONMENT}.tfvars" -auto-approve
