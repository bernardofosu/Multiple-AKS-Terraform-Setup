# 🚀 Terraform AKS with Modules (Dev & Prod)

This setup converts your **single AKS Terraform code** into a **professional, reusable module** and creates **DEV** and **PROD** clusters using best practice project structure.

---

## 🧱 Project Structure (Industry Standard)

```sh
aks-terraform/
│
├── modules/
│   └── aks/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│
├── provider.tf
├── versions.tf
└── README.md
```

---

## 🧩 AKS MODULE (Reusable)

### 📄 `modules/aks/main.tf`

```hcl
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
```

---

### 📄 `modules/aks/variables.tf`

```hcl
variable "cluster_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "dns_prefix" {}
variable "kubernetes_version" {}
variable "node_vm_size" {}
variable "node_count" {}
variable "service_principal_app_id" {}
variable "service_principal_client_secret" {
  sensitive = true
}
```

---

### 📄 `modules/aks/outputs.tf`

```hcl
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
```

---

## 🌱 DEV ENVIRONMENT

### 📄 `environments/dev/main.tf`

```hcl
module "aks_dev" {
  source = "../../modules/aks"

  cluster_name                = "nakodtech-dev-cluster"
  resource_group_name         = "nakodtech-dev-rg"
  location                    = var.location
  dns_prefix                  = "nakodtech-dev"
  kubernetes_version          = var.kubernetes_version
  node_vm_size                = var.node_vm_size
  node_count                  = var.node_count
  service_principal_app_id    = var.service_principal_app_id
  service_principal_client_secret = var.service_principal_client_secret
}
```

---

### 📄 `environments/dev/terraform.tfvars`

```hcl
location            = "West Europe"
kubernetes_version  = "1.32.9"
node_vm_size        = "Standard_D2s_v6"
node_count          = 2
```

### 📄 `environments/dev/variables.tf`

```hcl
variable "location" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_vm_size" {
  type = string
}

variable "node_count" {
  type = number
}

variable "service_principal_app_id" {}
variable "service_principal_client_secret" {
  sensitive = true
}
```

---

## 🔥 PROD ENVIRONMENT

### 📄 `environments/prod/main.tf`

```hcl
module "aks_prod" {
  source = "../../modules/aks"

  cluster_name                = "nakodtech-prod-cluster"
  resource_group_name         = "nakodtech-prod-rg"
  location                    = var.location
  dns_prefix                  = "nakodtech-prod"
  kubernetes_version          = var.kubernetes_version
  node_vm_size                = var.node_vm_size
  node_count                  = var.node_count
  service_principal_app_id    = var.service_principal_app_id
  service_principal_client_secret = var.service_principal_client_secret
}
```

---

### 📄 `environments/prod/terraform.tfvars`

```hcl
location            = "West Europe"
kubernetes_version  = "1.32.9"
node_vm_size        = "Standard_D4s_v6"
node_count          = 3
```

---

## ⚙️ Providers (Root Level)

### 📄 `provider.tf`

```hcl
provider "azurerm" {
  features {}
}

provider "azuread" {}
```

---

## 📌 Versions

### 📄 `versions.tf`

```hcl
terraform {
  required_version = ">= 1.4.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.4.0"
    }
  }
}
```

---

## ▶️ How to Deploy

### DEV

```bash
cd environments/dev
terraform init
terraform apply
```

### PROD

```bash
cd environments/prod
terraform init
terraform apply
```

---

## ⭐ Why This Is Best Practice

✅ One reusable module
✅ Separate DEV / PROD state
✅ Easy CI/CD integration
✅ Clean rollback
✅ Enterprise-ready

---

## 🧠 DevOps Tip

👉 Use **remote state** (Azure Storage backend) for teams
👉 Use **Service Principal** in pipelines
👉 Add **node pools** later without touching environments

---

🚀 This structure is **production-grade AKS Terraform**.
