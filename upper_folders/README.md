# Theme Park Ride Operations# Theme Park Ride Operations



A microservices-based theme park ride operations system built with Spring Boot, featuring REST APIs for managing theme park rides, complete with database persistence and Kubernetes deployment automation.A microservices-based theme park ride operations system built with Spring Boot, featuring REST APIs for managing theme park rides, complete with database persistence and Kubernetes deployment automation.



## 🎢 Quick Start## 🎢 Quick Start



### Option 1: Kubernetes Deployment (Recommended)### Option 1: Kubernetes Deployment (Recommended)



Deploy the entire application to Kubernetes with a single command:Deploy the entire application to Kubernetes with a single command:



```bash```bash

./scripts/deploy-k8s.sh./scripts/deploy-k8s.sh

``````



Test the API:Test the API:



```bash```bash

./scripts/test-api.sh./scripts/test-api.sh

``````



### Option 2: Docker Compose (Local Development)### Option 2: Docker Compose (Local Development)



For local development with Docker:For local development with Docker:



```bash```bash

cd theme-park-ride-ops-5cd theme-park-ride-ops-5

docker-compose up --builddocker-compose up --build

``````



## 🚀 Features## 🚀 Features



- **REST API**: Complete CRUD operations for theme park rides- **REST API**: Complete CRUD operations for theme park rides

- **Database**: MariaDB with persistent storage (production) / H2 (testing)- **Database**: MariaDB with persistent storage (production) / H2 (testing)

- **Kubernetes Ready**: Automated deployment scripts with health checks- **Kubernetes Ready**: Automated deployment scripts with health checks

- **Monitoring**: Spring Boot Actuator with health endpoints- **Monitoring**: Spring Boot Actuator with health endpoints

- **High Availability**: 3-replica deployment with load balancing- **High Availability**: 3-replica deployment with load balancing

- **CI/CD Ready**: GitLab CI and Jenkins pipeline support- **CI/CD Ready**: GitLab CI and Jenkins pipeline support



## 📋 API Endpoints## 📋 API Endpoints



| Method | Endpoint | Description || Method | Endpoint | Description |

|--------|----------|-------------||--------|----------|-------------|

| `GET` | `/ride` | Get all rides || `GET` | `/ride` | Get all rides |

| `GET` | `/ride/{id}` | Get specific ride || `GET` | `/ride/{id}` | Get specific ride |

| `POST` | `/ride` | Create new ride || `POST` | `/ride` | Create new ride |

| `GET` | `/actuator/health` | Health check || `GET` | `/actuator/health` | Health check |

| `GET` | `/actuator` | All monitoring endpoints || `GET` | `/actuator` | All monitoring endpoints |



### Example Usage### Example Usage



```bash```bash

# Get all rides# Get all rides

curl http://localhost:8090/ridecurl http://localhost:8090/ride



# Create a new ride# Create a new ride

curl -X POST http://localhost:8090/ride \curl -X POST http://localhost:8090/ride \

  -H "Content-Type: application/json" \  -H "Content-Type: application/json" \

  -d '{  -d '{

    "name": "Space Mountain",    "name": "Space Mountain",

    "description": "Indoor space-themed roller coaster",    "description": "Indoor space-themed roller coaster",

    "thrillFactor": 4,    "thrillFactor": 4,

    "vomitFactor": 2    "vomitFactor": 2

  }'  }'

``````



## 🏗️ Architecture## 🏗️ Architecture



### Production (Kubernetes)### Production (Kubernetes)



```text```text

┌─────────────────┐    ┌─────────────────┐┌─────────────────┐    ┌─────────────────┐

│   Load Balancer │    │      Ingress    ││   Load Balancer │    │      Ingress    │

│   (k3d/Traefik) │────│   (rideops)     ││   (k3d/Traefik) │────│   (rideops)     │

└─────────────────┘    └─────────────────┘└─────────────────┘    └─────────────────┘

                                │                                │

                    ┌───────────┴───────────┐                    ┌───────────┴───────────┐

                    │                       │                    │                       │

              ┌─────▼─────┐           ┌─────▼─────┐              ┌─────▼─────┐           ┌─────▼─────┐

              │ Ride-Ops  │           │  MariaDB  │              │ Ride-Ops  │           │  MariaDB  │

              │ (3 pods)  │───────────│ (1 pod)   │              │ (3 pods)  │───────────│ (1 pod)   │

              │ Port 5000 │           │ Port 3306 │              │ Port 5000 │           │ Port 3306 │

              └───────────┘           └───────────┘              └───────────┘           └───────────┘

                                           │                                           │

                                    ┌─────▼─────┐                                    ┌─────▼─────┐

                                    │    PVC    │                                    │    PVC    │

                                    │   (5Gi)   │                                    │   (5Gi)   │

                                    └───────────┘                                    └───────────┘

``````



### Tech Stack### Technology Stack



- **Backend**: Spring Boot 2.5.x, Java 11- **Backend**: Spring Boot 2.5.x, Java 11

- **Database**: MariaDB (production), H2 (testing)

- **Container**: Docker, Kubernetes### Technology Stack

- **Build**: Gradle- **Backend**: Spring Boot 2.5.x, Java 11

- **Orchestration**: k3d, Helm, Traefik- **Database**: MariaDB (production), H2 (testing)

- **Monitoring**: Spring Actuator, Prometheus-ready- **Container**: Docker, Kubernetes

- **Build**: Gradle

## 🛠️ Development- **Orchestration**: k3d, Helm, Traefik

- **Monitoring**: Spring Actuator, Prometheus-ready

### Prerequisites

## 🛠️ Development

- Java 11+

- Docker### Prerequisites

- kubectl- Java 11+

- k3d (auto-installed by deployment script)- Docker

- kubectl

### Local Development Setup- k3d (auto-installed by deployment script)



1. **Clone the repository**### Local Development Setup



   ```bash1. **Clone the repository**

   git clone <repository-url>   ```bash

   cd theme-park-ride-ops-4   git clone <repository-url>

   ```   cd theme-park-ride-ops-4

   ```

2. **Build the application**

2. **Build the application**

   ```bash   ```bash

   ./gradlew clean build   ./gradlew clean build

   ```   ```



3. **Run tests**3. **Run tests**

   ```bash

   ```bash   ./gradlew test

   ./gradlew test   ```

   ```

4. **Deploy to Kubernetes**

4. **Deploy to Kubernetes**   ```bash

   ./scripts/deploy-k8s.sh

   ```bash   ```

   ./scripts/deploy-k8s.sh

   ```5. **Test the API**

   ```bash

5. **Test the API**   ./scripts/test-api.sh

   ```

   ```bash

   ./scripts/test-api.sh### Database Configuration

   ```

The application automatically configures the database based on the environment:

### Database Configuration

- **Production**: MariaDB with network persistence

The application automatically configures the database based on the environment:- **Testing**: H2 in-memory database

- **Environment Variables**: Injected via Kubernetes ConfigMaps and Secrets

- **Production**: MariaDB with network persistence

- **Testing**: H2 in-memory database## 📦 Deployment Options

- **Environment Variables**: Injected via Kubernetes ConfigMaps and Secrets

### 1. Kubernetes (Production)

## 📦 Deployment Options- **Automated**: Run `./scripts/deploy-k8s.sh`

- **Manual**: Use Helm charts in `helm/umbrella-chart/`

### 1. Kubernetes (Production)- **Monitoring**: Built-in health checks and readiness probes



- **Automated**: Run `./scripts/deploy-k8s.sh`### 2. Docker Compose (Development)

- **Manual**: Use Helm charts in `helm/umbrella-chart/````bash

- **Monitoring**: Built-in health checks and readiness probescd theme-park-ride-ops-5

docker-compose up --build

### 2. Docker Compose (Development)```



```bash### 3. Local JAR

cd theme-park-ride-ops-5```bash

docker-compose up --build./gradlew bootRun

``````



### 3. Local JAR## 🔧 Configuration



```bash### Environment Variables

./gradlew bootRun```bash

```# Database Configuration

DB_HOST=mariadb          # Database hostname

## 🔧 ConfigurationDB_PORT=3306             # Database port

DB_NAME=themepark        # Database name

### Environment VariablesDB_USER=themeuser        # Database username

DB_PASS=themedb123       # Database password

```bash

# Database Configuration# Application

DB_HOST=mariadb          # Database hostnameAPP_ENV=production       # Environment (local/production)

DB_PORT=3306             # Database port```

DB_NAME=themepark        # Database name

DB_USER=themeuser        # Database username### Kubernetes Resources

DB_PASS=themedb123       # Database password```yaml

# Resource allocation per pod

# Applicationresources:

APP_ENV=production       # Environment (local/production)  requests:

```    memory: "512Mi"

    cpu: "250m"

### Kubernetes Resources  limits:

    memory: "1Gi"

```yaml    cpu: "500m"

# Resource allocation per pod```

resources:

  requests:## 🧪 Testing

    memory: "512Mi"

    cpu: "250m"### Automated API Testing

  limits:```bash

    memory: "1Gi"./scripts/test-api.sh

    cpu: "500m"```

```

### Unit Tests

## 🧪 Testing```bash

./gradlew test

### Automated API Testing```



```bash### Manual Testing

./scripts/test-api.sh```bash

```# Port forward to access the API

kubectl port-forward service/ride-ops 8090:8080 -n themepark-app

### Unit Tests

# Test endpoints

```bashcurl http://localhost:8090/ride

./gradlew testcurl http://localhost:8090/actuator/health

``````



### Manual Testing## 📊 Monitoring



```bash### Health Checks

# Port forward to access the API- **Endpoint**: `/actuator/health`

kubectl port-forward service/ride-ops 8090:8080 -n themepark-app- **Liveness Probe**: 60s delay, 30s interval

- **Readiness Probe**: 30s delay, 10s interval

# Test endpoints

curl http://localhost:8090/ride### Metrics

curl http://localhost:8090/actuator/health- **Endpoint**: `/actuator/metrics`

```- **Prometheus Compatible**: Ready for Prometheus scraping

- **JVM Metrics**: Memory, GC, threads

## 📊 Monitoring

## 🧹 Cleanup

### Health Checks

Remove all Kubernetes resources:

- **Endpoint**: `/actuator/health````bash

- **Liveness Probe**: 60s delay, 30s interval./scripts/cleanup.sh

- **Readiness Probe**: 30s delay, 10s interval```



### Metrics## 🚨 Troubleshooting



- **Endpoint**: `/actuator/metrics`### Common Issues

- **Prometheus Compatible**: Ready for Prometheus scraping

- **JVM Metrics**: Memory, GC, threads1. **Pods not starting**

   ```bash

## 🧹 Cleanup   kubectl get pods -n themepark-app

   kubectl logs -f deployment/ride-ops -n themepark-app

Remove all Kubernetes resources:   ```



```bash2. **Database connection errors**

./scripts/cleanup.sh   ```bash

```   kubectl exec -it deployment/mariadb -n themepark-app -- mysql -u themeuser -p

   ```

## 🚨 Troubleshooting

3. **Port forwarding issues**

### Common Issues   ```bash

   pkill -f "kubectl port-forward"

1. **Pods not starting**   kubectl port-forward service/ride-ops 8090:8080 -n themepark-app

   ```

   ```bash

   kubectl get pods -n themepark-app## 📚 Project Structure

   kubectl logs -f deployment/ride-ops -n themepark-app

   ``````

theme-park-ride-ops-4/

2. **Database connection errors**├── src/                          # Spring Boot application source

├── theme-park-ride-ops-5/        # Kubernetes and container configs

   ```bash│   ├── k8s/                      # Kubernetes manifests

   kubectl exec -it deployment/mariadb -n themepark-app -- mysql -u themeuser -p│   ├── helm/                     # Helm charts

   ```│   ├── docker-compose.yml        # Local development

│   └── app/ride-ops/             # Application container

3. **Port forwarding issues**├── scripts/                      # Automation scripts

│   ├── deploy-k8s.sh            # Full deployment automation

   ```bash│   ├── test-api.sh              # API testing

   pkill -f "kubectl port-forward"│   ├── cleanup.sh               # Resource cleanup

   kubectl port-forward service/ride-ops 8090:8080 -n themepark-app│   └── README.md                # Scripts documentation

   ```└── README.md                     # This file

```

## 📚 Project Structure

## 🤝 Contributing

```

theme-park-ride-ops-4/1. Fork the repository

├── src/                          # Spring Boot application source2. Create a feature branch

├── theme-park-ride-ops-5/        # Kubernetes and container configs3. Make your changes

│   ├── k8s/                      # Kubernetes manifests4. Run tests: `./gradlew test`

│   ├── helm/                     # Helm charts5. Test deployment: `./scripts/deploy-k8s.sh`

│   ├── docker-compose.yml        # Local development6. Submit a pull request

│   └── app/ride-ops/             # Application container

├── scripts/                      # Automation scripts## 📄 License

│   ├── deploy-k8s.sh            # Full deployment automation

│   ├── test-api.sh              # API testingThis project is part of a DataScientest educational program.

│   ├── cleanup.sh               # Resource cleanup

│   └── README.md                # Scripts documentation---

└── README.md                     # This file

```## 🎯 Getting Started Checklist



## 🤝 Contributing- [ ] Clone the repository

- [ ] Install prerequisites (Docker, kubectl)

1. Fork the repository- [ ] Run `./scripts/deploy-k8s.sh`

2. Create a feature branch- [ ] Run `./scripts/test-api.sh`

3. Make your changes- [ ] Access API at `http://localhost:8090/ride`

4. Run tests: `./gradlew test`- [ ] Explore other endpoints at `/actuator`

5. Test deployment: `./scripts/deploy-k8s.sh`

6. Submit a pull request**Need help?** Check the [scripts documentation](scripts/README.md) for detailed troubleshooting guide.



## 📄 License

This project is part of a DataScientest educational program.

---

## 🎯 Getting Started Checklist

- [ ] Clone the repository
- [ ] Install prerequisites (Docker, kubectl)
- [ ] Run `./scripts/deploy-k8s.sh`
- [ ] Run `./scripts/test-api.sh`
- [ ] Access API at `http://localhost:8090/ride`
- [ ] Explore other endpoints at `/actuator`

**Need help?** Check the [scripts documentation](scripts/README.md) for detailed troubleshooting guide.