# Runbook for Theme Park Ride Ops

## Overview
This runbook provides operational procedures for deploying, managing, and troubleshooting the Theme Park Ride Ops application. It serves as a guide for developers and operators to ensure smooth operation and maintenance of the system.

## Deployment Procedures

### Prerequisites
- Ensure that the Ubuntu host is set up and accessible.
- Install necessary tools: Docker, kubectl, Helm, Terraform, Ansible, and ArgoCD.
- Configure the `.env` file with the appropriate environment variables.

### Step 1: Provision Infrastructure
1. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

### Step 2: Configure Kubernetes
1. Navigate to the Ansible directory:
   ```bash
   cd ansible
   ```
2. Run the Ansible playbook to configure the Kubernetes cluster:
   ```bash
   ansible-playbook playbook.yml -i inventory.ini
   ```

### Step 3: Deploy Applications
1. Navigate to the Helm directory:
   ```bash
   cd helm
   ```
2. Install the Helm chart:
   ```bash
   helm install themepark-app . --values values.yaml
   ```

### Step 4: Monitor Deployments
- Access the ArgoCD UI to monitor the deployment status and sync applications.
- Use Prometheus and Grafana for monitoring application metrics.

## Troubleshooting

### Common Issues
- **Deployment Fails**: Check the logs of the failed pods using:
  ```bash
  kubectl logs <pod-name>
  ```
- **Database Connection Issues**: Verify the database credentials in the `.env` file and ensure the MariaDB service is running.

### Rollback Procedures
- To rollback a Helm release:
  ```bash
  helm rollback themepark-app <revision>
  ```

## Backup and Restore
- To backup the MariaDB database, run the backup script:
  ```bash
  ./scripts/backup_db.sh
  ```
- For restoring the database, follow the instructions in the backup script.

## Maintenance
- Regularly check the health of the application using Grafana dashboards.
- Clean up old logs using the log cleanup script:
  ```bash
  ./scripts/log_cleanup.sh
  ```

## Conclusion
This runbook serves as a comprehensive guide for managing the Theme Park Ride Ops application. For further assistance, refer to the documentation in the `/docs` directory or contact the development team.