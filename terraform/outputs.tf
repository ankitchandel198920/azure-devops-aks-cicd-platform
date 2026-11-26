output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

output "aks_workload_identity_client_id" {
  value = module.aks.workload_identity_client_id
}

output "key_vault_name" {
  value = module.keyvault.name
}

output "log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
}
