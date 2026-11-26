locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Platform    = "Azure-DevOps-AKS-CICD"
  })
}

resource "azurerm_resource_group" "this" {
  name     = "rg-aks-cicd-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  workspace_name      = "law-aks-cicd-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  retention_in_days   = var.log_retention_days
  alert_email         = var.alert_email
  tags                = local.common_tags
}

module "acr" {
  source = "./modules/acr"

  acr_name                      = var.acr_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  sku                           = var.acr_sku
  public_network_access_enabled = var.acr_public_access
  zone_redundancy_enabled       = var.acr_zone_redundancy
  tags                          = local.common_tags
}

module "aks" {
  source = "./modules/aks"

  cluster_name               = "aks-cicd-${var.environment}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  dns_prefix                 = "aks-cicd-${var.environment}"
  kubernetes_version         = var.kubernetes_version
  system_node_count          = var.system_node_count
  system_min_count           = var.system_min_count
  system_max_count           = var.system_max_count
  system_vm_size             = var.system_vm_size
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  action_group_id            = module.monitoring.action_group_id
  acr_id                     = module.acr.id
  app_namespace              = var.app_namespace
  tags                       = local.common_tags
}

module "keyvault" {
  source = "./modules/keyvault"

  key_vault_name           = var.key_vault_name
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  purge_protection_enabled = var.kv_purge_protection
  workload_principal_id    = module.aks.workload_identity_principal_id
  tags                     = local.common_tags
}
