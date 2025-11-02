# 🚀 Quick Start Guide

## For New Developers - Get Running in 2 Commands

After cloning this repository, you can have the entire theme park ride operations API running in Kubernetes with just these commands:

### 1. Deploy Everything to Kubernetes
```bash
./scripts/deploy-k8s.sh
```

This single command will:
- ✅ Check and install prerequisites (k3d, kubectl)
- ✅ Create a k3d Kubernetes cluster
- ✅ Build the Spring Boot application
- ✅ Create Docker images and import to cluster
- ✅ Deploy MariaDB with persistent storage
- ✅ Deploy the ride-ops application (3 replicas)
- ✅ Set up ingress and load balancing
- ✅ Verify all pods are running and healthy

### 2. Test All API Endpoints
```bash
./scripts/test-api.sh
```

This will:
- ✅ Set up port-forwarding automatically
- ✅ Test all REST endpoints
- ✅ Show colored output for easy reading
- ✅ Create sample ride data
- ✅ Verify health checks

## 🎯 Available API Endpoints

Once deployed, you can access:

- **GET** `/ride` - List all rides
- **GET** `/ride/{id}` - Get specific ride
- **POST** `/ride` - Create new ride
- **GET** `/actuator/health` - Health check
- **GET** `/actuator` - All monitoring endpoints

## 🧹 Cleanup

When done testing:
```bash
./scripts/cleanup.sh
```

## 📚 More Information

- Check `commands.txt` for all available commands
- Read `scripts/README.md` for detailed documentation
- See main `README.md` for comprehensive project information

## 🔧 Manual Testing

```bash
# Create a new ride
curl -X POST http://localhost:8090/ride \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Your Ride Name",
    "description": "Amazing ride description",
    "thrillFactor": 5,
    "vomitFactor": 2
  }'

# Get all rides
curl http://localhost:8090/ride

# Check application health
curl http://localhost:8090/actuator/health
```

---

**That's it!** Your theme park ride operations API is now running in a production-like Kubernetes environment! 🎢