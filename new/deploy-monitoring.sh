#!/bin/bash

# Deploy Monitoring Stack (Prometheus and Grafana) to Kubernetes
# This script deploys Prometheus and Grafana for monitoring the ride-ops application

set -e

echo "=========================================="
echo "Deploying Monitoring Stack to Kubernetes"
echo "=========================================="

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
K8S_DIR="${SCRIPT_DIR}/../new/k8s"

# Create monitoring namespace
echo "Creating monitoring namespace..."
kubectl apply -f ${K8S_DIR}/monitoring/namespace.yaml

# Deploy Prometheus
echo "Deploying Prometheus..."
kubectl apply -f ${K8S_DIR}/prometheus/rbac.yaml
kubectl apply -f ${K8S_DIR}/prometheus/configmap.yaml
kubectl apply -f ${K8S_DIR}/prometheus/deployment.yaml
kubectl apply -f ${K8S_DIR}/prometheus/service.yaml

# Deploy Grafana
echo "Deploying Grafana..."
kubectl apply -f ${K8S_DIR}/grafana/configmap.yaml
kubectl apply -f ${K8S_DIR}/grafana/dashboard-provider.yaml

# Create dashboard ConfigMap from JSON files
echo "Creating Grafana dashboards ConfigMap..."
kubectl create configmap grafana-dashboards \
  --from-file=ride-ops-dashboard.json=${K8S_DIR}/grafana/ride-ops-dashboard.json \
  --from-file=four-golden-signals-dashboard.json=${K8S_DIR}/grafana/four-golden-signals-dashboard.json \
  --namespace=monitoring \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f ${K8S_DIR}/grafana/deployment.yaml
kubectl apply -f ${K8S_DIR}/grafana/service.yaml

# Wait for deployments to be ready
echo "Waiting for Prometheus to be ready..."
kubectl rollout status deployment/prometheus -n monitoring --timeout=120s

echo "Waiting for Grafana to be ready..."
kubectl rollout status deployment/grafana -n monitoring --timeout=120s

echo ""
echo "=========================================="
echo "Monitoring Stack Deployed Successfully!"
echo "=========================================="
echo ""
echo "Access URLs:"
echo "  Prometheus: http://localhost:30090"
echo "  Grafana:    http://localhost:30300"
echo ""
echo "Grafana Credentials:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
echo "To access from your local machine:"
echo "  For Multipass VM:"
echo "    export VM_IP=\$(multipass info park | grep IPv4 | awk '{print \$2}')"
echo "    echo \"Prometheus: http://\$VM_IP:30090\""
echo "    echo \"Grafana: http://\$VM_IP:30300\""
echo ""
echo "Check status:"
echo "  kubectl get pods -n monitoring"
echo "  kubectl get svc -n monitoring"
echo ""
