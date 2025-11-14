# 🎢 Theme Park Ride Ops - Portable DevOps Setup

## 🎯 Zero Dependencies - Works Anywhere!

This setup ensures the Theme Park Ride Ops application can be deployed on **any machine** without hardcoded paths or pre-installed dependencies.

## 📁 Project Structure

```
theme-park-ride-ops-4/
├── scripts/
│   ├── setup-env.sh                      # 🔧 Portable environment setup
│   ├── build-multiarch.sh                # 🐳 Multi-architecture Docker build
│   ├── ansible_playbook_universal_setup.yml  # 📦 Universal tool installation
│   └── ansible_aws_deployment.yml        # ☁️ AWS deployment
├── containers/app/
│   └── Dockerfile.multiarch              # 🏗️ Multi-platform container
└── theme-park-ride-ops-5/
    └── scripts/deploy-to-k8s.sh          # ☸️ Kubernetes deployment
```

## 🚀 Quick Start (Any Machine)

### 1. Environment Setup
```bash
# Clone and setup environment (auto-detects paths)
git clone <repository>
cd theme-park-ride-ops-4
source ./scripts/setup-env.sh
```

### 2. Install DevOps Tools (Zero Dependencies)
```bash
# Works on Ubuntu, CentOS, Amazon Linux, macOS
sudo ansible-playbook scripts/ansible_playbook_universal_setup.yml --ask-become-pass
```

### 3. Build Multi-Architecture Images
```bash
# Builds for both AMD64 and ARM64
./scripts/build-multiarch.sh

# Or build locally for testing
./scripts/build-multiarch.sh --local --test
```

### 4. Deploy to Kubernetes
```bash
# Auto-detects cluster and deploys
./theme-park-ride-ops-5/scripts/deploy-to-k8s.sh
```

## 🌍 Environment Variables

All paths are **dynamically detected**. Override if needed:

```bash
# Application Configuration
export APP_NAME="theme-park-ride-ops"
export APP_VERSION="v1.0.0"
export DOCKER_REGISTRY="your-registry.com/namespace"

# Kubernetes Configuration  
export K8S_NAMESPACE="production"
export K8S_CLUSTER_NAME="prod-cluster"

# Database Configuration
export DB_HOST="prod-db.example.com"
export DB_NAME="themepark_prod"
export DB_USER="prod_user"
export DB_PASSWORD="secure_password"
```

## 🏗️ Architecture Support

### Multi-Platform Docker Images
- **AMD64** (Intel/AMD) - for most cloud providers
- **ARM64** (Apple Silicon, AWS Graviton) - cost-effective performance

### Operating System Support
- **Ubuntu** 18.04+ 
- **Amazon Linux** 2
- **CentOS/RHEL** 7+
- **macOS** (Intel & Apple Silicon)

### Cloud Provider Ready
- **AWS EC2** (any instance type)
- **Azure VMs**
- **Google Cloud Compute**
- **Local development**

## 📦 What Gets Installed

The universal setup installs everything from scratch:

### Container & Orchestration
- **Docker CE** (latest stable)
- **Docker Compose** (latest)
- **Kubernetes kubectl** (v1.28.0)
- **k3d** (local Kubernetes)
- **Helm** (package manager)

### Infrastructure Tools  
- **Terraform** (v1.5.7)
- **Ansible** (latest)

### Development Tools
- **Java 11** (OpenJDK)
- **Git** (version control)
- **curl, wget, unzip** (utilities)

## 🔧 Usage Examples

### Development Workflow
```bash
# Setup environment
source ./scripts/setup-env.sh

# Check current configuration  
print_env

# Build application locally
./scripts/build-multiarch.sh --local

# Deploy to local k3d cluster
./theme-park-ride-ops-5/scripts/deploy-to-k8s.sh
```

### Production Deployment
```bash
# Build and push multi-arch images
export DOCKER_REGISTRY="your-registry.com/themepark" 
./scripts/build-multiarch.sh v1.0.0

# Deploy to AWS EC2 instances
ansible-playbook -i aws-inventory.ini scripts/ansible_aws_deployment.yml \
  -e version=v1.0.0 \
  -e registry=your-registry.com/themepark
```

### CI/CD Pipeline
```bash
# Automated build (in GitHub Actions, etc.)
#!/bin/bash
source ./scripts/setup-env.sh
./scripts/build-multiarch.sh "${GITHUB_SHA::7}"
```

## 🐳 Docker Multi-Architecture Build

### Automatic Platform Detection
```bash
# Detects your platform and builds accordingly
./scripts/build-multiarch.sh --local

# Builds for both AMD64 and ARM64
./scripts/build-multiarch.sh --multi
```

### Manual Platform Override
```bash
# Force specific platform
export DOCKER_PLATFORM="linux/amd64"
./scripts/build-multiarch.sh --local
```

## ☁️ AWS Deployment

### EC2 Instance Setup
```bash
# Inventory file: aws-inventory.ini
[aws_instances]
web-1 ansible_host=54.123.45.67 ansible_user=ubuntu
web-2 ansible_host=54.123.45.68 ansible_user=ubuntu  
db-1 ansible_host=54.123.45.69 ansible_user=ubuntu

# Deploy
ansible-playbook -i aws-inventory.ini scripts/ansible_aws_deployment.yml
```

### Environment-Specific Configuration
```bash
# Production deployment with custom settings
ansible-playbook -i production.ini scripts/ansible_aws_deployment.yml \
  -e app_version="v2.1.0" \
  -e database_host="prod-db.amazonaws.com" \
  -e namespace="production" \
  -e registry="123456789.dkr.ecr.us-west-2.amazonaws.com"
```

## 🔍 Troubleshooting

### Path Issues
```bash
# Verify environment setup
source ./scripts/setup-env.sh
echo "Project Root: ${PROJECT_ROOT}"
echo "Scripts Dir: ${SCRIPTS_DIR}"
```

### Tool Installation
```bash
# Check what's installed
source ./scripts/setup-env.sh
CHECK_TOOLS=true ./scripts/setup-env.sh
```

### Container Build Issues  
```bash
# Build locally for debugging
./scripts/build-multiarch.sh --local --test

# Check Docker buildx
docker buildx ls
```

## 🎯 Benefits

✅ **Zero Hardcoded Paths** - Works in any directory structure  
✅ **Multi-Platform Support** - AMD64 and ARM64 ready  
✅ **Cloud Agnostic** - Runs on AWS, Azure, GCP, local  
✅ **Zero Dependencies** - Installs everything from scratch  
✅ **DevOps Best Practices** - Infrastructure as Code  
✅ **Production Ready** - Monitoring, logging, security included  

This setup ensures your Theme Park Ride Ops application deploys consistently across any environment - from your laptop to AWS production! 🚀