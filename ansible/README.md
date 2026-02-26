# Ansible – TaskApp Infrastructure Provisioning

This directory contains the Ansible configuration used to configure the **TaskApp** servers after Terraform provisions the infrastructure.

It configures:
- **common**: base OS packages, application user/group, and `/opt/taskapp`
- **frontend**: installs Node.js + nginx, builds the frontend, deploys to nginx
- **backend**: installs Python + venv, deploys the backend app, writes `.env`, installs a systemd service

---

## Directory Structure

```
ansible/
├── ansible.cfg
├── inventory/
│   ├── dev.yml
│   ├── staging.yml
│   └── prod.yml
├── group_vars/
│   ├── all/
│   │   ├── all.yml
│   │   └── terraform.yml
│   ├── frontend.yml
│   └── backend/
│       ├── backend.yml
│       └── vault.yml (Ansible Vault encrypted)
└── playbooks/
    └── site.yml
    └── roles/
        ├── common/
        ├── frontend/
        └── backend/
```

---

## Prerequisites

### 1) Tools
- Ansible installed locally (recommended: `ansible-core >= 2.14`)
- SSH key available locally (example used in inventory: `~/.ssh/task-app.pem`)
- Terraform already applied (so `terraform/root/terraform_outputs.json` exists)

### 2) SSH Access
Make sure you can SSH to hosts in your inventory:

```bash
ssh -i ~/.ssh/task-app.pem ubuntu@<frontend_public_ip>
ssh -i ~/.ssh/task-app.pem ubuntu@<backend_public_ip>
```

## How Inventory Works
Inventories live in `ansible/inventory/`:

- `dev.yml` – currently populated with dev IPs
- `staging.yml` – placeholder
- `prod.yml` – placeholder

Example run targets:

- `frontend` group → frontend server(s)
- `backend` group → backend server(s)
- `all` → both (common role runs here)

## Variables & Terraform Outputs

**Global Vars (all hosts)**  
`inventory/group_vars/all/all.yml`

- common packages
- app user/group (`taskapp`)
- base install directory (`/opt/taskapp`)

**Terraform output import**  
`inventory/group_vars/all/terraform.yml` loads:

- `../../../../terraform/root/terraform_outputs.json`

This file is used to dynamically inject Terraform values into Ansible variables (e.g. backend public IP, RDS endpoint).

**Important**: Run Terraform first, then ensure `terraform_outputs.json` exists at:  
`terraform/root/terraform_outputs.json`

## Secrets (Ansible Vault)

Backend secrets are stored in:  
`inventory/group_vars/backend/vault.yml`

This file is encrypted and should contain values like:

- `vault_db_password`

**Editing vault values**

```bash
ansible-vault edit inventory/group_vars/backend/vault.yml
```

**Running with vault password prompt**

```bash
ansible-playbook -i inventory/dev.yml playbooks/site.yml --ask-vault-pass
```

Or use a vault password file:

```bash
ansible-playbook -i inventory/dev.yml playbooks/site.yml \
  --vault-password-file ~/.ansible_vault_pass.txt
```

## What the Playbook Does

Main entrypoint:  
`playbooks/site.yml`

Runs in this order:

1. `common` role on all
2. `frontend` role on frontend
3. `backend` role on backend

## Usage

**Full deployment (dev)**  
From the repository root:

```bash
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/site.yml --ask-vault-pass
```

**Run only frontend role**

```bash
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/site.yml \
  --limit frontend --ask-vault-pass
```

**Run only backend role**

```bash
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/site.yml \
  --limit backend --ask-vault-pass
```

**Check mode (dry run)**

```bash
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/site.yml \
  --check --diff --ask-vault-pass
```

## Post-Deploy Verification

**Frontend**  
On the frontend server:

```bash
sudo systemctl status nginx --no-pager
curl -I http://localhost
```

**Backend**  
On the backend server:

```bash
sudo systemctl status taskapp-backend --no-pager
sudo journalctl -u taskapp-backend -n 100 --no-pager
curl -s http://localhost:5000 || true
```

**Database Connectivity (from backend)**  
Install client if needed:

```bash
sudo apt-get update && sudo apt-get install -y postgresql-client
```

Then test:

```bash
psql -h <RDS_ENDPOINT> -U taskapp_user -d taskapp -p 5432
```

## Notes / Gotchas

- **Terraform first**: Ansible expects `terraform/root/terraform_outputs.json` to exist.
- **Vault required**: backend DB password is pulled from Vault (`vault_db_password`).
- **System user**: `taskapp` user is created as a system user with `nologin` and no home directory.
- **Nginx site**: frontend role installs an nginx config to `sites-available/taskapp` and enables it.
- **Idempotency**: tasks are written to be rerunnable safely (git updates, systemd reload, etc.).

## Common Commands

**List hosts:**

```bash
cd ansible
ansible-inventory -i inventory/dev.yml --list
```

**Ping all hosts:**

```bash
cd ansible
ansible -i inventory/dev.yml all -m ping
```

**Run with more logs:**

```bash
cd ansible
ansible-playbook -i inventory/dev.yml playbooks/site.yml -vv --ask-vault-pass
```

## Contributing

- Keep secrets in Vault (`inventory/group_vars/backend/vault.yml`)
- Keep non-secret environment defaults in group_vars
- Prefer roles for repeatable logic; avoid adding ad-hoc tasks to the playbook


You can copy-paste this directly into your `ansible/README.md` file.  
Good luck with your TaskApp deployment!
