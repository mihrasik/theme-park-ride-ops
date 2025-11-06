# Theme Park Ride Ops Runbook

## Overview
This runbook provides operational procedures and troubleshooting steps for the Theme Park Ride Ops project. It serves as a guide for maintaining the application and resolving common issues.

## Deployment Procedures

### Initial Setup
1. **Clone the Repository**
   ```bash
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. **Configure Environment Variables**
   - Update the `.env` file with the necessary configuration values.

3. **Provision Infrastructure**
   - Run the Ansible playbook to set up the environment:
   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
   ```

4. **Deploy Applications**
   - Use Helm to deploy the applications:
   ```bash
   helm install themepark-app helm/values.yaml
   ```

### Updating Services
1. **Make Code Changes**
   - Update the application code as needed.

2. **Build Docker Images**
   - Build the Docker images for the services:
   ```bash
   docker-compose build
   ```

3. **Push Docker Images**
   - Push the images to the specified Docker registry:
   ```bash
   docker push <your-registry-url>
   ```

4. **Update Helm Chart Values**
   - Update the `values.yaml` file with new image tags.

5. **Sync ArgoCD**
   - Commit changes to the repository to trigger ArgoCD sync.

## Troubleshooting

### Common Issues

#### Application Fails to Start
- Check the logs of the failing service:
```bash
kubectl logs <pod-name> -n themepark-app
```
- Ensure that the database is running and accessible.

#### Database Connection Issues
- Verify the database credentials in the `.env` file.
- Check the MariaDB pod status:
```bash
kubectl get pods -n themepark-app
```

#### Ingress Not Working
- Ensure that the Traefik ingress controller is running:
```bash
kubectl get pods -n kube-system
```
- Check the ingress resource configuration:
```bash
kubectl describe ingress traefik-ingress -n themepark-app
```

## Backup and Restore Procedures

### Database Backup
- Run the backup script:
```bash
./scripts/backup_db.sh
```

### Database Restore
- Restore the database from a backup file:
```bash
# Command to restore the database
```

## Monitoring
- Access Grafana at `http://<your-grafana-url>:3000` to view application metrics.
- Access Prometheus at `http://<your-prometheus-url>:9090` for monitoring data.

## Conclusion
This runbook should be updated regularly to reflect any changes in procedures or configurations. For any issues not covered in this document, consult the project documentation or reach out to the development team.