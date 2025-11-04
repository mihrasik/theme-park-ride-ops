#!/bin/bash
# chmod +x cleanup_k8s.sh
# ./cleanup_k8s.sh

# Delete all pods in the themepark-app namespace
kubectl delete pods --all -n themepark-app

# Delete all deployments in the themepark-app namespace
kubectl delete deployment --all -n themepark-app

# Delete all PVCs in the themepark-app namespace
kubectl delete pvc --all -n themepark-app