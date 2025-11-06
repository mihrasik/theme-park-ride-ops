# README.md

# Theme Park Ride Ops

## Overview

The Theme Park Ride Ops project is a Spring Boot microservices application designed to manage ride operations in a theme park. The architecture is built on a Kubernetes-based stack, utilizing Docker for containerization, Helm for package management, and ArgoCD for GitOps deployment. The application is designed to be production-ready and is provisioned on an Ubuntu environment.

## Architecture

The project consists of the following key components:

- **Ride Ops API**: A Spring Boot application that serves as the backend for managing ride operations.
- **Ride Ops UI**: A web application that provides a user interface for interacting with the ride operations.
- **MariaDB**: A relational database used for storing application data.
- **Nginx**: Acts as a load balancer and ingress controller for routing traffic to the appropriate services.
- **Monitoring**: Integrated Prometheus and Grafana for monitoring application performance and health.

## Technologies Used

- **Spring Boot**: For building the microservices.
- **Docker**: For containerizing the applications.
- **Kubernetes**: For orchestrating the deployment of services.
- **Helm**: For managing Kubernetes applications.
- **ArgoCD**: For continuous deployment using GitOps principles.
- **Terraform**: For provisioning infrastructure.
- **Ansible**: For configuration management.
- **GitHub Actions**: For CI/CD automation.

## Getting Started

### Prerequisites

- Ubuntu server or local machine
- Docker
- Kubernetes (k3s or kubeadm)
- Helm
- Terraform
- Ansible
- GitHub account

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. Configure the `.env` file with your environment variables.

3. Use Terraform to provision the Kubernetes infrastructure:
   ```
   cd terraform
   terraform init
   terraform apply
   ```

4. Use Ansible to install required packages and configure the cluster:
   ```
   cd ansible
   ansible-playbook playbook.yml
   ```

5. Deploy the application using Helm:
   ```
   cd helm/umbrella-chart
   helm install themepark-app .
   ```

6. Access the application through the configured Nginx ingress.

## Monitoring

Prometheus and Grafana are included for monitoring the application. Access Grafana at `http://<your-grafana-url>:3000` to visualize metrics.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.