# GitHub Copilot Instructions - Theme Park Ride Ops

## Project Overview
This is a microservices-based theme park ride operations system built with Spring Boot, transitioning from Vagrant-based development to production-ready Kubernetes deployment. The project combines two codebases: legacy Gradle-based (`src/`) and new Maven-based (`theme-park-ride-ops-5/`).

## Architecture & Structure

### Dual Codebase Pattern
- **Legacy**: Root-level Spring Boot app using Gradle (`build.gradle`, `src/main/java/com/exemple/`)
- **New**: Production-ready version in `theme-park-ride-ops-5/` using Maven with complete K8s stack
- When working on new features, use the `theme-park-ride-ops-5/` structure

### Key Components
- **Spring Boot Apps**: Java 17, Spring Boot 2.5.x, MariaDB with JPA/Hibernate
- **Infrastructure**: Kubernetes (k3s), Terraform, Ansible, Helm, ArgoCD
- **Monitoring**: Prometheus + Grafana integration via `/actuator/prometheus`
- **CI/CD**: GitHub Actions → Docker build → Helm update → ArgoCD sync

## Configuration Management

### Environment Variables (.env Pattern)
All configuration centralized in `.env` files referenced by every tool:
```bash
# Database settings
DB_HOST=mariadb
DB_NAME=themepark
DB_USER=themeuser
DB_PASS=themedb123

# Container registry
REGISTRY_URL=docker.io/myrepo

# Kubernetes namespaces
THEMEPARK_NAMESPACE=themepark-app
ARGOCD_NAMESPACE=argocd
```

### Configuration Flow
- Docker: `--env-file .env`
- Terraform: Variables via `TF_VAR_` prefix
- Helm: Values templated from ConfigMaps/Secrets
- Ansible: `vars_files: ["../.env"]`

## Development Workflows

### Local Development
```bash
# Use Docker Compose with .env
cd theme-park-ride-ops-5/
docker-compose up --build
```

### Build & Test
```bash
# Legacy (Gradle)
./gradlew build test

# New (Maven)
cd theme-park-ride-ops-5/app/ride-ops/
mvn clean install
```

### Infrastructure Deployment
```bash
# 1. Provision with Terraform
cd terraform/
terraform init && terraform apply

# 2. Configure with Ansible
cd ../ansible/
ansible-playbook -i inventory.ini playbook.yml

# 3. Deploy apps with Helm
helm upgrade --install themepark-app ./helm/umbrella-chart
```

## Code Patterns & Conventions

### Spring Boot Structure
- REST Controllers: Simple CRUD operations (`@RestController`, `@RequestMapping`)
- Repository Pattern: JPA repositories extending `JpaRepository`
- Entity Pattern: JPA entities with validation annotations
- No complex business logic layers - keep it simple

### Container Orchestration
- **3 replicas** default for Spring Boot apps (high availability)
- **StatefulSet** for MariaDB with persistent volumes
- **Traefik** as ingress controller (not traditional nginx)
- Namespace isolation: `themepark-app` for applications

### GitOps Workflow
1. Code changes → GitHub Actions build
2. Docker images pushed with git SHA tags
3. Helm values.yaml updated with new image tags
4. ArgoCD detects changes and syncs to cluster
5. Rollback via ArgoCD UI if needed

## Critical Integration Points

### Database Connection
- MariaDB accessed via service name `mariadb:3306`
- Connection string constructed from env vars: `jdbc:mariadb://${DB_HOST}:${DB_PORT}/${DB_NAME}`
- Credentials injected via Kubernetes Secrets in production

### Monitoring Integration
- Spring Boot Actuator exposes `/actuator/prometheus` endpoint
- Prometheus scrapes metrics automatically via service discovery
- Grafana dashboards pre-configured for JVM and custom metrics

### Load Balancing
- **External**: Traefik ingress routes traffic to services
- **Internal**: Kubernetes service load balances across 3 pod replicas
- Health checks via Spring Boot Actuator `/health` endpoint

## Troubleshooting Commands

```bash
# Check pod status
kubectl get pods -n themepark-app

# View application logs
kubectl logs -f deployment/ride-ops -n themepark-app

# Access database directly
kubectl exec -it deployment/mariadb -n themepark-app -- mysql -u themeuser -p themepark

# Force ArgoCD sync
argocd app sync themepark-app

# Rollback deployment
kubectl rollout undo deployment/ride-ops -n themepark-app
```

## Security & Best Practices

### Secrets Management
- Never hardcode credentials - use `.env` locally, K8s Secrets in production
- Database passwords, registry credentials stored in GitHub Secrets
- ArgoCD auth tokens for automated deployments

### Resource Management
- Resource limits defined in Helm values for production
- Log cleanup scripts in `scripts/` directory
- Database backup automation via `scripts/backup_db.sh`

## File Organization Priority
When making changes:
1. **Primary**: Work in `theme-park-ride-ops-5/` for new features
2. **Legacy**: Maintain `src/` only for bug fixes in existing deployments
3. **Infrastructure**: Terraform/Ansible changes affect entire stack
4. **Documentation**: Update both architecture.md and runbook.md for operational changes