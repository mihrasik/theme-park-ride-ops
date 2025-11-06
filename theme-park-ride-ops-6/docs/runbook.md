# This file serves as a runbook for operational procedures.

# Runbook for Theme Park Ride Ops

## Overview
This runbook provides operational procedures for managing the Theme Park Ride Ops application. It includes instructions for deployment, monitoring, backup, and troubleshooting.

## Deployment Procedures

### Prerequisites
- Ensure that the Kubernetes cluster is up and running.
- Verify that Docker, Helm, and ArgoCD are installed and configured.

### Deploying the Application
1. **Clone the Repository**
   ```bash
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. **Set Up Environment Variables**
   Ensure that the `.env` file is configured with the correct values for your environment.

3. **Deploy with Helm**
   ```bash
   helm install themepark-app helm/umbrella-chart
   ```

4. **Sync ArgoCD**
   If using ArgoCD, ensure that the application is synced:
   ```bash
   argocd app sync themepark-app
   ```

## Monitoring Procedures

### Accessing Grafana
- Open your browser and navigate to `http://<GRAFANA_IP>:<GRAFANA_PORT>`.
- Default credentials are usually `admin/admin`.

### Accessing Prometheus
- Open your browser and navigate to `http://<PROMETHEUS_IP>:<PROMETHEUS_PORT>`.

## Backup Procedures

### Backing Up the Database
1. **Run the Backup Script**
   ```bash
   ./scripts/backup_db.sh
   ```

2. **Verify Backup**
   Check the backup location to ensure the backup file is created.

## Troubleshooting

### Common Issues
- **Application Not Starting**
  - Check the logs of the application pods:
    ```bash
    kubectl logs -l app=ride-ops-api -n themepark-app
    ```

- **Database Connection Issues**
  - Verify the database service is running:
    ```bash
    kubectl get pods -n themepark-app
    ```

- **Ingress Not Working**
  - Check the ingress configuration and ensure the Nginx controller is running.

## Contact Information
For further assistance, please contact the DevOps team at devops@themepark.com.