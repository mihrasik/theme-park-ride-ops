# Theme Park Ride Ops

## Overview
The Theme Park Ride Ops project is a Spring Boot microservices system designed to manage theme park ride operations. This project is built using a Kubernetes-based stack on Ubuntu, leveraging Docker, Helm, ArgoCD, Terraform, Ansible, and GitHub Actions for deployment and management.

## Architecture
The architecture consists of multiple components:
- **Microservices**: Three Spring Boot applications that handle different aspects of ride operations.
- **Database**: A MariaDB instance for persistent data storage.
- **Load Balancer**: Traefik is used as an ingress controller to manage external traffic.
- **Monitoring**: Prometheus and Grafana are integrated for monitoring application performance and health.

## Getting Started

### Prerequisites
- Ubuntu Linux
- Docker
- Kubernetes (k3s or kubeadm)
- Helm
- Terraform
- Ansible
- GitHub Actions

### Environment Configuration
All environment variables are stored in the `.env` file. This includes database credentials, registry URLs, and application settings. Ensure to configure this file before running the application.

### Deployment
1. **Infrastructure Provisioning**: Use Terraform to provision the Kubernetes infrastructure.
2. **Application Deployment**: Use Ansible to install necessary tools and configure the Kubernetes cluster.
3. **Service Packaging**: Build Docker images for each service and deploy them using Helm charts.
4. **Continuous Integration/Deployment**: GitHub Actions automates the build, push, and deployment process.

### Monitoring
Prometheus is configured to scrape metrics from the Spring Boot applications, and Grafana is used to visualize these metrics. Alerts can be set up using Alertmanager for critical issues.

## Scripts
- `backup_db.sh`: Script to back up the MariaDB database.
- `log_cleanup.sh`: Script to clean up old application logs.

## Documentation
- **Architecture**: See `docs/architecture.md` for detailed architecture documentation.
- **Runbook**: Refer to `docs/runbook.md` for operational procedures and troubleshooting guidelines.

## Contributing
Contributions are welcome! Please follow the standard Git workflow for submitting changes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.