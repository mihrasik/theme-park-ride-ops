# Architecture Overview for Theme Park Ride Ops

## Project Overview
The Theme Park Ride Ops project is a microservices-based application built using Spring Boot, consisting of three distinct applications (App1, App2, App3) that interact with a MariaDB database and are managed through a load balancer. The architecture is designed to be scalable, maintainable, and deployable using modern DevOps practices.

## Architecture Diagram
![Architecture Diagram](../docs/architecture_diagram.png)

## Components
1. **Microservices**:
   - **App1**: Handles user interactions and ride bookings.
   - **App2**: Manages ride information and availability.
   - **App3**: Processes payments and transactions.

2. **Database**:
   - **MariaDB**: A relational database used to store application data, configured with a StatefulSet for persistence.

3. **Load Balancer**:
   - **NGINX/Traefik**: Distributes incoming traffic to the microservices, ensuring high availability and reliability.

4. **CI/CD Pipeline**:
   - **GitHub Actions**: Automates the build, test, and deployment processes for the microservices.
   - **ArgoCD**: Manages the deployment of applications to the Kubernetes cluster, ensuring that the desired state is maintained.

## API Endpoints
- **App1**:
  - `POST /api/bookings`: Create a new booking.
  - `GET /api/bookings/{id}`: Retrieve booking details.

- **App2**:
  - `GET /api/rides`: List all available rides.
  - `GET /api/rides/{id}`: Get details of a specific ride.

- **App3**:
  - `POST /api/payments`: Process a payment.
  - `GET /api/payments/{id}`: Retrieve payment status.

## CI/CD Flow
1. **Code Commit**: Developers push code changes to the GitHub repository.
2. **Build**: GitHub Actions triggers the build process, compiling the applications and running tests.
3. **Docker Image Creation**: Docker images are built for each microservice and pushed to Docker Hub.
4. **Helm Chart Update**: Helm chart values are updated with the new image tags.
5. **Deployment**: ArgoCD syncs the updated Helm charts to the Kubernetes cluster, deploying the new versions of the applications.
6. **Monitoring**: Prometheus and Grafana monitor the applications, providing insights into performance and health.

## Scrum/Trello Guidelines
- Use Trello for task management, with columns for Backlog, In Progress, Review, and Done.
- Daily stand-ups to discuss progress and blockers.
- Sprint planning every two weeks to prioritize tasks.

## Branching Guidelines
- Use the `main` branch for production-ready code.
- Feature branches should be named `feature/{feature-name}`.
- Bugfix branches should be named `bugfix/{bug-name}`.
- Merge requests should be reviewed by at least one other team member before merging into `main`.