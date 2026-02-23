# taskapp-tsa-terra

Infrastructure as Code (IaC) repository for the **TaskApp** project, built with **Terraform** using a **modules-first architecture**.

This repository is used in **TS Academy** to teach Terraform fundamentals, AWS infrastructure design, and production-ready patterns — **step by step**, without magic or copy-paste learning.

---

## 🎯 Purpose of This Repository

This repository exists to:

- Teach **Terraform fundamentals** clearly
- Demonstrate **real AWS infrastructure** (VPC, EC2, RDS)
- Enforce **clean architecture and separation of concerns**
- Introduce **modules early**, the way real teams work
- Prepare students for configuration management (Ansible) and CI/CD later

This is **not** a toy example.  
It mirrors how professional DevOps teams structure Terraform projects.

---

## 🧠 Key Design Principles

This repo is intentionally designed around the following ideas:

- **Root modules orchestrate**
- **Child modules implement**
- **Infrastructure is built in layers**
- **Security is enforced by design**
- **State is shared and locked for team safety**

We do **not**:
- hardcode credentials
- hardcode AMI IDs
- expose databases publicly
- mix unrelated concerns in one module
- rely on local Terraform state for teamwork

---

## 🗂️ Repository Structure

```
taskapp-tsa-terra/
├── terraform-backend/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── root/
│   ├── versions.tf
│   ├── providers.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
│
└── modules/
    ├── core/
    │   ├── variables.tf
    │   ├── main.tf
    │   └── outputs.tf
    ├── vpc/
    │   ├── variables.tf
    │   ├── main.tf
    │   └── outputs.tf
    ├── ec2/
    │   ├── variables.tf
    │   ├── main.tf
    │   └── outputs.tf
    └── rds/
        ├── variables.tf
        ├── main.tf
        └── outputs.tf
```

---

## 📦 Folder-by-Folder Explanation

### `terraform-backend/` — **State Backend Bootstrap**

This folder creates **infrastructure required by Terraform itself**:

- S3 bucket for remote state storage
- DynamoDB table for state locking

Why this exists:
- Terraform **cannot safely manage its own backend**
- Backend resources must be created **once**, separately
- This folder is applied **before** anything else

This folder is run **only once** per project.

---

### `root/` — **Terraform Entrypoint (Orchestrator)**

This is where Terraform commands are executed:

```bash
terraform init
terraform plan
terraform apply
```

Responsibilities of `root/`:

- Define Terraform and provider versions
- Configure AWS provider
- Configure remote state backend
- Define input variables
- Call modules
- Expose final outputs

**Important rule**: Root should be thin.  
It orchestrates modules — it does not build infrastructure directly.

### `modules/` — Reusable Infrastructure Library

Each folder inside `modules/` represents one infrastructure concern.

Modules:

- Accept inputs (`variables.tf`)
- Implement logic/resources (`main.tf`)
- Return outputs (`outputs.tf`)

Modules are isolated:

- They do not see root variables unless passed explicitly
- They do not configure providers
- They do not manage state

#### 🔧 Module Breakdown

**`modules/core/`** — Project Context Module  
Purpose:

- Establish shared project context
- Teach module wiring (inputs → locals → outputs)
- Act as a foundation for later refactors

This module intentionally creates **no AWS resources**.  
It exists to teach:

- Module isolation
- Locals
- Clean interfaces

**`modules/vpc/`** — Networking Layer  
Creates:

- VPC
- Internet Gateway
- Public subnets (multi-AZ)
- Private subnets (multi-AZ)
- Route tables
- Security groups (frontend, backend, database)

This module represents the entire networking boundary.  
Security is enforced here:

- Public access only where required
- Private subnets isolated
- SG-to-SG rules (zero trust)

**`modules/ec2/`** — Compute Layer  
Creates:

- Frontend EC2 instance (public subnet)
- Backend EC2 instance (private subnet)

Design principles:

- Roles are explicit (frontend vs backend)
- AMIs are looked up dynamically
- Networking is injected, not created here

This module consumes outputs from `vpc`.

**`modules/rds/`** — Database Layer  
Creates:

- RDS PostgreSQL instance
- DB Subnet Group spanning private subnets
- Enforces backend-only access via security groups

Key properties:

- Never publicly accessible
- Multi-AZ ready
- Password treated as sensitive input
- Free-tier–safe configuration for teaching

---

## 🔐 Terraform State Management

This project uses **remote Terraform state**:

- State stored in S3
- State locking via DynamoDB
- Encryption enabled
- Prevents concurrent modification

Why this matters:

- Supports teamwork
- Prevents race conditions
- Protects critical resources (EC2, RDS)

Local state is not used after backend migration.

---

## 🚀 How to Use This Repository

1️⃣ **Bootstrap the Terraform backend**

```bash
cd terraform-backend
terraform init
terraform apply
```

Do this **once**.

2️⃣ **Deploy infrastructure**

```bash
cd ../root
terraform init
terraform plan
terraform apply
```

You will be prompted for sensitive variables (e.g. DB password, ssh key).

---

## 🧪 What This Repo Does Not Do (Yet)

This repository intentionally does not cover:

- Environment separation (dev/staging/prod)
- Ansible configuration
- Application deployment
- CI/CD pipelines
- Auto Scaling or Load Balancers

Those come in later phases.

---

## 🎓 Teaching Philosophy

This repository is structured to:

- Remove mystery
- Enforce correctness
- Build intuition
- Prepare students for real production systems

Every design choice is intentional.  
If something feels “extra” or “verbose” — it’s because **clarity beats cleverness**.

---

## ✅ Outcome

By the end of this Terraform phase, students will be able to:

- Read and understand real Terraform repos
- Design secure AWS infrastructure
- Use modules correctly
- Reason about state and locking
- Avoid beginner Terraform mistakes

---

## 🏁 Project Name

**taskapp-tsa-terra**  
Terraform infrastructure for the TaskApp project at TS Academy.
