# 🎢🎠🎡 Theme Park Ride Ops - Scripts 🎡🎠🎢

Welcome to the magical world of Theme Park Ride Operations! This directory contains all the scripts needed to build, deploy, and manage your theme park application.

## 🎪 Available Scripts

### 🎢 Environment Setup
```bash
# Set up your magical workspace
./scripts/setup-env.sh
```
**What it does:** Configures all environment variables and paths automatically. No more hardcoded paths!

### 🎠 Multi-Architecture Build
```bash
# Build for all platforms
./scripts/build-multiarch.sh

# Build locally for testing
./scripts/build-multiarch.sh --local --test

# Build with custom tag
./scripts/build-multiarch.sh v1.2.3
```
```

To test the API endpoints:

```bash
./scripts/test-api.sh
```

To clean up all resources:

```bash
./scripts/cleanup.sh
```

## 📋 Scripts Overview

### `deploy-k8s.sh` - Complete Deployment
Automates the entire deployment process:

- ✅ Checks prerequisites (kubectl, docker, k3d)
- ✅ Creates/manages k3d cluster
- ✅ Builds Spring Boot application
- ✅ Creates Docker image and imports to cluster
- ✅ Deploys MariaDB with persistent storage
- ✅ Deploys ride-ops application (3 replicas)
- ✅ Creates all necessary secrets and configmaps
- ✅ Verifies deployment status

**Usage:**
```bash
./scripts/deploy-k8s.sh
```

**What it creates:**
- k3d cluster named "themepark"
- Namespace: `themepark-app`
- MariaDB deployment with persistent storage
- Ride-ops application with 3 replicas
- Services and ingress configuration

### `test-api.sh` - API Testing
Comprehensive API testing script:

- ✅ Checks cluster and deployment status
- ✅ Sets up port-forwarding automatically
- ✅ Tests all API endpoints with colored output
- ✅ Validates HTTP responses
- ✅ Creates sample data and verifies CRUD operations

**Usage:**
```bash
./scripts/test-api.sh
```

**Endpoints tested:**
- `GET /actuator/health` - Health check
- `GET /ride` - Get all rides
- `GET /ride/{id}` - Get specific ride
- `POST /ride` - Create new ride

### `cleanup.sh` - Resource Cleanup
Safely removes all resources:

- ✅ Confirmation prompts for safety
- ✅ Removes Kubernetes namespace and all resources
- ✅ Stops port-forward processes
- ✅ Optionally deletes entire k3d cluster

**Usage:**
```bash
./scripts/cleanup.sh
```

## 🎯 Prerequisites

The deployment script will check and guide you through installing these prerequisites:

1. **kubectl** - Kubernetes CLI tool
   ```bash
   # macOS
   brew install kubectl
   
   # Or visit: https://kubernetes.io/docs/tasks/tools/
   ```

2. **Docker** - Container runtime
   ```bash
   # Visit: https://docs.docker.com/get-docker/
   ```

3. **k3d** - Lightweight Kubernetes (auto-installed by script)
   ```bash
   # The script will install this automatically
   ```

## 🏗️ Architecture

The deployment creates the following Kubernetes resources:

```
themepark-app namespace
├── MariaDB
│   ├── Deployment (1 replica)
│   ├── Service (ClusterIP:3306)
│   ├── PersistentVolumeClaim (5Gi)
│   └── Secret (database credentials)
│
├── Ride-Ops Application
│   ├── Deployment (3 replicas)
│   ├── Service (ClusterIP:8080)
│   ├── Ingress (rideops.local)
│   ├── ConfigMap (database connection)
│   └── Secret (application credentials)
│
└── k3d LoadBalancer
    ├── Port 8081:80 (HTTP)
    └── Port 8444:443 (HTTPS)
```

## 🔧 Configuration

### Environment Variables
The application uses these environment variables in Kubernetes:

```yaml
# Database Configuration (from ConfigMap)
DB_HOST: mariadb
DB_PORT: 3306
DB_NAME: themepark

# Credentials (from Secrets)
DB_USER: themeuser
DB_PASS: themedb123
MYSQL_ROOT_PASSWORD: rootpassword
```

### Resource Limits
```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

## 🌐 Access Methods

### 1. Port Forwarding (Recommended for testing)
```bash
kubectl port-forward service/ride-ops 8090:8080 -n themepark-app
curl http://localhost:8090/ride
```

### 2. Ingress (localhost)
```bash
# Add to /etc/hosts: 127.0.0.1 rideops.local
curl http://rideops.local:8081/ride
```

### 3. Direct Service Access (from within cluster)
```bash
kubectl run curl --image=curlimages/curl -it --rm -- sh
curl http://ride-ops:8080/ride
```

## 🛠️ Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n themepark-app
kubectl logs -f deployment/ride-ops -n themepark-app
```

### Check Services
```bash
kubectl get services -n themepark-app
```

### Database Connection Issues
```bash
kubectl exec -it deployment/mariadb -n themepark-app -- mysql -u themeuser -p themepark
```

### Port Forward Issues
```bash
# Kill existing port-forwards
pkill -f "kubectl port-forward"

# Start new port-forward
kubectl port-forward service/ride-ops 8090:8080 -n themepark-app
```

### Cluster Issues
```bash
# Restart cluster
k3d cluster stop themepark
k3d cluster start themepark

# Or recreate completely
k3d cluster delete themepark
./scripts/deploy-k8s.sh
```

## 📊 Monitoring

### Health Checks
The application includes health checks:
- **Liveness Probe**: `/actuator/health` (60s delay, 30s interval)
- **Readiness Probe**: `/actuator/health` (30s delay, 10s interval)

### Actuator Endpoints
Available at `http://localhost:8090/actuator/`:
- `/health` - Application health
- `/metrics` - Application metrics
- `/info` - Application information
- `/env` - Environment variables

## 🔄 Development Workflow

1. **Make code changes**
2. **Rebuild and redeploy:**
   ```bash
   ./scripts/deploy-k8s.sh
   ```
3. **Test changes:**
   ```bash
   ./scripts/test-api.sh
   ```
4. **View logs:**
   ```bash
   kubectl logs -f deployment/ride-ops -n themepark-app
   ```

## 🎉 Success Indicators

After running `./scripts/deploy-k8s.sh`, you should see:

✅ **All pods running:**
```
NAME                        READY   STATUS    RESTARTS
mariadb-xxx                 1/1     Running   0
ride-ops-xxx                1/1     Running   0
ride-ops-yyy                1/1     Running   0
ride-ops-zzz                1/1     Running   0
```

✅ **API responding:**
```bash
curl http://localhost:8090/ride
# Should return JSON array of rides
```

✅ **Health check passing:**
```bash
curl http://localhost:8090/actuator/health
# Should return {"status":"UP"}
```

---

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. View application logs: `kubectl logs -f deployment/ride-ops -n themepark-app`
3. Verify cluster status: `kubectl cluster-info`
4. Try the cleanup and redeploy: `./scripts/cleanup.sh && ./scripts/deploy-k8s.sh`