# Architecture Overview of Theme Park Ride Ops

## 1. Introduction
The Theme Park Ride Ops project is designed as a microservices architecture using Spring Boot, deployed on a Kubernetes cluster. This document outlines the architecture components, their interactions, and the technologies used in the project.

## 2. Architecture Components

### 2.1 Infrastructure Layer
- **Ubuntu Host**: The application runs on an Ubuntu server, providing a stable environment for the Kubernetes cluster.
- **Terraform**: Used for provisioning the Kubernetes infrastructure, managing resources such as networking, volumes, and security groups.
- **Ansible**: Automates the installation and configuration of necessary tools like Docker, kubectl, Helm, and ArgoCD.

### 2.2 Kubernetes Layer
- **Kubernetes (k3s/kubeadm)**: Manages the deployment of microservices, ensuring scalability and reliability.
- **Namespaces**: The application runs in the `themepark-app` namespace, isolating it from other applications.

### 2.3 Application Layer
- **Spring Boot Microservices**: The core application logic is encapsulated in Spring Boot services, with a default of three replicas for high availability.
- **MariaDB**: A StatefulSet deployment for the database, ensuring data persistence through Persistent Volume Claims (PVCs).
- **Traefik**: Acts as the ingress controller, managing external access to the services.

### 2.4 CI/CD and GitOps
- **GitHub Actions**: Automates the build, test, and deployment processes, integrating with Docker and Helm for continuous delivery.
- **ArgoCD**: Implements GitOps principles, monitoring the Git repository for changes and synchronizing the Kubernetes cluster with the desired state defined in Helm charts.

### 2.5 Monitoring
- **Prometheus**: Monitors application metrics by scraping endpoints exposed by Spring Boot.
- **Grafana**: Visualizes metrics collected by Prometheus, providing insights into application performance and health.

## 3. Configuration Management
All configuration settings, including database credentials and service URLs, are managed through a centralized `.env` file. This file is referenced by various components, ensuring consistency and security.

## 4. Conclusion
The Theme Park Ride Ops architecture is designed for scalability, maintainability, and ease of deployment. By leveraging modern technologies and best practices, the project aims to provide a robust solution for managing theme park ride operations.