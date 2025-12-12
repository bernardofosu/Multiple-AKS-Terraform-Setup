output "dev_aks_name" {
  value = module.aks_dev.aks_name
}

output "prod_aks_name" {
  value = module.aks_prod.aks_name
}

output "dev_kubeconfig" {
  value     = module.aks_dev.kube_config
  sensitive = true
}

output "prod_kubeconfig" {
  value     = module.aks_prod.kube_config
  sensitive = true
}