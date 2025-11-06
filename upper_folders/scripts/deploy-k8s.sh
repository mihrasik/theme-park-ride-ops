#!/bin/bash

# Theme Park Ride Ops - Kubernetes Deployment Script
# This script automates the complete deployment of the application to Kubernetes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="themepark"
NAMESPACE="themepark-app"
APP_NAME="ride-ops"
DB_NAME="mariadb"

echo -e "${BLUE}🎢 Theme Park Ride Ops - Kubernetes Deployment${NC}"
echo "================================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to wait for pods to be ready
wait_for_pods() {
    local app=$1
    local namespace=$2
    echo -e "${YELLOW}⏳ Waiting for $app pods to be ready...${NC}"
    kubectl wait --for=condition=ready pod -l app=$app -n $namespace --timeout=300s
}

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command_exists kubectl; then
    echo -e "${RED}❌ kubectl is not installed. Please install kubectl first.${NC}"
    echo "Visit: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

if ! command_exists docker; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command_exists k3d; then
    echo -e "${YELLOW}⚠️  k3d not found. Installing k3d...${NC}"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

echo -e "${GREEN}✅ Prerequisites check completed${NC}"

# Check if cluster exists
echo -e "${BLUE}🔧 Setting up Kubernetes cluster...${NC}"

if ! kubectl config get-contexts | grep -q "k3d-$CLUSTER_NAME"; then
    echo -e "${YELLOW}🆕 Creating k3d cluster: $CLUSTER_NAME${NC}"
    k3d cluster create $CLUSTER_NAME --port "8081:80@loadbalancer" --port "8444:443@loadbalancer"
else
    echo -e "${GREEN}✅ Cluster $CLUSTER_NAME already exists${NC}"
    kubectl config use-context k3d-$CLUSTER_NAME
fi

# Verify cluster is running
if ! kubectl cluster-info >/dev/null 2>&1; then
    echo -e "${RED}❌ Cannot connect to Kubernetes cluster${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Cluster is ready${NC}"

# Build application
echo -e "${BLUE}🏗️  Building application...${NC}"
cd "$(dirname "$0")/.."

# Build the JAR file
echo -e "${YELLOW}📦 Building JAR file...${NC}"
./gradlew clean build -x test

# Copy JAR to Docker build context
mkdir -p theme-park-ride-ops-5/app/ride-ops/build/libs
cp build/libs/theme-park-ride-gradle.jar theme-park-ride-ops-5/app/ride-ops/build/libs/

# Build Docker image
echo -e "${YELLOW}🐳 Building Docker image...${NC}"
cd theme-park-ride-ops-5/app/ride-ops
docker build -t $APP_NAME:latest .

# Import image to k3d cluster
echo -e "${YELLOW}📤 Importing image to k3d cluster...${NC}"
k3d image import $APP_NAME:latest -c $CLUSTER_NAME

cd ../../

echo -e "${GREEN}✅ Application built and image imported${NC}"

# Deploy to Kubernetes
echo -e "${BLUE}🚀 Deploying to Kubernetes...${NC}"

# Create namespace
echo -e "${YELLOW}📋 Creating namespace...${NC}"
kubectl apply -f k8s/namespace.yaml

# Create secrets and configmaps
echo -e "${YELLOW}🔐 Creating secrets and configmaps...${NC}"
kubectl create secret generic mariadb-secret \
  --from-literal=mysql-root-password=rootpassword \
  --from-literal=mysql-user-password=themedb123 \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic rideops-secret \
  --from-literal=db_user=themeuser \
  --from-literal=db_pass=themedb123 \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap rideops-config \
  --from-literal=db_host=mariadb \
  --from-literal=db_port=3306 \
  --from-literal=db_name=themepark \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Deploy MariaDB
echo -e "${YELLOW}🗄️  Deploying MariaDB...${NC}"
kubectl apply -f k8s/mariadb/

# Wait for MariaDB to be ready
wait_for_pods "mariadb" $NAMESPACE

# Deploy ride-ops application
echo -e "${YELLOW}🎢 Deploying ride-ops application...${NC}"
kubectl apply -f k8s/ride-ops/

# Wait for application to be ready
wait_for_pods $APP_NAME $NAMESPACE

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"

# Get deployment status
echo -e "${BLUE}📊 Deployment Status:${NC}"
kubectl get pods -n $NAMESPACE
kubectl get services -n $NAMESPACE

echo -e "${GREEN}🎉 Theme Park Ride Ops is now running on Kubernetes!${NC}"
echo -e "${BLUE}📝 To test the API, run: ./scripts/test-api.sh${NC}"
echo -e "${BLUE}🔗 To access the application: kubectl port-forward service/ride-ops 8090:8080 -n $NAMESPACE${NC}"