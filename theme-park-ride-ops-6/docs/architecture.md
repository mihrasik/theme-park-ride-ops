# Architecture Overview of Theme Park Ride Ops

## 1. Introduction
The Theme Park Ride Ops project is designed as a microservices architecture using Spring Boot, deployed on a Kubernetes cluster. The system is built to manage ride operations efficiently, providing a robust and scalable solution for theme parks.

## 2. Architecture Components

### 2.1 Infrastructure
- **Ubuntu Host**: The application runs on an Ubuntu server, providing a stable environment for the Kubernetes cluster.
- **Terraform**: Used for provisioning the Kubernetes infrastructure, including networking and security configurations.
- **Ansible**: Automates the installation and configuration of necessary tools such as Docker, kubectl, Helm, and ArgoCD.

### 2.2 Kubernetes Layer
- **Kubernetes (k3s/kubeadm)**: The core of the architecture, managing the deployment of microservices.
- **Namespaces**: All services are deployed under the `themepark-app` namespace to isolate resources.

### 2.3 Application Packaging
- **Docker**: Each microservice, including the ride-ops API and UI, is containerized using Docker. Dockerfiles are configured to load environment variables from a central `.env` file.
- **Helm**: The application uses Helm for managing Kubernetes manifests, with an umbrella chart for the overall application and subcharts for individual services.

### 2.4 CI/CD and GitOps
- **GitHub Actions**: Automates the build, test, and deployment processes. It builds Docker images, pushes them to a container registry, and updates Helm charts.
- **ArgoCD**: Implements GitOps principles by monitoring the Git repository for changes and synchronizing the Kubernetes cluster with the desired state defined in Helm charts.

### 2.5 Monitoring
- **Prometheus**: Monitors the application by scraping metrics from Spring Boot's actuator endpoints.
- **Grafana**: Provides visualization of metrics collected by Prometheus, enabling real-time monitoring and alerting.

## 3. Security Considerations
- All sensitive information, such as database credentials, is stored in Kubernetes Secrets and referenced in the application configuration.
- The architecture follows the 12-Factor App principles, ensuring that the application is scalable and maintainable.

## 4. Conclusion
The Theme Park Ride Ops architecture is designed to be resilient, scalable, and easy to manage. By leveraging modern technologies such as Docker, Kubernetes, and GitOps, the system is well-equipped to handle the demands of a theme park environment.