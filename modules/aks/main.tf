resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version
  sku_tier           = "Standard"

  service_principal {
    client_id     = var.service_principal_app_id
    client_secret = var.service_principal_client_secret
  }

  default_node_pool {
    name       = "system"
    vm_size    = var.node_vm_size
    node_count = var.node_count
    zones      = [1, 2, 3]
  }

  role_based_access_control_enabled = true
}