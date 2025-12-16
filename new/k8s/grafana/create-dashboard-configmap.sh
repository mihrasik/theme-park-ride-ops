#!/bin/bash

# Script to create Grafana dashboard ConfigMap from JSON file
# This script is generic and works on any machine

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DASHBOARD_JSON="${SCRIPT_DIR}/ride-ops-dashboard.json"

echo "Creating Grafana dashboard ConfigMap..."

# Create ConfigMap from the JSON file
kubectl create configmap grafana-dashboards \
  --from-file=ride-ops-dashboard.json="${DASHBOARD_JSON}" \
  --namespace=monitoring \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Dashboard ConfigMap created successfully!"
echo ""
echo "The dashboard will be automatically loaded in Grafana."
echo "Access Grafana and check Dashboards > Browse"
