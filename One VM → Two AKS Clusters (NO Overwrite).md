# 🔁 One VM → Two AKS Clusters (NO Overwrite)

This canvas documents the **correct, safe, and verified way** to manage **multiple AKS clusters from ONE VM** using **kubeconfig merging**.

---

## ✅ Correct Way (NO `--overwrite-existing`)

🔴 **What `--overwrite-existing` does**

- Replaces existing entries in `~/.kube/config`
- Can delete other cluster contexts

👉 **That’s why we DO NOT use it for multi-cluster setups**

---

## ✅ Safe & Standard Method (Recommended)

### 1️⃣ Get DEV credentials

```bash
az aks get-credentials \
  --resource-group nakodtech-dev-rg \
  --name nakodtech-dev-cluster
```

### 2️⃣ Get PROD credentials

```bash
az aks get-credentials \
  --resource-group nakodtech-prod-rg \
  --name nakodtech-prod-cluster
```

✔ Azure **MERGES** kubeconfigs automatically
✔ Nothing is overwritten
✔ Both clusters live in `~/.kube/config`

---

## 🔍 Verify Both Clusters Exist

```bash
kubectl config get-contexts
```

### Output (Verified)

```
azuredevops-k8
nakodtech-dev-cluster
nakodtech-prod-cluster
```

✅ Multiple clusters confirmed

---

## 🔴 PROD Cluster (Current Context)

```bash
kubectl get nodes
```

Output:

```
aks-system-16340403-vmss000000
aks-system-16340403-vmss000001
```

👉 These nodes belong to **PROD**

---

## 🔁 Switch to DEV Cluster

```bash
kubectl config use-context nakodtech-dev-cluster
```

✔ Context switched successfully

---

## 🟢 DEV Cluster Nodes

```bash
kubectl get nodes
```

Output:

```
aks-system-13240170-vmss000000
aks-system-13240170-vmss000001
```

✅ Different VMSS
✅ Different node IDs
✅ Confirms separate AKS clusters

---

## 🧠 Key Observations

🔹 One VM
🔹 One `~/.kube/config`
🔹 Multiple contexts
🔹 Context switching controls the target cluster

---

## 🧠 When DO You Use `--overwrite-existing`?

Use it **ONLY when**:

✔ Cluster was recreated
✔ Certificates changed
✔ kubeconfig context is broken

❌ **Not for multi-cluster management**

---

## ⭐ Pro / Zero-Risk Option (Optional)

Keep kubeconfigs separate:

```bash
az aks get-credentials \
  --resource-group nakodtech-dev-rg \
  --name nakodtech-dev-cluster \
  --file ~/.kube/dev-config
```

```bash
az aks get-credentials \
  --resource-group nakodtech-prod-rg \
  --name nakodtech-prod-cluster \
  --file ~/.kube/prod-config
```

Merge logically:

```bash
export KUBECONFIG=~/.kube/dev-config:~/.kube/prod-config
kubectl config get-contexts
```

---

## 🏁 Final Verdict

❌ Don’t use `--overwrite-existing`
✅ Azure merges kubeconfigs automatically
✅ One VM can manage multiple AKS clusters
✅ This is **exactly how CI/CD agents work**

---

🎯 **Status: VERIFIED & WORKING**

You’ve now proven multi-cluster management hands-on 🚀
