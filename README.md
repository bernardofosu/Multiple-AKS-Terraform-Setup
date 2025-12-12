# 🚀 AKS Terraform – Learning Mode (DEV + PROD Together)

> 🧪 **Learning / Lab setup**
> ❌ **Not for real production**

This canvas contains the **FULL WORKING CODE** for creating **DEV and PROD AKS clusters together with ONE `terraform apply`**.

## 🔐 3. Export Azure Service Principal Credentials

```
export ARM_CLIENT_ID="YOUR_APP_ID_HERE"
# ⚠️ SECURITY NOTE:
# ARM_CLIENT_SECRET is sensitive. DO NOT expose it in documentation.
# export ARM_CLIENT_SECRET="YOUR_CLIENT_SECRET_HERE"
export ARM_TENANT_ID="YOUR_TENANT_ID_HERE"
export ARM_SUBSCRIPTION_ID="YOUR_SUBSCRIPTION_ID_HERE"
```

---

## 🧩 4. Export Terraform Module Variables

```
export TF_VAR_service_principal_app_id="$ARM_CLIENT_ID"
export TF_VAR_service_principal_client_secret="$ARM_CLIENT_SECRET"
```

---

## 🔍 5. Verify Environment Variables

```
echo $ARM_CLIENT_ID
echo $ARM_CLIENT_SECRET
echo $ARM_TENANT_ID
echo $ARM_SUBSCRIPTION_ID
```

```
echo $TF_VAR_service_principal_app_id
echo $TF_VAR_service_principal_client_secret
```

---

## 🔑 6. Verify Azure Login

```
az login --service-principal \
  --username "$ARM_CLIENT_ID" \
  --password "$ARM_CLIENT_SECRET" \
  --tenant "$ARM_TENANT_ID"
```

## ➕ How to Add BOTH AKS Clusters (From EC2)

### 1️⃣ Login to Azure (Headless VM)

⚠️ On EC2 (no browser), normal `az login` will fail.

✅ **Correct command**

```bash
az login --use-device-code
```

You will see something like:

```
To sign in, use a web browser to open https://microsoft.com/devicelogin
and enter the code: ABCD-EFGH
```

👉 Open the link on your **laptop or phone**
👉 Enter the code
👉 Login to Azure

✔ EC2 gets authenticated
✔ Token stored locally
✔ Ready to manage AKS

---

### 2️⃣ Get kubeconfig for DEV cluster

```bash
az aks get-credentials \
  --resource-group rg-1 \
  --name nakodtech-dev-cluster
```

---

### 3️⃣ Get kubeconfig for PROD cluster

```bash
az aks get-credentials \
  --resource-group rg-2 \
  --name nakodtech-prod-cluster
```

## 🧱 Project Structure

```
aks-terraform-learning/
│
├── main.tf              # Calls DEV & PROD together
├── variables.tf        # Shared variables
├── outputs.tf          # Shared outputs
├── provider.tf         # Azure providers
├── versions.tf         # Terraform & provider versions
├── terraform.tfvars    # Actual values
│
└── modules/
    └── aks/             # Reusable AKS blueprint (module)
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## ⚙️ provider.tf

```hcl
provider "azurerm" {
  features {}
}

provider "azuread" {}
```

---

## 📌 versions.tf

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

## 🧾 variables.tf (ROOT – Shared)

```hcl
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
```

---

## 🧾 terraform.tfvars

```hcl
location           = "West Europe"
kubernetes_version = "1.32.9"

# DEV
dev_node_vm_size  = "Standard_D2s_v6"
dev_node_count   = 2

# PROD
prod_node_vm_size = "Standard_D2s_v6"
prod_node_count  = 2
```

---

## 🧠 main.tf (DEV + PROD Together)

```hcl
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
```

---

## 📤 outputs.tf (ROOT)

```hcl
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
```

---

## 🧩 modules/aks/variables.tf

```hcl
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
```

---

## 🧩 modules/aks/main.tf (AKS Blueprint)

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

## 📤 modules/aks/outputs.tf

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

## ▶️ How to Run

```bash
terraform init
terraform apply
```

---

## ⚠️ Downsides (DO NOT IGNORE)

❌ One Terraform state file
❌ `terraform destroy` deletes DEV + PROD
❌ No approval or access separation
❌ Not CI/CD safe

---

## 🧠 Golden Rule

> 🧩 **Module = Blueprint**
> 🚧 **Environment = State Boundary**

---

🎓 Perfect for **learning Terraform** before moving to real-world DevOps structure.
