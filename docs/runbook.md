# Operational Runbook for Theme Park Ride Ops

## Introduction
This runbook provides operational procedures and guidelines for managing the Theme Park Ride Ops application. It covers deployment, monitoring, troubleshooting, and maintenance tasks.

## Deployment Procedures


cd /home/ubuntu/theme-park-ride-ops
upper_folders/scripts/install_ansible.sh


cd /home/ubuntu/theme-park-ride-ops/upper_folders/scripts/

ansible-playbook ansible_playbook_devops_tools.yml

### Prerequisites
- Ensure that the `.env` file is configured with the correct environment variables.
- Verify that the Kubernetes cluster is up and running.

### Deploying the Application
1. **Build Docker Images**
   - Navigate to the application directory.
   - Run the following command to build the Docker images:
     ```
     docker-compose build
     ```

2. **Deploy to Kubernetes**
   - Use Helm to deploy the application:
     ```
     helm upgrade --install themepark-app ./helm/umbrella-chart
     ```

3. **Verify Deployment**
   - Check the status of the pods:
     ```
     kubectl get pods -n themepark-app
     ```

## Monitoring

### Accessing Monitoring Tools
- **Prometheus**: Access Prometheus at `http://<prometheus-ip>:9090`.
- **Grafana**: Access Grafana at `http://<grafana-ip>:3000`.

### Setting Up Alerts
- Configure alerts in Prometheus and set up Alertmanager for notifications.

## Troubleshooting

### Common Issues
- **Pod CrashLoopBackOff**
  - Check the logs of the pod:
    ```
    kubectl logs <pod-name> -n themepark-app
    ```
  - Investigate any configuration issues or missing environment variables.

- **Database Connection Issues**
  - Ensure that the MariaDB service is running:
    ```
    kubectl get svc -n themepark-app
    ```
  - Verify the database credentials in the `.env` file.

## Maintenance

### Backing Up the Database
- Run the backup script:
  ```
  ./scripts/backup_db.sh
  ```

### Cleaning Up Logs
- Execute the log cleanup script:
  ```
  ./scripts/log_cleanup.sh
  ```

## Conclusion
This runbook serves as a guide for operational tasks related to the Theme Park Ride Ops application. For further assistance, refer to the documentation in the `/docs` directory or contact the development team.