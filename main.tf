# 🟢 DEV AKS
module "aks_dev" {
  source = "./modules/aks"

  cluster_name        = "nakodtech-dev-cluster"
  resource_group_name = "nakodtech-dev-rg"
  location            = var.location
  dns_prefix          = "nakodtech-dev"

  kubernetes_version  = var.kubernetes_version
  node_vm_size        = var.dev_node_vm_size
  node_count          = var.dev_node_count

  service_principal_app_id     = var.service_principal_app_id
  service_principal_client_secret = var.service_principal_client_secret
}

# 🔴 PROD AKS
module "aks_prod" {
  source = "./modules/aks"

  cluster_name        = "nakodtech-prod-cluster"
  resource_group_name = "nakodtech-prod-rg"
  location            = var.location
  dns_prefix          = "nakodtech-prod"

  kubernetes_version  = var.kubernetes_version
  node_vm_size        = var.prod_node_vm_size
  node_count          = var.prod_node_count

  service_principal_app_id     = var.service_principal_app_id
  service_principal_client_secret = var.service_principal_client_secret
}