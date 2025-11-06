# Architecture Overview of Theme Park Ride Ops

## Project Overview
The Theme Park Ride Ops project is a microservices-based application built using Spring Boot and Java 17. It consists of three main applications, a MariaDB database, and a load balancer, all orchestrated using Kubernetes. The architecture is designed to be scalable, maintainable, and production-ready, leveraging modern DevOps practices.

## Architecture Diagram
![Architecture Diagram](path/to/architecture-diagram.png)

## Microservices
1. **App1**: Responsible for managing ride operations.
   - **API Endpoints**:
     - `GET /rides`: Retrieve all rides.
     - `POST /rides`: Create a new ride.
     - `PUT /rides/{id}`: Update ride information.
     - `DELETE /rides/{id}`: Delete a ride.

2. **App2**: Handles user management and authentication.
   - **API Endpoints**:
     - `POST /users`: Register a new user.
     - `GET /users/{id}`: Retrieve user information.
     - `PUT /users/{id}`: Update user details.
     - `DELETE /users/{id}`: Delete a user.

3. **App3**: Manages ticketing and payments.
   - **API Endpoints**:
     - `POST /tickets`: Purchase a ticket.
     - `GET /tickets/{id}`: Retrieve ticket information.
     - `DELETE /tickets/{id}`: Cancel a ticket.

## Database
- **MariaDB**: Used for persistent data storage.
  - **StatefulSet**: Ensures data persistence and high availability.
  - **Automated Backups**: Scheduled via Kubernetes CronJobs.

## Load Balancer
- **NGINX/Traefik**: Distributes incoming traffic to the microservices, ensuring high availability and reliability.

## CI/CD Flow
1. **Code Commit**: Developers push code changes to the repository.
2. **Build & Test**: GitHub Actions triggers a build and runs tests for each microservice.
3. **Docker Image Build**: Successful builds create Docker images and push them to Docker Hub.
4. **Helm Chart Update**: Helm charts are updated with new image tags.
5. **ArgoCD Sync**: ArgoCD automatically syncs the Kubernetes cluster with the updated Helm charts, deploying the new versions of the applications.

## Scrum/Trello Guidelines
- **Sprints**: 2-week sprints with planning, review, and retrospective meetings.
- **Trello Board**: Use a Trello board to track tasks, with columns for Backlog, In Progress, Review, and Done.
- **Daily Standups**: Short daily meetings to discuss progress and blockers.

## Branching Guidelines
- **Main Branch**: `main` for production-ready code.
- **Development Branch**: `develop` for ongoing development.
- **Feature Branches**: Create branches from `develop` for new features (e.g., `feature/ride-management`).
- **Hotfix Branches**: Create branches from `main` for urgent fixes (e.g., `hotfix/issue-123`).

## Conclusion
This architecture provides a robust foundation for the Theme Park Ride Ops project, ensuring scalability, maintainability, and efficient deployment through modern DevOps practices.