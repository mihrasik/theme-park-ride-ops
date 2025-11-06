# Theme Park Ride Ops

## Overview
The Theme Park Ride Ops project is a Spring Boot microservices system designed to manage theme park ride operations. It consists of multiple services, including a MariaDB database, all orchestrated using Kubernetes. The project is built with a focus on scalability, maintainability, and ease of deployment.

## Architecture
The architecture is composed of the following key components:
- **Microservices**: Three Spring Boot applications that handle different aspects of ride operations.
- **MariaDB**: A relational database used for storing application data.
- **Traefik**: An ingress controller that manages external access to the services.
- **Kubernetes**: The orchestration platform for deploying and managing the microservices.
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

### Setup Instructions
1. **Clone the Repository**
   ```bash
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. **Configure Environment Variables**
   Update the `.env` file with your configuration settings, including database credentials and registry URL.

3. **Provision Infrastructure**
   Use Terraform to provision the Kubernetes infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

4. **Deploy Applications**
   Use Ansible to install necessary tools and configure the Kubernetes cluster:
   ```bash
   cd ansible
   ansible-playbook playbook.yml
   ```

5. **Build and Deploy Services**
   Use GitHub Actions for CI/CD to build Docker images and deploy them to the Kubernetes cluster.

6. **Access the Application**
   Use the Traefik ingress to access the services via the configured domain.

## Monitoring
Prometheus and Grafana are set up to monitor the application. Access Grafana at `http://<your-grafana-url>:3000` to visualize metrics.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.