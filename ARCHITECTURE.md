# Theme Park Ride Operations - Complete Architecture

A comprehensive guide to the architecture, components, and deployment patterns of the Theme Park Ride Operations system.

## 📊 Architecture Overview Diagram

```text
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           THEME PARK RIDE OPERATIONS                            │
│                              ARCHITECTURE OVERVIEW                              │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                 USER LAYER                                     │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                              ┌───────▼───────┐
                              │   Developer   │
                              │   ./scripts/  │
                              │  deploy-k8s   │
                              └───────┬───────┘
                                      │
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              ORCHESTRATION LAYER                                │
├─────────────────────────────────────┬───────────────────────────────────────────┤
│           k3d CLUSTER               │            AUTOMATION                    │
│  ┌─────────────────────────────┐    │  ┌─────────────────────────────────┐    │
│  │      TRAEFIK INGRESS        │    │  │         SCRIPTS                 │    │
│  │   ┌─────────────────────┐   │    │  │  • deploy-k8s.sh              │    │
│  │   │ rideops.local:80    │   │    │  │  • test-api.sh                 │    │
│  │   │ /:ride              │   │    │  │  • cleanup.sh                  │    │
│  │   └─────────┬───────────┘   │    │  └─────────────────────────────────┘    │
│  └─────────────┼─────────────────┘    │                                        │
└─────────────────┼─────────────────────────────────────────────────────────────┘
                  │
┌─────────────────┼─────────────────────────────────────────────────────────────┐
│                 │                   SERVICE LAYER                             │
├─────────────────▼─────────────────┬───────────────────────────────────────────┤
│     RIDE-OPS SERVICE              │          MARIADB SERVICE                  │
│  ┌─────────────────────────────┐  │  ┌─────────────────────────────────┐      │
│  │     Load Balancer           │  │  │        Database                 │      │
│  │   Port: 8080 (internal)     │  │  │      Port: 3306                 │      │
│  │   Exposes: 3 Pod Replicas   │  │  │   StatefulSet with PVC          │      │
│  └─────────────┬───────────────┘  │  └─────────────┬───────────────────┘      │
└─────────────────┼─────────────────────────────────────┼─────────────────────────┘
                  │                                     │
┌─────────────────┼─────────────────────────────────────┼─────────────────────────┐
│                 │               APPLICATION LAYER     │                         │
├─────────────────▼─────────────────┬─────────────────▼─────────────────────────┤
│         RIDE-OPS PODS             │            MARIADB POD                    │
│  ┌───────────────────────────┐    │    ┌─────────────────────────────────┐    │
│  │  Pod 1: ride-ops-xxx-1    │    │    │       mariadb-xxx-1             │    │
│  │  • Spring Boot 2.5.x      │    │    │  • MariaDB Latest               │    │
│  │  • Java 11                │    │    │  • Database: themepark          │    │
│  │  • Port: 5000             │    │    │  • User: themeuser              │    │
│  │  • Health: /actuator      │◄───┼────┤  • Persistent Volume: 5Gi      │    │
│  └───────────────────────────┘    │    │  • Health Checks Enabled       │    │
│  ┌───────────────────────────┐    │    └─────────────────────────────────┘    │
│  │  Pod 2: ride-ops-xxx-2    │    │                                           │
│  │  • Same as Pod 1          │    │                                           │
│  └───────────────────────────┘    │                                           │
│  ┌───────────────────────────┐    │                                           │
│  │  Pod 3: ride-ops-xxx-3    │    │                                           │
│  │  • Same as Pod 1          │    │                                           │
│  └───────────────────────────┘    │                                           │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                               STORAGE LAYER                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────┐    ┌─────────────────────────────────┐    │
│  │     PERSISTENT VOLUME CLAIM     │    │        CONFIGURATION            │    │
│  │  • mariadb-data-pvc            │    │  • ConfigMaps (db config)       │    │
│  │  • Size: 5Gi                   │    │  • Secrets (credentials)        │    │
│  │  • StorageClass: local-path     │    │  • Environment Variables        │    │
│  └─────────────────────────────────┘    └─────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 🎯 Infrastructure Evolution

### Legacy Architecture (Vagrant-based)

```text
Vagrant → Docker Containers → Manual Networking
├── 3x App Containers (Spring Boot)
├── 1x DB Container (MariaDB)
├── 1x Load Balancer (Nginx)
└── SSH-based access
```

### Modern Architecture (Kubernetes-based)

```text
k3d Cluster → Kubernetes Orchestration → Automated Deployment
├── 3x Pod Replicas (High Availability)
├── 1x Database StatefulSet (Persistent Storage)
├── Service-based Load Balancing
└── Ingress-based External Access
```

## 🏗️ Component Deep Dive

### 🚀 Application Layer

**Framework**: Spring Boot 2.5.x with Java 11

**Architecture**: REST API microservice

**Deployment**: 3 replicas for high availability

**Health Monitoring**: Spring Boot Actuator

**Resource Limits**: 512Mi-1Gi memory, 250m-500m CPU

#### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/ride` | List all rides |
| `GET` | `/ride/{id}` | Get specific ride |
| `POST` | `/ride` | Create new ride |
| `GET` | `/actuator/health` | Health check |
| `GET` | `/actuator` | All monitoring endpoints |

#### Sample API Usage

```bash
# Get all rides
curl http://localhost:8090/ride

# Create a new ride
curl -X POST http://localhost:8090/ride \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Space Mountain",
    "description": "Indoor space-themed roller coaster",
    "thrillFactor": 4,
    "vomitFactor": 2
  }'

# Health check
curl http://localhost:8090/actuator/health
```

### 🗄️ Database Layer

**Engine**: MariaDB (production) / H2 (testing)

**Deployment**: StatefulSet with persistent storage

**Storage**: 5Gi Persistent Volume Claim

**Configuration**: Environment-based (ConfigMaps/Secrets)

**Schema**: Theme park rides with thrill/vomit factors

#### Database Configuration

```yaml
ConfigMaps:
  - Database connection settings
  - Application configuration
  
Secrets:
  - Database credentials
  - API keys (future)

Environment Variables:
  - APP_ENV: production/local
  - DB_HOST: mariadb
  - DB_PORT: 3306
  - DB_NAME: themepark
  - DB_USER: themeuser
  - DB_PASS: [secret]
```

### 🌐 Network Layer

**Ingress**: Traefik (replaces nginx load balancer)

**Load Balancing**: Kubernetes Service (automatic)

**Internal Communication**: Service-to-service DNS

**External Access**: Port-forwarding or ingress routes

#### Network Flow

```text
Client Request → Traefik Ingress → Service Load Balancer → Pod (Round Robin)
                                                           ↓
Pod Application → Database Connection Pool → MariaDB StatefulSet
                                           ↓
Database Response → Application Processing → JSON API Response
```

## 📦 Deployment Patterns

### 🎯 Development Workflow

```bash
# 1. Local Development
./gradlew bootRun                 # Local JAR execution

# 2. Containerized Development
cd theme-park-ride-ops-5
docker-compose up --build         # Docker Compose

# 3. Production Deployment
./scripts/deploy-k8s.sh          # Kubernetes cluster
```

### 📦 Container Strategy

```dockerfile
# Multi-stage build optimization
FROM openjdk:11-jre-slim
COPY theme-park-ride-gradle.jar /app/
EXPOSE 5000
CMD ["java", "-jar", "/app/theme-park-ride-gradle.jar"]
```

### 🤖 Automation Scripts

| Script | Purpose | Description |
|--------|---------|-------------|
| `deploy-k8s.sh` | Complete deployment | Prerequisites, cluster creation, building, deployment |
| `test-api.sh` | API testing | Port-forwarding, endpoint testing, validation |
| `cleanup.sh` | Resource cleanup | Safe removal of all Kubernetes resources |

## 🔄 High Availability & Scalability

### 🔄 Resilience Features

- **Pod Replicas**: 3 instances for load distribution
- **Health Probes**: Liveness (60s) and Readiness (30s) checks
- **Resource Limits**: Prevents resource starvation
- **Rolling Updates**: Zero-downtime deployments
- **Service Discovery**: Automatic DNS resolution

### 📊 Monitoring & Observability

```text
Spring Boot Actuator → Prometheus (ready) → Grafana (future)
├── Health endpoints
├── Metrics collection
├── JVM monitoring
└── Custom business metrics
```

#### Health Check Configuration

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health
    port: 5000
  initialDelaySeconds: 60
  periodSeconds: 30

readinessProbe:
  httpGet:
    path: /actuator/health
    port: 5000
  initialDelaySeconds: 30
  periodSeconds: 10
```

## 🔒 Security Implementation

### 🔒 Security Layers

- **Network Isolation**: Kubernetes namespaces (`themepark-app`)
- **Secret Management**: Kubernetes Secrets for credentials
- **Container Security**: Non-root user execution
- **Configuration Externalization**: No hardcoded credentials
- **Resource Limits**: Prevent resource abuse

### 🔐 Configuration Security

```yaml
# Secrets (encrypted at rest)
apiVersion: v1
kind: Secret
metadata:
  name: rideops-secret
  namespace: themepark-app
type: Opaque
data:
  db_user: <base64-encoded>
  db_pass: <base64-encoded>

# ConfigMaps (non-sensitive config)
apiVersion: v1
kind: ConfigMap
metadata:
  name: rideops-config
  namespace: themepark-app
data:
  db_host: "mariadb"
  db_port: "3306"
  db_name: "themepark"
```

## 🔄 CI/CD & DevOps

### 🤖 Automation Pipeline

```text
Developer → Git Push → GitHub Actions → Docker Build → Image Registry
                                                         ↓
ArgoCD GitOps ← Helm Charts ← Kubernetes Manifests ← Automated Update
      ↓
Production Deployment
```

### 🔄 GitOps Readiness

- **Container Registry**: Docker image building and versioning
- **Helm Charts**: Infrastructure as Code templates
- **ArgoCD Integration**: Continuous deployment monitoring
- **GitHub Actions**: CI/CD pipeline automation

### 📋 Deployment Environments

| Environment | Technology | Purpose |
|-------------|------------|---------|
| **Local** | `./gradlew bootRun` | Development and testing |
| **Docker** | `docker-compose up` | Local containerized testing |
| **Kubernetes** | `./scripts/deploy-k8s.sh` | Production-like deployment |
| **Cloud** | Terraform + Ansible | Production deployment |

## 🏗️ Technology Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Orchestration** | Kubernetes (k3d) | 1.28+ | Container orchestration |
| **Application** | Spring Boot | 2.5.x | REST API framework |
| **Runtime** | Java | 11 | Application runtime |
| **Database** | MariaDB | Latest | Data persistence |
| **Testing DB** | H2 | Latest | In-memory testing |
| **Build** | Gradle | 7.x | Application building |
| **Container** | Docker | 20+ | Application packaging |
| **Ingress** | Traefik | 2.x | Load balancing & routing |
| **Monitoring** | Spring Actuator | 2.5.x | Health & metrics |
| **Automation** | Shell Scripts | Bash | Deployment automation |

## 🎯 Quick Start Commands

### Deployment

```bash
# Deploy everything to Kubernetes
./scripts/deploy-k8s.sh

# Test all API endpoints
./scripts/test-api.sh

# Clean up resources
./scripts/cleanup.sh
```

### Manual Testing

```bash
# Port forward for local access
kubectl port-forward service/ride-ops 8090:8080 -n themepark-app

# Create a ride
curl -X POST http://localhost:8090/ride \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Ride","description":"Fun ride","thrillFactor":3,"vomitFactor":1}'

# List all rides
curl http://localhost:8090/ride

# Check health
curl http://localhost:8090/actuator/health
```

### Debugging

```bash
# Check pod status
kubectl get pods -n themepark-app

# View application logs
kubectl logs -f deployment/ride-ops -n themepark-app

# Access database
kubectl exec -it deployment/mariadb -n themepark-app -- /bin/bash
mariadb -u themeuser -p

# Show tables
show databases;
use themepark;
show tables;
select * from theme_park_ride;
```

## 📚 Project Structure

```
theme-park-ride-ops-4/
├── src/                          # Spring Boot application source
│   ├── main/java/com/exemple/    # Application code
│   │   ├── controller/           # REST controllers
│   │   ├── model/                # JPA entities
│   │   └── repository/           # Data repositories
│   └── test/                     # Unit and integration tests
├── scripts/                      # Automation scripts
│   ├── deploy-k8s.sh            # Complete deployment automation
│   ├── test-api.sh              # API testing with port-forwarding
│   ├── cleanup.sh               # Resource cleanup
│   └── README.md                # Scripts documentation
├── theme-park-ride-ops-5/        # Kubernetes and modern configs
│   ├── k8s/                      # Kubernetes manifests
│   │   ├── ride-ops/             # Application deployment configs
│   │   └── mariadb/              # Database configurations
│   ├── helm/                     # Helm charts
│   ├── docker-compose.yml        # Local development
│   └── app/ride-ops/             # Application container
├── build.gradle                  # Gradle build configuration
├── README.md                     # Project overview
├── ARCHITECTURE.md               # This file
├── QUICKSTART.md                 # Quick start guide
└── commands.txt                  # Command reference
```

## 🚀 Future Enhancements

### Planned Features

- **Monitoring**: Prometheus + Grafana integration
- **Security**: OAuth2/JWT authentication
- **CI/CD**: Complete GitLab CI or GitHub Actions pipeline
- **Cloud**: AWS/GCP/Azure deployment via Terraform
- **Backup**: Database backup and disaster recovery
- **Scaling**: Horizontal Pod Autoscaler (HPA)
- **Observability**: Distributed tracing with Jaeger

### Production Considerations

- **SSL/TLS**: HTTPS termination at ingress
- **Service Mesh**: Istio for advanced traffic management
- **Secrets**: External secret management (Vault, AWS Secrets Manager)
- **Backup**: Automated database backups
- **Monitoring**: Application Performance Monitoring (APM)
- **Logging**: Centralized logging with ELK stack

---

## 📖 Additional Resources

- [Quick Start Guide](QUICKSTART.md) - Get running in 2 commands
- [Scripts Documentation](scripts/README.md) - Detailed automation guide
- [Commands Reference](commands.txt) - All available commands
- [GitHub Copilot Instructions](.github/copilot-instructions.md) - AI assistance setup

This architecture provides a **production-ready, scalable, and maintainable** solution that can be deployed from local development to enterprise cloud environments! 🎢✨