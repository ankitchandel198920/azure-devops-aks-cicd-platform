# Cost Estimation Assumptions

> Note: Actual Azure billing varies by region, currency, reservations, and traffic volume. Always verify current pricing with the official Azure Pricing Calculator before provisioning.

| Resource | Dev Assumption | Staging Assumption | Production Assumption | Cost Drivers |
| :--- | :--- | :--- | :--- | :--- |
| **AKS Control Plane** | Free / Standard tier | Standard tier (SLA) | Standard tier (Uptime SLA) | Cluster tier SLA fee |
| **AKS Node Pool** | 1–3x `Standard_B2s` | 2–4x `Standard_D2s_v3` | 3–6x `Standard_D4s_v3` | VM size, node count, uptime hours |
| **Azure Container Registry** | `Standard` SKU | `Standard` SKU | `Premium` SKU (zone redundancy) | SKU base fee + image storage GB |
| **Azure Key Vault** | `Standard` tier | `Standard` tier | `Standard` tier | Secret operations per 10k requests |
| **Log Analytics** | 30-day retention | 30-day retention | 90-day retention | Daily log ingestion GB |

**Optimization Levers:**
- Enable AKS cluster autoscaler (`min_count` / `max_count`) and schedule off-hours scale-down for Dev/Staging.
- Configure ACR retention policies to purge untagged manifests older than 30 days.
