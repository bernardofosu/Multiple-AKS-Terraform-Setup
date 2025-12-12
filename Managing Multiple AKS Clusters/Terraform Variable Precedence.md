# 🧠 Terraform Variable Precedence (Defaults vs tfvars)

These notes explain **which value Terraform uses first** when a variable has a `default` and also appears in `terraform.tfvars`.

---

## 🧩 The Question

```hcl
variable "location" {
  type    = string
  default = "East US"
}
```

```hcl
# terraform.tfvars
location = "West Europe"
```

❓ **Which value will Terraform use?**

---

## ✅ The Answer (Very Important)

👉 **Terraform will use:**

```
West Europe
```

✔ `terraform.tfvars` **OVERRIDES** `default`

---

## 🧠 Why This Happens

Terraform applies values using **priority (precedence)**.

- `default` is only a **fallback** 🛟
- If a higher-priority value exists, it replaces the default

---

## 🥇 Terraform Variable Precedence (Highest → Lowest)

1️⃣ CLI `-var` flag

```bash
terraform apply -var="location=North Europe"
```

2️⃣ Explicit variable file

```bash
terraform apply -var-file="prod.tfvars"
```

3️⃣ Auto-loaded variable files

- `terraform.tfvars`
- `*.auto.tfvars`

4️⃣ Environment variables

```bash
TF_VAR_location=CentralUS
```

5️⃣ `default` value in `variables.tf`

```hcl
default = "East US"
```

👉 **Terraform uses the highest one it finds**

---

## ❌ When Is `default` Used?

`default` is used **ONLY IF**:

- No value in `terraform.tfvars`
- No `-var` flag
- No `-var-file`
- No `TF_VAR_` environment variable

Then (and only then):

```
East US
```

---

## 🧠 Simple Mental Model (Remember This)

> 🧾 `default` = backup value
> ✍️ `tfvars` = real configuration
> 🚨 CLI `-var` = emergency override

---

## ⭐ Best Practices (Real DevOps)

✅ Use `default` for:

- safe values
- learning labs
- optional inputs

❌ Do NOT use `default` for:

- production regions
- credentials
- sizing (node count, VM size)

---

## ✅ One-Line Summary

> **`terraform.tfvars` overrides `default` — default is used only if nothing else is provided.**

---

🎓 These rules apply to **all Terraform projects**, modules, and environments.
