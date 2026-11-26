# Manual Azure & Azure DevOps Setup Requirements

Because enterprise governance separates initial tenant bootstrap from application pipelines, the following items require one-time manual configuration in an active Azure subscription and Azure DevOps organization:

1. **Terraform Remote State Storage Account:**
   - Provision Resource Group `rg-tfstate-platform`, Storage Account `sttfstateakscicd001`, and Blob Container `tfstate` before running `terraform init`.
2. **Azure DevOps Workload Identity Service Connections:**
   - Create Federated Service Connections in **Project Settings -> Service connections**:
     - `sc-azure-dev-wif`, `sc-azure-staging-wif`, `sc-azure-prod-wif`
     - `sc-acr-workload-identity`
3. **SonarQube Server & Service Connection:**
   - Deploy or connect SonarQube and register `sc-sonarqube-enterprise` with an authentication token.
4. **Azure DevOps Environments & Approval Gates:**
   - Create environments `aks-dev`, `aks-staging`, and `aks-prod`.
   - On `aks-prod`, add **Approvals and checks -> Approvals** (require Release Manager / Security Lead sign-off) and **Branch control** (`refs/heads/main` only).
5. **Variable Groups:**
   - Create `enterprise-ci-shared-vars` (`ACR_LOGIN_SERVER`) and `enterprise-cd-shared-vars` (`ACR_LOGIN_SERVER`, `DEV_RESOURCE_GROUP`, `DEV_AKS_CLUSTER`, `DEV_KEY_VAULT`, `STAGING_*`, `PROD_*`, and optional `TEAMS_ALERT_WEBHOOK_URL` secret).
6. **Key Vault Secrets:**
   - Populate `app-telemetry-key` and `backend-api-token` in each environment's Key Vault after Terraform provisions the vaults.
