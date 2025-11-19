#!/bin/bash
set -e

echo "Stopping any existing port forwards..."
pkill -f "kubectl port-forward" || true

sleep 2

echo "Starting port forwards..."

# Forward ride-ops application in background
echo "Forwarding ride-ops on port 8090..."
kubectl port-forward --address 0.0.0.0 service/ride-ops 8090:8080 -n themepark-app > /dev/null 2>&1 &
sleep 2

# Forward Prometheus in background
echo "Forwarding Prometheus on port 9090..."
kubectl port-forward --address 0.0.0.0 service/prometheus 9090:9090 -n monitoring > /dev/null 2>&1 &
sleep 2

# Forward Grafana in background
echo "Forwarding Grafana on port 3000..."
kubectl port-forward --address 0.0.0.0 service/grafana 3000:3000 -n monitoring > /dev/null 2>&1 &
sleep 2

echo ""
echo "Port forwards active:"
ss -tlnp | grep -E '(8090|9090|3000)' || echo "Checking ports..."

# Get the VM IP address dynamically
VM_IP=$(ip addr show enp0s1 | grep "inet " | awk '{print $2}' | cut -d/ -f1)

echo ""
echo "Access from your Mac:"
echo "  Application: http://${VM_IP}:8090"
echo "  Prometheus:  http://${VM_IP}:9090"
echo "  Grafana:     http://${VM_IP}:3000"
echo ""
echo "To stop: pkill -f 'kubectl port-forward'"