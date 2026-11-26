# Troubleshooting Guide

| Symptom | Likely Cause | Diagnostic Command | Remediation |
| :--- | :--- | :--- | :--- |
| `ImagePullBackOff` on AKS | Missing `AcrPull` role or wrong ACR login server | `kubectl describe pod <pod> -n <ns>` | Verify `azurerm_role_assignment.aks_acr_pull` and `global.acrLoginServer` |
| Key Vault CSI mount fails | Federated identity subject mismatch (`namespace` or `serviceaccount`) | `kubectl logs -l app=secrets-store-csi-driver -n kube-system` | Match `subject` in `terraform/modules/aks/main.tf` to `system:serviceaccount:<ns>:microservices-workload-sa` |
| Helm upgrade times out & rolls back | Failing `/readyz` probe or insufficient node CPU/memory | `helm history enterprise-microservices -n <ns>` | Check `kubectl get events -n <ns>` and pod logs; use `scripts/rollback.sh` if manual revert needed |
| SonarQube Quality Gate fails | Coverage below threshold or new blocker code smell | Review SonarQube PR/branch dashboard | Fix coverage/smells locally and re-push |
| Trivy blocks CI push | OS package or npm dependency has HIGH/CRITICAL CVE | Run `trivy image <image>` locally | Update base image (`node:22-alpine`) or dependency version |
