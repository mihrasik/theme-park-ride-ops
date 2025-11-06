# Theme Park Ride Ops

## Overview

The Theme Park Ride Ops project is a microservices-based application built using Spring Boot and Java 17. It consists of three main applications, a MariaDB database, and a load balancer, all orchestrated using Kubernetes. The project aims to provide a robust and scalable infrastructure for managing theme park ride operations.

## Architecture

The architecture of the Theme Park Ride Ops project is documented in `docs/architecture.md`. This document includes:

- An overview of the system architecture
- API endpoints for each microservice
- CI/CD flow and deployment strategies
- Scrum/Trello guidelines for project management
- Branching strategy for version control

## Getting Started

### Prerequisites

- Java 17
- Docker
- Kubernetes (k3s or kubeadm)
- Helm
- Terraform
- Ansible

### Local Development Setup

1. **Provision Local Kubernetes Cluster**: Use Terraform to provision a local Kubernetes cluster with Multipass.
   ```bash
   cd terraform/multipass
   terraform init
   terraform apply
   ```

2. **Install Dependencies**: Use Ansible to install Docker, Kubernetes, Helm, and ArgoCD on the provisioned VMs.
   ```bash
   ansible-playbook -i inventory playbook.yml
   ```

3. **Build and Push Docker Images**: Build the Spring Boot applications and push the Docker images to a container registry.
   ```bash
   ./gradlew bootJar
   docker build -t <your-docker-repo>/app1 ./src/app1
   docker push <your-docker-repo>/app1
   ```

4. **Deploy to Kubernetes**: Use Helm to deploy the applications to the Kubernetes cluster.
   ```bash
   helm upgrade --install app1 helm/app1
   helm upgrade --install app2 helm/app2
   helm upgrade --install app3 helm/app3
   ```

5. **Configure ArgoCD**: Apply the ArgoCD application configuration to manage deployments.
   ```bash
   kubectl apply -f argocd/application.yaml
   ```

6. **Access the Applications**: Check the status of the pods and access the applications.
   ```bash
   kubectl get pods -n themepark
   ```

## CI/CD

The CI/CD pipeline is configured using GitHub Actions. The workflow includes:

- Building and testing the Spring Boot applications
- Building and pushing Docker images
- Updating Helm chart values
- Syncing with ArgoCD for automated deployments

## Monitoring

Monitoring is set up using Prometheus and Grafana. Metrics are scraped from the Spring Boot applications using the `/actuator/prometheus` endpoint.

## Contribution

Contributions are welcome! Please follow the branching strategy and guidelines outlined in the architecture document.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.