# Architecture Overview of Theme Park Ride Ops

## Introduction
The Theme Park Ride Ops project is designed as a microservices architecture using Spring Boot, deployed on a Kubernetes cluster. This document outlines the key components, their interactions, and the technologies used in the system.

## Architecture Components

### 1. Infrastructure Layer
- **Ubuntu Host**: The application runs on an Ubuntu server, providing a stable environment for the Kubernetes cluster.
- **Terraform**: Used for provisioning the Kubernetes infrastructure, including networking and security configurations. It reads environment variables from the `.env` file for dynamic configuration.
- **Ansible**: Automates the installation of necessary tools (Docker, kubectl, Helm, ArgoCD) and configures the Kubernetes cluster.

### 2. Kubernetes Layer
- **Kubernetes (k3s or kubeadm)**: Manages the deployment of microservices, ensuring scalability and reliability. The namespace `themepark-app` is used to isolate application resources.
- **Traefik**: Acts as the ingress controller, routing external traffic to the appropriate services based on defined rules.

### 3. Application Layer
- **Spring Boot Microservices**: The application consists of three main services, each running in its own container. These services are packaged using Docker and deployed via Helm charts.
- **MariaDB**: A StatefulSet is used to manage the database, ensuring data persistence through PersistentVolumeClaims (PVCs).

### 4. CI/CD and GitOps
- **GitHub Actions**: Automates the build, test, and deployment processes. It builds Docker images, pushes them to a container registry, and updates Helm charts with new image tags.
- **ArgoCD**: Monitors the Git repository for changes and synchronizes the Kubernetes cluster with the desired state defined in the Helm charts.

### 5. Monitoring and Observability
- **Prometheus**: Monitors the application by scraping metrics from Spring Boot's actuator endpoints.
- **Grafana**: Provides visualization of metrics collected by Prometheus, allowing for real-time monitoring and alerting.

## Conclusion
The Theme Park Ride Ops architecture leverages modern cloud-native technologies to create a scalable, maintainable, and observable system. Each component is designed to work seamlessly together, ensuring a robust deployment of the application in a Kubernetes environment.