# Architecture Overview of Theme Park Ride Ops

## Introduction
The Theme Park Ride Ops project is designed as a microservices architecture that manages various aspects of a theme park's ride operations. The system is built using Spring Boot and is deployed on a Kubernetes cluster, ensuring scalability, resilience, and ease of management.

## Architecture Components

### 1. Infrastructure Layer
- **Ubuntu Host**: The application runs on an Ubuntu server, providing a stable environment for the Kubernetes cluster.
- **Terraform**: Used for provisioning the Kubernetes infrastructure, including networking, security groups, and persistent storage.
- **Ansible**: Automates the installation of necessary tools (Docker, kubectl, Helm, ArgoCD) and configures the Kubernetes cluster.

### 2. Kubernetes Layer
- **Kubernetes (k3s or kubeadm)**: The core orchestration platform that manages the deployment, scaling, and operation of the microservices.
- **Namespaces**: All services are deployed under the `themepark-app` namespace to isolate resources and manage permissions effectively.

### 3. Application Layer
- **Spring Boot Microservices**: The application consists of three main services, each running in its own container. These services are designed to handle different functionalities of the theme park operations.
- **MariaDB**: A StatefulSet is used to manage the database, ensuring data persistence and high availability.
- **Traefik**: Acts as the ingress controller, routing external traffic to the appropriate services based on defined rules.

### 4. CI/CD Pipeline
- **GitHub Actions**: Automates the build, test, and deployment processes. It builds Docker images, pushes them to a container registry, and updates Helm charts with new image tags.
- **ArgoCD**: Implements GitOps principles by continuously monitoring the Git repository for changes and synchronizing the Kubernetes cluster with the desired state defined in the Helm charts.

### 5. Monitoring and Observability
- **Prometheus**: Monitors the health and performance of the microservices by scraping metrics exposed by the Spring Boot applications.
- **Grafana**: Provides visualization of the metrics collected by Prometheus, allowing for real-time monitoring and alerting.

## Deployment Flow
1. **Infrastructure Provisioning**: Terraform provisions the Kubernetes cluster and necessary resources.
2. **Configuration Management**: Ansible installs required software and configures the environment.
3. **Application Deployment**: Docker images are built and pushed to the registry. Helm charts are updated with the new image tags and deployed to the Kubernetes cluster.
4. **Continuous Monitoring**: Prometheus scrapes metrics, and Grafana visualizes them for operational insights.

## Conclusion
The Theme Park Ride Ops architecture is designed to be scalable, maintainable, and resilient. By leveraging modern technologies such as Kubernetes, Docker, and GitOps practices, the system can efficiently manage the complexities of theme park ride operations while ensuring high availability and performance.