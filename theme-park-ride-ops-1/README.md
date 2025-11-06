# Theme Park Ride Ops

Welcome to the Theme Park Ride Ops project! This project is designed to manage and operate theme park rides using a microservices architecture built with Spring Boot and Java 17. The system is containerized using Docker and orchestrated with Kubernetes, providing a scalable and efficient solution for ride operations.

## Project Structure

The project consists of the following main components:

- **Microservices**: Three separate Spring Boot applications (`app1`, `app2`, `app3`) that handle different aspects of ride operations.
- **Database**: A MariaDB instance for persistent data storage.
- **Load Balancer**: An NGINX-based load balancer to distribute traffic among the microservices.
- **Infrastructure as Code**: Terraform and Ansible scripts for provisioning and configuring the infrastructure.
- **CI/CD Pipeline**: GitHub Actions for continuous integration and deployment.

## Architecture Overview

For a detailed architecture overview, including API endpoints and CI/CD flow, please refer to the [architecture documentation](docs/architecture.md).

## Getting Started

### Prerequisites

- Docker
- Kubernetes (k3s or kubeadm)
- Terraform
- Ansible
- Helm

### Local Development Setup

1. **Provision the Local Kubernetes Cluster**:
   Navigate to the `terraform/local_prov` directory and run:
   ```
   terraform init
   terraform apply
   ```

2. **Configure the Infrastructure**:
   Use Ansible to install necessary components:
   ```
   ansible-playbook -i inventory playbook.yml
   ```

3. **Build and Deploy Microservices**:
   For each microservice, navigate to its directory and run:
   ```
   ./gradlew bootJar
   docker build -t <your-dockerhub-username>/app1 .
   docker push <your-dockerhub-username>/app1
   ```

4. **Deploy to Kubernetes**:
   Use Helm to deploy the applications:
   ```
   helm upgrade --install app1 helm/app1
   helm upgrade --install app2 helm/app2
   helm upgrade --install app3 helm/app3
   ```

5. **Configure ArgoCD**:
   Apply the ArgoCD application configuration:
   ```
   kubectl apply -f argocd/application.yaml
   ```

6. **Access the Applications**:
   Check the status of the pods:
   ```
   kubectl get pods -n themepark
   ```

### CI/CD Pipeline

The CI/CD pipeline is defined in the `.github/workflows/ci-cd.yml` file. It automates the build, test, and deployment processes for the microservices.

## Contribution Guidelines

To contribute to this project, please follow these guidelines:

- Use feature branches for new features or bug fixes.
- Ensure that your code passes all tests before submitting a pull request.
- Document any new features or changes in the README.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Acknowledgments

Thanks to all contributors and the open-source community for their support and resources.