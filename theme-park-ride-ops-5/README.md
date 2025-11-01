# theme-park-ride-ops/README.md

# Theme Park Ride Ops

Welcome to the Theme Park Ride Ops project! This project is designed to manage ride operations in a theme park using a microservices architecture built with Spring Boot. The application is containerized using Docker and orchestrated with Kubernetes, providing a scalable and robust solution for ride management.

## Table of Contents

- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

The Theme Park Ride Ops project consists of several microservices that handle various aspects of ride operations, including ride management, user interactions, and data storage. The application is designed to run on a Kubernetes cluster, ensuring high availability and scalability.

## Technologies Used

- **Spring Boot**: For building the microservices.
- **Docker**: For containerizing the application.
- **Kubernetes**: For orchestrating the containers.
- **Helm**: For managing Kubernetes applications.
- **Terraform**: For provisioning infrastructure.
- **Ansible**: For configuration management.
- **GitHub Actions**: For CI/CD automation.
- **Prometheus & Grafana**: For monitoring and visualization.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/mihrasik/theme-park-ride-ops.git
   cd theme-park-ride-ops
   ```

2. **Configure Environment Variables**:
   Create a `.env` file in the root directory and populate it with the necessary environment variables. Refer to the provided `.env` file for examples.

3. **Build and Run the Application**:
   Use Docker Compose to build and run the application locally:
   ```bash
   docker-compose up --build
   ```

4. **Deploy to Kubernetes**:
   Use Terraform and Ansible to provision and configure the Kubernetes cluster:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

5. **Access the Application**:
   Once the application is running, you can access it via the configured ingress.

## Usage

After setting up the application, you can interact with the ride operations through the provided REST APIs. Refer to the API documentation for detailed usage instructions.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.