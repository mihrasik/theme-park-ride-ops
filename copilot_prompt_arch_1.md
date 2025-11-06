# 🚀 GitHub Copilot Prompt — Theme Park Ride Ops (Full DevOps Architecture)

You are enhancing and modernizing the **Theme Park Ride Ops** project:  
👉 https://github.com/mihrasik/theme-park-ride-ops  

This is a **Spring Boot microservices** system (3 apps + MariaDB + Load Balancer) that currently runs in a **Vagrant-based setup**.  
Your task is to guide the generation of a **production-ready, containerized, Kubernetes-based, CI/CD-enabled infrastructure** following modern **DevOps methodology** and the **DataScientest 6-step process**.


## 🌍 Important guidelines
- all necessary variables including url, user, password should be keeped in .env file
- provide all necessary scripts to insall tools like a terraform for the host as well.

---

## 🌍 Project Context

- **Stack:** Java 17 (Spring Boot), MariaDB, NGINX/Traefik  
- **Tools:** Docker, Kubernetes, Helm, ArgoCD, Terraform, Ansible, GitHub Actions  
- **Phase 01:** Local deployment k8s cluster  
- **Phase 02:** Migration to AWS (EKS, RDS, CloudWatch) using same Terraform modules  
- **Repo Goal:** Replace Vagrant setup with IaC-driven, modular DevOps stack  
- **Docs:** Keep all architecture diagrams and visual assets in `/docs/architecture.md`

---

## 🧩 Deliverables & Structure

Generate or update the following folders/files:


---

## 🎯 Step-by-Step Objectives

### Step 1 – **Specification**
- Create architecture overview (documented in `/docs/architecture.md`).  
- Include API endpoints and CI/CD flow.  
- Provide basic Scrum/Trello and branching guidelines.


### Step 2 – **Infrastructure**
- Migrate from Vagrant → Terraform + Ansible.  
- Terraform provisions VMs (control plane + workers).  
- Ansible installs Docker, Kubernetes (k3s/kubeadm), Helm, ArgoCD.  
- Add Dockerfiles for services, MariaDB, and load balancer.  
- Create Helm charts for Kubernetes deployment and PVC-based DB.

### Step 3 – **Data Management**
- Use StatefulSet for MariaDB with PVC.  
- Add automated DB backup via CronJob.  
- Define RBAC and namespace-based isolation.

### Step 4 – **CI/CD**
- GitHub Actions:
  - Build/test Spring Boot apps.  
  - Build/push Docker images to Docker Hub.  
  - Update Helm chart values.  
  - Sync ArgoCD for auto-deploy.  
- Ensure blue/green or rolling updates.

### Step 5 – **Monitoring**
- Integrate Prometheus & Grafana with Helm.  
- Scrape metrics from `/actuator/prometheus`.  
- Add Grafana dashboards and Alertmanager config.

### Step 6 – **Automation (IaC)**
- Modular Terraform:
  - `terraform/local_prov`: Local cluster provisioning  
  - `terraform/aws`: EKS + RDS modules  
- Parameterize variables and secrets.  
- Document full IaC-to-CD flow (`terraform → ansible → helm → argocd`).

---

## 🧠 Rules for Copilot

- No hardcoded IPs or credentials — use Secrets or environment variables.  
- Keep Helm values, Terraform vars, and workflow inputs reusable.  
- Follow naming conventions for Kubernetes resources.  
- Use minimal, modular, well-commented configuration files.  
- CI/CD must be **idempotent** and **rollback-safe**.  
- Include clear execution order in docs.

---

## ✅ Output Format

For each file:
## Next Steps (Phase 01)
1. terraform init && terraform apply
2. ansible-playbook -i inventory playbook.yml
3. ./gradlew bootJar && docker build/push
4. helm upgrade --install ...
5. kubectl apply -f argocd/application.yaml
6. kubectl get pods -n themepark && open Grafana dashboard

