# Architecture Overview of Theme Park Ride Ops

## Project Overview
The Theme Park Ride Ops project is a microservices-based application designed to manage theme park ride operations. It consists of three main microservices, a MariaDB database, and a load balancer, all orchestrated using Kubernetes. The project aims to provide a scalable and maintainable architecture that adheres to modern DevOps practices.

## Architecture Diagram
![Architecture Diagram](path/to/architecture-diagram.png) <!-- Replace with actual path to the diagram -->

## Microservices
1. **App1**: Responsible for managing ride operations.
   - **API Endpoints**:
     - `GET /rides`: Retrieve a list of rides.
     - `POST /rides`: Create a new ride.
     - `PUT /rides/{id}`: Update ride details.
     - `DELETE /rides/{id}`: Remove a ride.

2. **App2**: Handles user management and authentication.
   - **API Endpoints**:
     - `POST /users`: Register a new user.
     - `GET /users/{id}`: Retrieve user details.
     - `PUT /users/{id}`: Update user information.
     - `DELETE /users/{id}`: Delete a user account.

3. **App3**: Manages ride reservations and scheduling.
   - **API Endpoints**:
     - `POST /reservations`: Create a new reservation.
     - `GET /reservations/{id}`: Retrieve reservation details.
     - `DELETE /reservations/{id}`: Cancel a reservation.

## Database
- **MariaDB**: Used for persistent storage of user data, ride information, and reservations.
- **StatefulSet**: Deployed in Kubernetes to manage the database with persistent volume claims (PVCs) for data storage.

## Load Balancer
- **NGINX/Traefik**: Acts as a reverse proxy to route traffic to the appropriate microservices based on the incoming requests.

## CI/CD Flow
1. **Code Commit**: Developers push code changes to the GitHub repository.
2. **GitHub Actions**: 
   - Build and test the Spring Boot applications.
   - Build and push Docker images to Docker Hub.
   - Update Helm chart values.
   - Sync with ArgoCD for deployment.
3. **ArgoCD**: Monitors the Git repository for changes and automatically deploys updates to the Kubernetes cluster.

## Scrum/Trello Guidelines
- Use Trello for task management, with columns for Backlog, In Progress, Review, and Done.
- Each task should have a clear description, acceptance criteria, and assigned team members.
- Daily stand-ups to discuss progress and blockers.

## Branching Guidelines
- Use the `main` branch for production-ready code.
- Create feature branches from `main` for new features or bug fixes.
- Use descriptive names for branches (e.g., `feature/add-user-authentication`).
- Merge feature branches back into `main` via pull requests after code review.

## Conclusion
This architecture provides a robust foundation for the Theme Park Ride Ops project, ensuring scalability, maintainability, and efficient deployment through modern DevOps practices.