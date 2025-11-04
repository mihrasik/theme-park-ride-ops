#!/bin/bash

# Theme Park Ride Ops - Kubernetes Deployment Script
# This script automates the deployment of the Theme Park Ride Operations application to Kubernetes

set -e

echo "🎢 Theme Park Ride Ops - Kubernetes Deployment Script"
echo "======================================================"

PROJECT_ROOT="$(pwd)/../../"
K8S_DIR="$PROJECT_ROOT/theme-park-ride-ops-5"
NAMESPACE="themepark-app"
APP_RIDE_OPS_ROOT="$K8S_DIR/app/ride-ops"

echo "PROJECT_ROOT $PROJECT_ROOT"
echo "K8S_DIR $K8S_DIR"
echo "APP_RIDE_OPS_ROOT $APP_RIDE_OPS_ROOT" 

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to install kubectl
install_kubectl() {
    print_info "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    print_status "kubectl installed successfully"
}

# Function to install k3d
install_k3d() {
    print_info "Installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    print_status "k3d installed successfully"
}

# Function to create k3d cluster if it doesn't exist
ensure_k3d_cluster() {
    if ! k3d cluster list | grep -q "themepark"; then
        print_info "Creating k3d cluster..."
        k3d cluster create themepark --servers 1 --agents 2
        print_status "k3d cluster created successfully"
    else
        print_info "k3d cluster 'themepark' already exists"
    fi
}

# Check prerequisites
echo
print_info "Checking prerequisites..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    print_warning "kubectl is not installed. Installing now..."
    install_kubectl
fi

# Check if k3d is available
if ! command -v k3d &> /dev/null; then
    print_warning "k3d is not installed. Installing now..."
    install_k3d
fi

# Ensure k3d cluster exists and is running
ensure_k3d_cluster

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    print_error "Cannot connect to Kubernetes cluster. Please check your cluster setup."
    exit 1
fi

print_status "Prerequisites check passed"

# Step 1: Build the application
echo
print_info "Step 1: Building the Spring Boot application..."
cd "$APP_RIDE_OPS_ROOT"
./gradlew clean build -x test
print_status "Application built successfully"

# Step 2: Build Docker image
echo
print_info "Step 2: Building Docker image..."
cd "$APP_RIDE_OPS_ROOT"
docker build -t ride-ops:latest -f Dockerfile.amd64 .
print_status "Docker image built successfully"

# Step 3: Import image to k3d cluster
echo
print_info "Step 3: Importing Docker image to k3d cluster..."
docker save ride-ops:latest -o /tmp/ride-ops.tar
docker cp /tmp/ride-ops.tar k3d-themepark-server-0:/tmp/ride-ops.tar
docker exec k3d-themepark-server-0 ctr images import /tmp/ride-ops.tar
rm -f /tmp/ride-ops.tar
print_status "Image imported to k3d cluster"

# Step 4: Create namespace
echo
print_info "Step 4: Creating Kubernetes namespace..."
cd "$K8S_DIR"
kubectl apply -f k8s/namespace.yaml
print_status "Namespace created/updated"

# Step 5: Create secrets and configmaps
echo
print_info "Step 5: Creating secrets and configmaps..."

# Delete existing secrets if they exist (ignore errors)
kubectl delete secret mariadb-secret -n $NAMESPACE 2>/dev/null || true
kubectl delete secret rideops-secret -n $NAMESPACE 2>/dev/null || true
kubectl delete configmap rideops-config -n $NAMESPACE 2>/dev/null || true

# Create new secrets and configmaps
kubectl create secret generic mariadb-secret \
  --from-literal=mysql-root-password=rootpassword \
  --from-literal=mysql-user-password=themedb123 \
  -n $NAMESPACE

kubectl create secret generic rideops-secret \
  --from-literal=db_user=themeuser \
  --from-literal=db_pass=themedb123 \
  -n $NAMESPACE

kubectl create configmap rideops-config \
  --from-literal=db_host=mariadb \
  --from-literal=db_port=3306 \
  --from-literal=db_name=themepark \
  -n $NAMESPACE

print_status "Secrets and ConfigMaps created"

# Step 6: Deploy MariaDB
echo
print_info "Step 6: Deploying MariaDB..."
kubectl apply -f k8s/mariadb/pvc.yaml
kubectl apply -f k8s/mariadb/deployment.yaml
kubectl apply -f k8s/mariadb/service.yaml

# Wait for MariaDB to be ready
print_info "Waiting for MariaDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mariadb -n $NAMESPACE --timeout=120s
print_status "MariaDB deployed and ready"

# Step 7: Deploy Ride Ops application
echo
print_info "Step 7: Deploying Ride Ops application..."
# kubectl apply -f k8s/ride-ops-deployment.yaml
# kubectl apply -f k8s/ride-ops-service.yaml
kubectl apply -f k8s/ride-ops/deployment.yaml
kubectl apply -f k8s/ride-ops/service.yaml

# Wait for Ride Ops to be ready
print_info "Waiting for Ride Ops application to be ready..."
kubectl wait --for=condition=ready pod -l app=ride-ops -n $NAMESPACE --timeout=120s
print_status "Ride Ops application deployed and ready"

# Step 8: Setup ingress (optional)
echo
print_info "Step 8: Creating ingress (optional)..."
kubectl apply -f k8s/ride-ops-ingress.yaml 2>/dev/null || print_warning "Ingress creation failed - may not have ingress controller"

# Step 9: Display deployment status
echo
print_info "Step 9: Deployment summary..."
echo
kubectl get pods -n $NAMESPACE
echo
kubectl get services -n $NAMESPACE
echo

# Step 10: Setup port forwarding and test
echo
print_info "Step 10: Setting up port forwarding for testing..."
echo
print_info "Starting port-forward (this will run in background)..."
kubectl port-forward service/ride-ops 8090:8080 -n $NAMESPACE &
PORT_FORWARD_PID=$!

# Wait a moment for port forwarding to establish
sleep 3

# Test the API
echo
print_info "Testing API endpoints..."
echo

# Test health endpoint
print_info "Testing health endpoint..."
if curl -s http://localhost:8090/actuator/health | grep -q "UP"; then
    print_status "Health endpoint is working"
else
    print_warning "Health endpoint test failed"
fi

# Test rides endpoint
print_info "Testing rides endpoint..."
if curl -s http://localhost:8090/ride | grep -q "Rollercoaster"; then
    print_status "Rides endpoint is working"
    echo "Sample API response:"
    curl -s http://localhost:8090/ride | head -c 200
    echo "..."
else
    print_warning "Rides endpoint test failed"
fi

echo
echo
print_status "🎉 Deployment completed successfully!"
echo
print_info "Your Theme Park Ride Ops application is now running on Kubernetes!"
print_info "API is accessible at: http://localhost:8090"
print_info "Available endpoints:"
echo "  - GET  http://localhost:8090/ride           - List all rides"
echo "  - GET  http://localhost:8090/ride/{id}      - Get specific ride"
echo "  - POST http://localhost:8090/ride           - Create new ride"
echo "  - GET  http://localhost:8090/actuator/health - Health check"
echo
print_info "To view pod logs: kubectl logs -f deployment/ride-ops -n $NAMESPACE"
print_info "To scale the application: kubectl scale deployment ride-ops --replicas=5 -n $NAMESPACE"
print_info "To stop port forwarding: kill $PORT_FORWARD_PID"
echo

# Keep port forwarding running
print_info "Port forwarding is running in background (PID: $PORT_FORWARD_PID)"
print_info "Press Ctrl+C to stop the script and port forwarding"
wait $PORT_FORWARD_PID