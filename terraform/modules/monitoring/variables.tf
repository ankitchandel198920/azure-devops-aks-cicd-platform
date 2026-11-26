variable "workspace_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "retention_in_days" {
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
