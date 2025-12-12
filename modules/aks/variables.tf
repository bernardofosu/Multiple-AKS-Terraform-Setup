variable "cluster_name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }
variable "node_vm_size" { type = string }
variable "node_count" { type = number }
variable "service_principal_app_id" { type = string }
variable "service_principal_client_secret" {
  type      = string
  sensitive = true
}