# 🧭 GitHub Copilot Master Prompt — Theme Park Ride Ops (v5 – Ubuntu + .env Configuration)

You are enhancing the **Theme Park Ride Ops** project:  
👉 https://github.com/mihrasik/theme-park-ride-ops  

This project is a **Spring Boot microservices** system (three apps + MariaDB + Traefik load balancer) originally running under Vagrant.  
The goal is to rebuild it into a **production-ready, Kubernetes-based stack** on **Ubuntu**, using **Docker, Helm, ArgoCD, Terraform, Ansible**, and **GitHub Actions** — with all configuration managed through a central **.env file**.

---

## 🎯 Objectives

- Run natively on **Ubuntu Linux** (no Multipass).  
- Provision and configure Kubernetes infrastructure using **Terraform + Ansible**.  
- Package services with **Docker**, deploy via **Helm**.  
- Manage deployments declaratively through **ArgoCD (GitOps)**.  
- Automate build → push → deploy using **GitHub Actions**.  
- Integrate **Prometheus + Grafana** monitoring.  
- Store all configuration (URLs, credentials, ports, DB settings, image tags) in a unified **.env** file loaded by each tool.

---

## 🧩 Architecture Components

### 1. Infrastructure (Ubuntu Host + Terraform + Ansible)
- **Terraform**
  - Creates and manages local Kubernetes resources (k3s or kubeadm cluster).  
  - Defines networking, volumes, and security groups (if any).  
  - Reads environment variables from `.env` (using Terraform env interpolation).
- **Ansible**
  - Installs Docker, kubectl, Helm, and ArgoCD.  
  - Configures k3s / kubeadm cluster on Ubuntu host.  
  - Loads variables (e.g., user, registry URL, namespace) from `.env`.

### 2. Kubernetes Layer (k3s / kubeadm)
- Deploys Spring Boot services (3 replicas default).  
- Deploys MariaDB (StatefulSet + PVC).  
- Uses Traefik ingress for exposure.  
- Namespace: `themepark-app`.

### 3. Application Packaging (Docker + Helm)
- **Docker**
  - Dockerfiles for Spring Boot apps, MariaDB, and Traefik.  
  - Loads all build args from `.env`.  
- **Helm**
  - Umbrella chart + subcharts for app and DB.  
  - Values (e.g., DB_URL, DB_USER, DB_PASS) templated from `.env` via `envFrom` or Helm values.  
  - Secrets refer to these values at runtime.

### 4. GitOps and CI/CD (ArgoCD + GitHub Actions)
- **GitHub Actions**
  - Build and test Gradle modules.  
  - Build Docker images → push to Docker Hub (using credentials from `.env`).  
  - Update Helm `values.yaml` with new image tags.  
  - Commit changes and trigger ArgoCD sync.  
- **ArgoCD**
  - Watches Git repository for changes.  
  - Syncs Helm charts automatically to Ubuntu cluster.  
  - Provides UI and rollback capability.

### 5. Monitoring (Prometheus + Grafana)
- Deploy Prometheus and Grafana using Helm charts.  
- Prometheus scrapes Spring Boot `/actuator/prometheus`.  
- Grafana dashboards visualize application and DB metrics.  
- Optional Alertmanager integration.

---

## 📁 Deliverables to Generate

/app/<service>/Dockerfile
/.env
/docker-compose.yml
/helm/ (umbrella + subcharts for apps & db)
/k8s/*.yaml
/terraform/{main.tf, providers.tf, variables.tf, outputs.tf}
/ansible/{inventory.ini, playbook.yml, roles/{common, k8s}/tasks/main.yml}
/argocd/application.yaml
/.github/workflows/ci.yaml
/monitoring/{prometheus-values.yaml, grafana-values.yaml}
/scripts/{backup_db.sh, log_cleanup.sh}
/docs/{architecture.md, runbook.md}
/README.md



---

## ⚙️ .env File Usage Rules

- Keep all runtime and build variables here:  
APP_ENV=local
DB_HOST=mariadb
DB_PORT=3306
DB_NAME=themepark
DB_USER=themeuser
DB_PASS=themedb123
REGISTRY_URL=docker.io/myrepo
ARGOCD_NAMESPACE=argocd
THEMEPARK_NAMESPACE=themepark-app
PROMETHEUS_PORT=9090
GRAFANA_PORT=3000


- Each module loads from `.env`:  
- Docker: `--env-file .env`  
- Terraform: `TF_VAR_` mapping  
- Ansible: `vars_files: ["../.env"]` or `lookup('env', VAR)`  
- Helm: values templated from environment  
- CI/CD: GitHub Secrets referencing `.env` entries  

---

## 🧠 Guidelines
- No hardcoded IPs or credentials anywhere in code.  
- All configs centralized in `.env` and referenced by each tool.  
- Use Kubernetes Secrets for sensitive values when deploying.  
- Namespace for apps: `themepark-app`.  
- Follow 12-Factor App principles and idempotent IaC.  
- Document end-to-end flow in `/docs/runbook.md`.

---

## 📤 Expected Output Format
For each file generated:


<file path> <full file content> ```




</prompt>