# Azure Repos Branch Policies & PR Validation

Configure the following branch policies on `main` and `release/*` inside **Azure Repos -> Branches -> Branch Policies**:

1. **Minimum Number of Reviewers:** `2` (disallow requestors from approving their own PRs; reset votes on new pushes).
2. **Check for Linked Work Items:** Required.
3. **Check for Comment Resolution:** Required.
4. **Limit Merge Types:** Squash merge or Rebase only (ensures linear commit history for immutable `$(Build.SourceVersion)` traceability).
5. **Build Validation (Required):**
   - Pipeline: `pipelines/azure-pipelines-pr.yml`
   - Trigger: Automatic
   - Policy requirement: Required (blocks merge on unit test, SonarQube, Trivy, Helm, or Terraform failure).
6. **Automatically Included Reviewers:** Add Platform Security / DevOps Leads as required reviewers for changes under `terraform/`, `pipelines/`, and `security/`.
