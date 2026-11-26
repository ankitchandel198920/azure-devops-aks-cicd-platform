variable "cluster_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
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

variable "log_analytics_workspace_id" {
  type = string
}

variable "action_group_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "app_namespace" {
  type    = string
  default = "microservices-dev"
}

variable "tags" {
  type    = map(string)
  default = {}
}
