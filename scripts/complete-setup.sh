#!/bin/bash

# Theme Park Ride Ops - Complete Setup with Clean Docker
# Uses Ansible to install tools + Clean Dockerfile without Vagrant

set -e

echo "Theme Park Ride Ops - Complete Development Setup"
echo "================================================"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTAINER_NAME="themepark-app-clean"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1"
    exit 1
}

# Step 1: Run Ansible setup for all DevOps tools
log_info "Step 1: Installing DevOps tools with Ansible..."
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS - use the universal setup
    ansible-playbook "${PROJECT_ROOT}/scripts/ansible_playbook_universal_setup.yml" --ask-become-pass
else
    # Linux - use the Linux setup
    sudo ansible-playbook "${PROJECT_ROOT}/scripts/ansible_linux_setup.yml"
fi

if [ $? -ne 0 ]; then
    log_error "Ansible setup failed"
fi

log_info "Ansible setup completed successfully!"

# Step 2: Build the application
log_info "Step 2: Building Spring Boot application..."
cd "${PROJECT_ROOT}"

# Check for Gradle project in theme-park-ride-ops-5
if [ -f "theme-park-ride-ops-5/app/ride-ops/gradlew" ]; then
    log_info "Found Gradle project in theme-park-ride-ops-5/app/ride-ops"
    cd theme-park-ride-ops-5/app/ride-ops
    chmod +x gradlew
    ./gradlew clean build -x test
    cd "${PROJECT_ROOT}"
    
    # Copy JAR to expected location for Docker build
    mkdir -p build/libs
    cp theme-park-ride-ops-5/app/ride-ops/build/libs/*.jar build/libs/
    
elif [ -f "theme-park-ride-ops-5/app/ride-ops/pom.xml" ]; then
    log_info "Found Maven project in theme-park-ride-ops-5/app/ride-ops"
    cd theme-park-ride-ops-5/app/ride-ops
    mvn clean install -DskipTests
    cd "${PROJECT_ROOT}"
    
    # Copy JAR to expected location for Docker build
    mkdir -p build/libs
    cp theme-park-ride-ops-5/app/ride-ops/target/*.jar build/libs/
    
elif [ -f "gradlew" ]; then
    log_info "Found Gradle project in root"
    ./gradlew clean build -x test
elif [ -f "pom.xml" ]; then
    log_info "Found Maven project in root"
    mvn clean install -DskipTests
else
    log_error "No build system found (gradlew or Maven pom.xml)"
fi

log_info "Application build completed!"

# Step 3: Build clean Docker image
log_info "Step 3: Building clean Docker image (no Vagrant)..."

# Ensure build artifacts exist
if [ ! -f "build/libs/"*.jar ]; then
    log_error "No JAR file found after build in build/libs/"
fi

log_info "Build artifacts found:"
ls -la build/libs/

# Build the clean Docker image
docker build -f containers/app/Dockerfile.clean -t "${CONTAINER_NAME}:latest" .

if [ $? -ne 0 ]; then
    log_error "Docker build failed"
fi

log_info "Docker image built successfully!"

# Step 4: Run the application
log_info "Step 4: Running the application..."

# Stop existing container if running
docker stop "${CONTAINER_NAME}" 2>/dev/null || true
docker rm "${CONTAINER_NAME}" 2>/dev/null || true

# Run the new container
docker run -d \
    --name "${CONTAINER_NAME}" \
    -p 8080:8080 \
    -p 2222:22 \
    -p 5000:5000 \
    "${CONTAINER_NAME}:latest"

# Wait for application to start
log_info "Waiting for application to start..."
sleep 15

# Test the application
log_info "Testing application health..."
if curl -f http://localhost:8080/actuator/health >/dev/null 2>&1; then
    echo ""
    echo "SUCCESS! Theme Park Ride Ops is running!"
    echo "========================================"
    echo ""
    echo "Application URLs:"
    echo "  Health Check: http://localhost:8080/actuator/health"
    echo "  Main App:     http://localhost:8080"
    echo "  SSH Access:   ssh appuser@localhost -p 2222"
    echo "  Password:     appuser123"
    echo ""
    echo "Container Management:"
    echo "  View logs:    docker logs ${CONTAINER_NAME}"
    echo "  Stop:         docker stop ${CONTAINER_NAME}"
    echo "  Remove:       docker rm ${CONTAINER_NAME}"
    echo ""
    echo "DevOps Tools Installed:"
    echo "  Docker:       $(docker --version)"
    echo "  Terraform:    $(terraform --version | head -1)"
    echo "  k3d:          $(k3d --version)"
    echo "  kubectl:      $(kubectl version --client --short 2>/dev/null || echo 'Available')"
    echo ""
else
    log_error "Application health check failed"
fi

log_info "Setup completed successfully!"