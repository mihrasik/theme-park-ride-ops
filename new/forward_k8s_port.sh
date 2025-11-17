#!/bin/bash
set -e
ss -ltnp 'sport = :8090'
pkill -f "kubectl port-forward .*8090"      # or kill the PID from ss
kubectl port-forward --address 0.0.0.0 service/ride-ops 8090:8080 -n themepark-app