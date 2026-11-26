# Security, RBAC & Workload Identity Architecture

## Zero-Static-Secret Design
- **Pipeline Authentication:** Azure DevOps service connections (`sc-azure-dev-wif`, `sc-azure-staging-wif`, `sc-azure-prod-wif`, `sc-acr-workload-identity`) use **Workload Identity Federation (OIDC)** instead of client secrets.
- **Pod-to-Key-Vault Authentication:** AKS runs with `oidc_issuer_enabled = true` and `workload_identity_enabled = true`. A User-Assigned Managed Identity (`<cluster>-workload-uami`) is federated to `system:serviceaccount:<namespace>:microservices-workload-sa` and granted **Key Vault Secrets User** (never Contributor or Owner).
- **ACR Pull Least Privilege:** AKS kubelet identity receives only `AcrPull` on the ACR scope; `admin_enabled` is forced to `false`.

## Container & Kubernetes Hardening
- Non-root container execution (`runAsNonRoot: true`, `allowPrivilegeEscalation: false`, `readOnlyRootFilesystem: true`, `capabilities.drop: ["ALL"]`).
- `NetworkPolicy` restricts backend port `8080` ingress strictly to pods with `app: web-frontend`.
- Trivy scans block CI builds on `HIGH` or `CRITICAL` vulnerabilities in dependencies, IaC templates, and container images.
