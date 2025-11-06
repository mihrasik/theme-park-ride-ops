# Theme Park Ride Ops

Welcome to the Theme Park Ride Ops project! This repository contains a microservices-based application built with Spring Boot, designed to manage operations for a theme park. The project is structured to facilitate easy deployment, scaling, and management of services using modern DevOps practices.

## Project Structure

- **docs/**: Contains architecture documentation and design decisions.
- **src/**: Contains the source code for the microservices.
  - **app1/**: Microservice 1
  - **app2/**: Microservice 2
  - **app3/**: Microservice 3
- **mariadb/**: Contains the Docker configuration and initialization scripts for the MariaDB database.
- **load-balancer/**: Contains the Docker configuration for the load balancer.
- **terraform/**: Infrastructure as Code (IaC) configurations for local and AWS provisioning.
- **ansible/**: Automation scripts for setting up the environment.
- **helm/**: Helm charts for deploying the microservices on Kubernetes.
- **argocd/**: Configuration for ArgoCD to manage deployments.
- **.env**: Environment variables for configuration.
- **package.json**: Node.js package configuration.
- **README.md**: Project documentation.
- **Jenkinsfile**: CI/CD pipeline configuration for Jenkins.

## Getting Started

### Prerequisites

- Java 17
- Docker
- Kubernetes (k3s or kubeadm)
- Helm
- Terraform
- Ansible
- GitHub Actions or Jenkins for CI/CD

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. Set up environment variables:
   - Create a `.env` file based on the provided template and fill in the necessary values.

3. Provision the infrastructure:
   - Navigate to the `terraform/local_prov` directory and run:
     ```
     terraform init
     terraform apply
     ```

4. Configure the environment using Ansible:
   ```
   ansible-playbook -i ansible/inventory ansible/playbook.yml
   ```

5. Build and deploy the applications:
   - For each application, navigate to its directory and run:
     ```
     ./gradlew bootJar
     docker build -t <your-dockerhub-username>/app1 .
     ```

6. Deploy using Helm:
   ```
   helm upgrade --install app1 helm/app1
   helm upgrade --install app2 helm/app2
   helm upgrade --install app3 helm/app3
   ```

7. Set up ArgoCD for continuous deployment:
   ```
   kubectl apply -f argocd/application.yaml
   ```

### Usage

- Access the applications through the load balancer.
- Monitor the applications using Grafana and Prometheus.

## Contributing

Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.