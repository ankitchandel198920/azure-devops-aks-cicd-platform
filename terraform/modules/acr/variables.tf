variable "acr_name" {
  type        = string
  description = "Globally unique Azure Container Registry name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "ACR SKU (Basic, Standard, Premium)"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether public network access is enabled"
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = false
  description = "Enable zone redundancy when SKU is Premium"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}
