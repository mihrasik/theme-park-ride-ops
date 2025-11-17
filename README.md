# Theme Park Ride Operations

A DataOps project featuring a Spring Boot microservices application for managing theme park ride operations, deployed on Kubernetes with automated DevOps tooling.

## 📋 Project Overview

This project demonstrates a complete DevOps pipeline for a Java Spring Boot application with:
- **Application**: RESTful API for theme park ride management
- **Database**: MariaDB with Hibernate ORM
- **Infrastructure**: Kubernetes (k3d) with high availability (3 replicas)
- **Automation**: Ansible for tool provisioning, shell scripts for deployment
- **Monitoring**: Spring Boot Actuator health endpoints

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│           Kubernetes Cluster (k3d)              │
│                                                 │
│  ┌──────────────┐  ┌──────────────┐           │
│  │  Ride Ops    │  │  Ride Ops    │           │
│  │  Pod 1       │  │  Pod 2       │  ...      │
│  │  (replica 1) │  │  (replica 2) │           │
│  └──────────────┘  └──────────────┘           │
│         │                  │                    │
│         └──────────┬───────┘                   │
│                    │                            │
│         ┌──────────▼─────────┐                 │
│         │   MariaDB Service  │                 │
│         │   (Persistent)     │                 │
│         └────────────────────┘                 │
└─────────────────────────────────────────────────┘
```

## 🚀 Features

- **RESTful API**: CRUD operations for theme park rides
- **High Availability**: 3 application replicas with load balancing
- **Health Monitoring**: Liveness and readiness probes
- **Persistent Storage**: MariaDB with PVC for data persistence
- **Configuration Management**: Kubernetes ConfigMaps and Secrets
- **Container Registry**: k3d local image registry
- **Resource Management**: CPU and memory limits/requests

## 📦 Technology Stack

- **Backend**: Java 8, Spring Boot 2.5.8, Hibernate
- **Database**: MariaDB
- **Build Tool**: Gradle 7.3.2
- **Container**: Docker
- **Orchestration**: Kubernetes (k3d)
- **IaC**: Ansible, Terraform
- **Automation**: Bash scripts

## 🛠️ Prerequisites

Before running this project, ensure you have:
- macOS, Linux, or WSL2 (Windows)
- `sudo` access for installing tools
- Internet connection for downloading dependencies

The deployment scripts will automatically install:
- Ansible
- Docker
- Java (OpenJDK 11)
- Terraform
- k3d (Kubernetes in Docker)
- kubectl

## 📥 Installation & Deployment

Follow these steps in order to set up and deploy the application:

### Step 1: Install Ansible

First, install Ansible if not already present:

```bash
cd new
./install_ansible.sh
```

This will:
- Update package repositories
- Install Ansible and required dependencies
- Verify the installation

### Step 2: Install DevOps Tools

Run the Ansible playbook to install all required DevOps tools:

```bash
cd new
./ansible_playbook_devops_tools.sh
```

This playbook installs:
- Docker (container runtime)
- Java OpenJDK 11 (for building the application)
- Terraform (infrastructure as code)
- k3d (lightweight Kubernetes)
- kubectl (Kubernetes CLI)

**Note**: You may need to log out and log back in for Docker group permissions to take effect.

### Step 3: Deploy to Kubernetes

Deploy the complete application stack to Kubernetes:

```bash
cd new
./deploy-to-k8s.sh
```

This script performs the following:
1. ✅ Checks prerequisites (kubectl, k3d, Docker)
2. 🏗️ Creates k3d cluster (if not exists)
3. 🔨 Builds Spring Boot application with Gradle
4. 🐳 Builds Docker image
5. 📦 Imports image to k3d cluster nodes
6. 🔧 Creates Kubernetes namespace
7. 🔐 Sets up secrets and ConfigMaps
8. 💾 Deploys MariaDB with persistent storage
9. 🚀 Deploys Ride Ops application (3 replicas)
10. ✔️ Runs health checks and API tests

**Expected Output**:
```
🎢 Theme Park Ride Ops - Kubernetes Deployment Script
======================================================
✅ Prerequisites check passed
✅ Application built successfully
✅ Docker image built successfully
✅ Image imported to k3d cluster
✅ Namespace created/updated
✅ Secrets and ConfigMaps created
✅ MariaDB deployed and ready
✅ Ride Ops application deployed and ready
🎉 Deployment completed successfully!
```

### Step 4: Forward Port for External Access

To access the application from outside the cluster:

```bash
cd new
./forward_k8s_port.sh
```

This script:
- Terminates any existing port forwarding on port 8090
- Sets up port forwarding from localhost:8090 to the service
- Allows access from all network interfaces (0.0.0.0)

**Keep this terminal open** while you need access to the application.

## 🔌 API Endpoints

Once deployed, the API is accessible at `http://localhost:8090`:

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/ride` | List all theme park rides |
| `GET` | `/ride/{id}` | Get specific ride by ID |
| `POST` | `/ride` | Create a new ride |
| `PUT` | `/ride/{id}` | Update an existing ride |
| `DELETE` | `/ride/{id}` | Delete a ride |
| `GET` | `/actuator/health` | Health check endpoint |

### Example API Calls

**Get all rides:**
```bash
curl http://localhost:8090/ride
```

**Get specific ride:**
```bash
curl http://localhost:8090/ride/1
```

**Create new ride:**
```bash
curl -X POST http://localhost:8090/ride \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Space Mountain",
    "description": "Indoor roller coaster in the dark",
    "thrillLevel": 8,
    "minHeight": 120
  }'
```

**Check health:**
```bash
curl http://localhost:8090/actuator/health
```

## 🎯 Quick Start Commands

```bash
# Complete setup and deployment
cd new
./install_ansible.sh
./ansible_playbook_devops_tools.sh
./deploy-to-k8s.sh
./forward_k8s_port.sh

# In another terminal, test the API
curl http://localhost:8090/actuator/health
curl http://localhost:8090/ride
```

## 📊 Kubernetes Management

### View Running Pods
```bash
kubectl get pods -n themepark-app
```

### View Services
```bash
kubectl get services -n themepark-app
```

### View Logs
```bash
# All pods
kubectl logs -f deployment/ride-ops -n themepark-app

# Specific pod
kubectl logs -f <pod-name> -n themepark-app
```

### Scale Application
```bash
# Scale to 5 replicas
kubectl scale deployment ride-ops --replicas=5 -n themepark-app

# Scale back to 3
kubectl scale deployment ride-ops --replicas=3 -n themepark-app
```

### Restart Deployment
```bash
kubectl rollout restart deployment/ride-ops -n themepark-app
```

### Check Pod Status
```bash
kubectl describe pod <pod-name> -n themepark-app
```

## 🗄️ Database Access

To connect to MariaDB directly:

```bash
# Get MariaDB pod name
kubectl get pods -n themepark-app -l app=mariadb

# Connect to database
kubectl exec -it <mariadb-pod-name> -n themepark-app -- mysql -u themeuser -pthemedb123 themepark
```

## 🧹 Cleanup

### Stop Port Forwarding
```bash
pkill -f "kubectl port-forward"
```

### Delete Application
```bash
kubectl delete namespace themepark-app
```

### Delete k3d Cluster
```bash
k3d cluster delete themepark
```

### Complete Cleanup
```bash
# Delete cluster
k3d cluster delete themepark

# Remove Docker images
docker rmi ride-ops:latest

# Remove build artifacts
cd new/app/ride-ops
./gradlew clean
```

## 📂 Project Structure

```
theme-park-ride-ops-4/
├── new/
│   ├── install_ansible.sh              # Install Ansible
│   ├── ansible_playbook_devops_tools.sh # Run Ansible playbook
│   ├── ansible_playbook_devops_tools.yml # Ansible playbook for tools
│   ├── deploy-to-k8s.sh                # Main deployment script
│   ├── forward_k8s_port.sh             # Port forwarding script
│   │
│   ├── app/
│   │   └── ride-ops/                   # Spring Boot application
│   │       ├── src/                    # Java source code
│   │       ├── build.gradle            # Gradle build configuration
│   │       ├── Dockerfile.amd64        # Container image definition
│   │       └── gradlew                 # Gradle wrapper
│   │
│   └── k8s/                            # Kubernetes manifests
│       ├── namespace.yaml              # Namespace definition
│       ├── mariadb/                    # Database manifests
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   └── pvc.yaml
│       └── ride-ops/                   # Application manifests
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
│
├── bin/                                # Compiled classes (build output)
└── build/                              # Build artifacts
```

## 🔒 Security Notes

**⚠️ Important**: This project is for educational/development purposes. Before production deployment:

- [ ] Replace hardcoded passwords with proper secret management
- [ ] Move database credentials to environment variables or vault
- [ ] Replace insecure private keys with proper certificates
- [ ] Enable TLS/SSL for API endpoints (use Let's Encrypt)
- [ ] Implement authentication and authorization (Spring Security + JWT)
- [ ] Configure network policies in Kubernetes
- [ ] Enable RBAC for Kubernetes access
- [ ] Use image scanning for vulnerabilities
- [ ] Implement proper backup and disaster recovery

## 🐛 Troubleshooting

### Port 8090 Already in Use
```bash
# Find and kill the process
lsof -ti:8090 | xargs kill -9
```

### Pods Not Starting
```bash
# Check pod events
kubectl describe pod <pod-name> -n themepark-app

# Check logs
kubectl logs <pod-name> -n themepark-app
```

### Image Pull Errors
```bash
# Re-import image to all nodes
docker save ride-ops:latest -o /tmp/ride-ops.tar
docker cp /tmp/ride-ops.tar k3d-themepark-server-0:/tmp/ride-ops.tar
docker exec k3d-themepark-server-0 ctr images import /tmp/ride-ops.tar
# Repeat for agent-0 and agent-1
```

### Gradle Build Fails
```bash
cd new/app/ride-ops
./gradlew clean
./gradlew build -x test --refresh-dependencies
```

### Docker Permission Denied
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and log back in, or run:
newgrp docker
```

## 🚧 Roadmap

Future enhancements planned for this project:

- [ ] CI/CD pipeline (GitLab/Jenkins)
- [ ] Helm charts for deployment
- [ ] Prometheus & Grafana monitoring
- [ ] Ingress controller with NGINX
- [ ] Terraform for cloud deployment (AWS/Azure)
- [ ] Backup and disaster recovery scripts
- [ ] Integration tests
- [ ] API documentation (Swagger/OpenAPI)

## 📚 Learning Resources

This project covers:
- Kubernetes orchestration
- Container management with Docker
- Infrastructure as Code (Ansible, Terraform)
- Microservices architecture
- DevOps automation
- Spring Boot development
- Database persistence with JPA/Hibernate

## 🤝 Contributing

This is an educational project. Feel free to fork and experiment!

## 📝 License

This project is created for educational purposes as part of DataScientest curriculum.

---

**Repository**: [mihrasik/theme-park-ride-ops](https://github.com/mihrasik/theme-park-ride-ops)
**Branch**: feature/achitecture5-new

For questions or issues, please refer to the project documentation or create an issue in the repository.
