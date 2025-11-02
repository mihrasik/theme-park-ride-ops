# Theme Park Ride Operations - System Design Document

A simple system design document with basic flowcharts and diagrams for the Theme Park Ride Operations system.

## Table of Contents

1. System Overview
2. Basic Architecture Flow
3. Component Interactions
4. API Request Flow
5. Database Design
6. Error Handling
7. Health Checks

---

## 1. System Overview

### Simple System Flow

```
Developer -> HTTP Request -> Kubernetes -> Spring Boot App -> Database
Developer <- HTTP Response <- Kubernetes <- Spring Boot App <- Database
```

### Main Components

```
1. Developer/Client (External)
2. Kubernetes Cluster (k3d)
3. Spring Boot Application (3 replicas)
4. MariaDB Database (1 instance)
5. Configuration (Secrets/ConfigMaps)
```

---

## 2. Basic Architecture Flow

### Request Processing

```
Step 1: Developer sends HTTP request
Step 2: Traefik receives request
Step 3: Kubernetes Service routes to Pod
Step 4: Spring Boot processes request
Step 5: Database operation (if needed)
Step 6: Response sent back
```

### Component Layout

```
[Developer] 
    |
[Traefik Load Balancer]
    |
[Kubernetes Service]
    |
[Spring Boot Pods] ---- [MariaDB Pod]
    |                       |
[Application Logic]    [Database Storage]
```

---

## 3. Component Interactions

### Basic Component Map

```
External:
- Developer (HTTP Client)

Kubernetes Layer:
- Traefik (Ingress)
- Service (Load Balancer)
- Pods (Application Instances)

Application Layer:
- Controller (REST API)
- Service (Business Logic)
- Repository (Data Access)

Data Layer:
- MariaDB (Database)
- Persistent Volume (Storage)
```

### Communication Flow

```
HTTP Request -> Ingress -> Service -> Pod -> Database
HTTP Response <- Ingress <- Service <- Pod <- Database
```

---

## 4. API Request Flow

### GET /ride Request

```
1. Receive GET /ride
2. Validate request
3. Call repository.findAll()
4. Execute SQL: SELECT * FROM theme_park_ride
5. Return list of rides as JSON
6. Send HTTP 200 response
```

### POST /ride Request

```
1. Receive POST /ride + JSON data
2. Validate JSON fields
3. Create new entity object
4. Call repository.save()
5. Execute SQL: INSERT INTO theme_park_ride
6. Return saved entity as JSON
7. Send HTTP 200 response
```

### Error Cases

```
Bad Request (400):
- Invalid JSON format
- Missing required fields
- Field validation errors

Not Found (404):
- Invalid ride ID
- Resource doesn't exist

Server Error (500):
- Database connection failed
- Unexpected system error
```

---

## 5. Database Design

### Table Structure

```
Table: theme_park_ride

Columns:
- id (Primary Key, Auto-increment)
- name (String, Required)
- description (Text, Optional)
- thrill_factor (Integer, 1-5)
- vomit_factor (Integer, 1-5)
- created_date (Timestamp)
- updated_date (Timestamp)
```

### Sample Data

```
ID | Name          | Description           | Thrill | Vomit
---|---------------|-----------------------|--------|-------
1  | Rollercoaster | Fast train ride       | 5      | 3
2  | Log flume     | Water boat ride       | 3      | 2
3  | Teacups       | Spinning ride         | 2      | 4
```

### Database Connection

```
Spring Boot App -> Connection Pool -> MariaDB
                -> Max 10 connections
                -> Timeout: 30 seconds
```

---

## 6. Error Handling

### Error Flow

```
Request -> Processing -> Error Occurs -> Check Error Type -> Return Response

Error Types:
1. Validation Error -> 400 Bad Request
2. Not Found Error -> 404 Not Found
3. Database Error -> 500 Internal Server Error
4. System Error -> 500 Internal Server Error
```

### Error Response Format

```
{
  "error": "error_type",
  "message": "human readable message",
  "timestamp": "2025-11-02T10:30:00Z"
}
```

---

## 7. Health Checks

### Health Check Flow

```
Kubernetes -> /actuator/health -> Spring Boot -> Database Test -> Response

Health Indicators:
1. Application Status (Always UP if running)
2. Database Connection (Test query: SELECT 1)
3. Disk Space (Check available space)
```

### Health Response

```
Healthy Response (200 OK):
{
  "status": "UP",
  "components": {
    "db": "UP",
    "diskSpace": "UP"
  }
}

Unhealthy Response (503 Service Unavailable):
{
  "status": "DOWN",
  "components": {
    "db": "DOWN",
    "diskSpace": "UP"
  }
}
```

### Kubernetes Probes

```
Liveness Probe:
- URL: /actuator/health
- Initial Delay: 60 seconds
- Check Every: 30 seconds

Readiness Probe:
- URL: /actuator/health
- Initial Delay: 30 seconds
- Check Every: 10 seconds
```

---

## 8. Deployment Process

### Simple Deployment Steps

```
1. Run: ./scripts/deploy-k8s.sh
2. Script checks prerequisites
3. Creates k3d cluster
4. Builds application JAR
5. Creates Docker image
6. Imports image to cluster
7. Creates namespace
8. Deploys database
9. Deploys application
10. Verifies all pods running
```

### Verification Commands

```
Check pods: kubectl get pods -n themepark-app
Check services: kubectl get services -n themepark-app
Test API: curl http://localhost:8090/ride
Health check: curl http://localhost:8090/actuator/health
```

---

## 9. Configuration

### Environment Variables

```
Production:
- APP_ENV=production
- DB_HOST=mariadb
- DB_PORT=3306
- DB_NAME=themepark
- DB_USER=themeuser
- DB_PASS=[from secret]

Testing:
- APP_ENV=test
- Database=H2 (in-memory)
```

### Kubernetes Resources

```
ConfigMap (rideops-config):
- db_host=mariadb
- db_port=3306
- db_name=themepark

Secret (rideops-secret):
- db_user=themeuser
- db_pass=themedb123
```

---

## 10. Monitoring

### Available Endpoints

```
Health: /actuator/health
Metrics: /actuator/metrics
Info: /actuator/info
All: /actuator
```

### Key Metrics

```
Application Metrics:
- HTTP request count
- Response times
- Error rates

System Metrics:
- JVM memory usage
- Thread count
- Database connections

Business Metrics:
- Total rides created
- API usage patterns
```

---

This simplified system design focuses on clarity and basic understanding without complex visual elements or color coding.

---

This simplified system design focuses on clarity and basic understanding without complex visual elements or color coding.

## Related Documentation

- [Architecture Guide](ARCHITECTURE.md) - Complete architecture documentation
- [Quick Start Guide](QUICKSTART.md) - Get running in 2 commands
- [Scripts Documentation](scripts/README.md) - Automation guide
- [Commands Reference](commands.txt) - Available commands

---

## 📚 Related Documentation

- [Complete Architecture Guide](ARCHITECTURE.md) - Comprehensive architecture documentation
- [Quick Start Guide](QUICKSTART.md) - Get running in 2 commands
- [Scripts Documentation](scripts/README.md) - Detailed automation guide
- [Commands Reference](commands.txt) - All available commands

This system design provides the visual foundation for understanding how the Theme Park Ride Operations system works from request to response! 🎢✨