variable "location" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

# DEV sizing
variable "dev_node_vm_size" { type = string }
variable "dev_node_count"  { type = number }

# PROD sizing
variable "prod_node_vm_size" { type = string }
variable "prod_node_count"  { type = number }

# Service Principal
variable "service_principal_app_id" { type = string }
variable "service_principal_client_secret" {
  type      = string
  sensitive = true
}