# 🧠 Managing Multiple AKS Clusters from One EC2 (kubeconfig)

---

## 🧠 How This Works (Important Concept)

🔑 **kubeconfig is NOT one cluster**

- `kubeconfig` is just a **configuration file**
- It can contain **many clusters**, **many users**, and **many contexts**

👉 **One EC2 VM**
👉 **One `~/.kube/config` file**
👉 **Multiple AKS clusters inside it**

---

## 🏗️ Architecture (Very Common)

```
EC2 VM (kubectl installed)
│
├── ~/.kube/config
│   ├── nakodtech-dev-cluster
│   ├── nakodtech-prod-cluster
│
└── kubectl → manages BOTH clusters
```

✅ This is how **CI/CD agents**, **jump servers**, and **bastion hosts** work in real-world DevOps.

---

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

---

### ✅ Result

Azure **automatically merges** both clusters into:

```
~/.kube/config
```

✔ No overwrite
✔ No conflict
✔ Multiple contexts created

_(Unless clusters share the same name)_

---

## 🔁 Switching Between Clusters

### 📋 List all contexts

```bash
kubectl config get-contexts
```

### 🔄 Use DEV cluster

```bash
kubectl config use-context nakodtech-dev-cluster
```

### 🔄 Use PROD cluster

```bash
kubectl config use-context nakodtech-prod-cluster
```

---

## 🔐 Security Notes (Very Important)

Your **EC2 VM**:

✔ Stores **certs / tokens only**
✔ Communicates with AKS API servers via **HTTPS (443)**
❌ Does **NOT** host Kubernetes

👉 This setup is **safe**, **secure**, and **industry standard**.

---

## ⚠️ Common Mistakes to Avoid

❌ Thinking `kubeconfig = one cluster`
❌ Overwriting kubeconfig manually
❌ Using same cluster names in different resource groups
❌ Using admin credentials in CI/CD pipelines

---

## ⭐ Best Practice (What Professionals Do)

✔ One **bastion / jump EC2 VM**
✔ Install:

- `kubectl`
- `helm`
- `terraform`
- `az cli`

✔ Merge multiple kubeconfigs
✔ Switch contexts when needed

👉 This is exactly what you are implementing 👍

---

## 🔥 Bonus: Pro & Clean Setup (Optional)

Use **separate kubeconfig files**:

```bash
export KUBECONFIG=~/.kube/aks-dev:~/.kube/aks-prod
```

Then:

```bash
kubectl config get-contexts
```

✔ Cleaner setup
✔ Safer operations
✔ Easy rollback

---

## ✅ Final Summary

✅ One EC2 VM can manage **multiple AKS clusters**
✅ Single kubeconfig location is **normal**
✅ Device-code login is **expected on EC2**
✅ This approach is **DevOps best practice** 🚀
