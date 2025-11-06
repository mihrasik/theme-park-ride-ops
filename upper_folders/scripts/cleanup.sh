#!/bin/bash

# Theme Park Ride Ops - Cleanup Script
# Removes all Kubernetes resources and optionally the cluster

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CLUSTER_NAME="themepark"
NAMESPACE="themepark-app"

echo -e "${BLUE}🧹 Theme Park Ride Ops - Cleanup${NC}"
echo "=================================="

# Function to confirm action
confirm() {
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

echo -e "${YELLOW}This will remove all Theme Park Ride Ops resources from Kubernetes.${NC}"
if confirm; then
    echo -e "${BLUE}🗑️  Removing Kubernetes resources...${NC}"
    
    # Delete namespace (this will delete everything in it)
    if kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
        echo -e "${YELLOW}Deleting namespace: $NAMESPACE${NC}"
        kubectl delete namespace $NAMESPACE
        echo -e "${GREEN}✅ Namespace deleted${NC}"
    else
        echo -e "${YELLOW}⚠️  Namespace $NAMESPACE does not exist${NC}"
    fi
    
    # Kill any port-forward processes
    echo -e "${YELLOW}🔌 Stopping any port-forward processes...${NC}"
    pkill -f "kubectl port-forward.*ride-ops" || true
    
    echo -e "${GREEN}✅ Kubernetes resources cleaned up${NC}"
else
    echo -e "${YELLOW}❌ Cleanup cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}Do you want to delete the entire k3d cluster '$CLUSTER_NAME'?${NC}"
echo -e "${RED}⚠️  This will remove the entire cluster and all its data!${NC}"
if confirm; then
    if command -v k3d >/dev/null 2>&1; then
        if k3d cluster list | grep -q $CLUSTER_NAME; then
            echo -e "${BLUE}🗑️  Deleting k3d cluster: $CLUSTER_NAME${NC}"
            k3d cluster delete $CLUSTER_NAME
            echo -e "${GREEN}✅ Cluster deleted${NC}"
        else
            echo -e "${YELLOW}⚠️  Cluster $CLUSTER_NAME does not exist${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  k3d not found, cannot delete cluster${NC}"
    fi
else
    echo -e "${YELLOW}❌ Cluster deletion cancelled${NC}"
    echo -e "${BLUE}💡 Cluster '$CLUSTER_NAME' is still running${NC}"
fi

echo -e "${GREEN}🎉 Cleanup completed!${NC}"
echo ""
echo -e "${BLUE}📝 To redeploy:${NC}"
echo -e "   ./scripts/deploy-k8s.sh"