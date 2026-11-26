variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "acr_name" {
  type = string
}

variable "acr_sku" {
  type    = string
  default = "Standard"
}

variable "acr_public_access" {
  type    = bool
  default = true
}

variable "acr_zone_redundancy" {
  type    = bool
  default = false
}

variable "kubernetes_version" {
  type    = string
  default = "1.30"
}

variable "system_node_count" {
  type    = number
  default = 2
}

variable "system_min_count" {
  type    = number
  default = 2
}

variable "system_max_count" {
  type    = number
  default = 4
}

variable "system_vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "app_namespace" {
  type    = string
  default = "microservices-dev"
}

variable "key_vault_name" {
  type = string
}

variable "kv_purge_protection" {
  type    = bool
  default = true
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "alert_email" {
  type    = string
  default = "devops-alerts@example.com"
}

variable "tags" {
  type    = map(string)
  default = {}
}
