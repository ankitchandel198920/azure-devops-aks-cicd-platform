# Architecture Overview

```mermaid
flowchart LR
    DEV[Developer PR] --> PR[Azure Pipelines PR Gate<br/>Tests · Helm Lint · TF Validate · Trivy]
    PR -->|Merge to main| CI[Azure Pipelines CI<br/>Unit Tests + Coverage · SonarQube · Docker Build]
    CI -->|Trivy Image Gate| ACR[(Azure Container Registry<br/>Immutable Tag: BuildId-SHA)]
    ACR --> CD_DEV[CD: Dev AKS<br/>Helm Atomic + Smoke Test]
    CD_DEV --> CD_STG[CD: Staging AKS<br/>Helm Atomic + Smoke Test]
    CD_STG -->|Manual Approval Gate| CD_PROD[CD: Production AKS<br/>Helm Atomic + Auto Rollback]
    AKS_WI[AKS Workload Identity OIDC] --> KV[Azure Key Vault CSI]
    AKS_MON[AKS Container Insights] --> LAW[Azure Monitor & Log Analytics]
```

## Immutable Image Tagging Strategy
Every CI build tags images with `$(Build.BuildId)-$(Build.SourceVersion)` and `sha-$(Build.SourceVersion)`. `latest` is never used in Helm values or CD deployments, ensuring deterministic rollbacks and exact commit-to-pod auditability.
