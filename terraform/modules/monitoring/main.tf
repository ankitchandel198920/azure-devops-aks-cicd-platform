resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "ops_alerts" {
  name                = "${var.workspace_name}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "OpsAlerts"

  email_receiver {
    name          = "oncall-email"
    email_address = var.alert_email
  }

  tags = var.tags
}
