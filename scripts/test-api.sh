#!/bin/bash

# Theme Park Ride Ops - API Testing Script
# Tests all the API endpoints to verify the deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

NAMESPACE="themepark-app"
SERVICE_NAME="ride-ops"
PORT="8090"

echo -e "${BLUE}🧪 Theme Park Ride Ops - API Testing${NC}"
echo "======================================="

# Function to check if port-forward is running
check_port_forward() {
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null; then
        echo -e "${GREEN}✅ Port-forward is already running on port $PORT${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  Port-forward not detected. Starting port-forward...${NC}"
        kubectl port-forward service/$SERVICE_NAME $PORT:8080 -n $NAMESPACE &
        PORT_FORWARD_PID=$!
        sleep 5
        return 1
    fi
}

# Function to test API endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local description=$3
    local data=$4
    
    echo -e "${BLUE}🔍 Testing: $description${NC}"
    echo -e "${YELLOW}   $method http://localhost:$PORT$endpoint${NC}"
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "HTTP_STATUS:%{http_code}" -X $method \
            -H "Content-Type: application/json" \
            -d "$data" \
            http://localhost:$PORT$endpoint)
    else
        response=$(curl -s -w "HTTP_STATUS:%{http_code}" -X $method \
            http://localhost:$PORT$endpoint)
    fi
    
    # Extract HTTP status code
    http_status=$(echo $response | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
    # Extract response body
    response_body=$(echo $response | sed 's/HTTP_STATUS:[0-9]*$//')
    
    if [[ $http_status -ge 200 && $http_status -lt 300 ]]; then
        echo -e "${GREEN}   ✅ SUCCESS (HTTP $http_status)${NC}"
        if [ -n "$response_body" ]; then
            echo "$response_body" | jq . 2>/dev/null || echo "$response_body"
        fi
    else
        echo -e "${RED}   ❌ FAILED (HTTP $http_status)${NC}"
        echo "$response_body"
    fi
    echo ""
}

# Check if kubectl is available
if ! command -v kubectl >/dev/null 2>&1; then
    echo -e "${RED}❌ kubectl is not installed${NC}"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info >/dev/null 2>&1; then
    echo -e "${RED}❌ Cannot connect to Kubernetes cluster${NC}"
    echo -e "${YELLOW}💡 Make sure your cluster is running: k3d cluster start themepark${NC}"
    exit 1
fi

# Check if namespace exists
if ! kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
    echo -e "${RED}❌ Namespace $NAMESPACE does not exist${NC}"
    echo -e "${YELLOW}💡 Run the deployment script first: ./scripts/deploy-k8s.sh${NC}"
    exit 1
fi

# Check if service exists
if ! kubectl get service $SERVICE_NAME -n $NAMESPACE >/dev/null 2>&1; then
    echo -e "${RED}❌ Service $SERVICE_NAME does not exist in namespace $NAMESPACE${NC}"
    echo -e "${YELLOW}💡 Run the deployment script first: ./scripts/deploy-k8s.sh${NC}"
    exit 1
fi

# Check pod status
echo -e "${BLUE}🔍 Checking pod status...${NC}"
kubectl get pods -n $NAMESPACE -l app=$SERVICE_NAME

if ! kubectl get pods -n $NAMESPACE -l app=$SERVICE_NAME | grep -q "Running"; then
    echo -e "${RED}❌ No running pods found for $SERVICE_NAME${NC}"
    echo -e "${YELLOW}💡 Wait for pods to be ready or check logs: kubectl logs -f deployment/$SERVICE_NAME -n $NAMESPACE${NC}"
    exit 1
fi

# Setup port forwarding
CLEANUP_PORT_FORWARD=false
if ! check_port_forward; then
    CLEANUP_PORT_FORWARD=true
fi

# Wait a moment for port-forward to establish
sleep 3

# Cleanup function
cleanup() {
    if [ "$CLEANUP_PORT_FORWARD" = true ] && [ -n "$PORT_FORWARD_PID" ]; then
        echo -e "${YELLOW}🧹 Cleaning up port-forward...${NC}"
        kill $PORT_FORWARD_PID 2>/dev/null || true
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Test health endpoint
test_endpoint "GET" "/actuator/health" "Health Check"

# Test get all rides
test_endpoint "GET" "/ride" "Get All Rides"

# Test get specific ride
test_endpoint "GET" "/ride/1" "Get Specific Ride (ID: 1)"

# Test create new ride
test_endpoint "POST" "/ride" "Create New Ride" '{
    "name": "Space Mountain",
    "description": "Indoor space-themed roller coaster",
    "thrillFactor": 4,
    "vomitFactor": 2
}'

# Test get all rides again to see the new ride
test_endpoint "GET" "/ride" "Get All Rides (After Creation)"

# Test invalid ride ID
test_endpoint "GET" "/ride/999" "Get Non-existent Ride (ID: 999)"

echo -e "${GREEN}🎉 API Testing Completed!${NC}"
echo ""
echo -e "${BLUE}📋 Available Endpoints:${NC}"
echo -e "   GET    http://localhost:$PORT/ride              - Get all rides"
echo -e "   GET    http://localhost:$PORT/ride/{id}         - Get specific ride"
echo -e "   POST   http://localhost:$PORT/ride              - Create new ride"
echo -e "   GET    http://localhost:$PORT/actuator/health   - Health check"
echo -e "   GET    http://localhost:$PORT/actuator          - All actuator endpoints"
echo ""
echo -e "${YELLOW}💡 To manually test:${NC}"
echo -e "   kubectl port-forward service/$SERVICE_NAME $PORT:8080 -n $NAMESPACE"
echo -e "   curl http://localhost:$PORT/ride"