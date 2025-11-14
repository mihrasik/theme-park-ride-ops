#!/bin/bash

# Theme Park Ride Ops - Linux Container Setup
# Run Linux environment setup from macOS using Docker

set -e

echo "Theme Park Ride Ops - Linux Container DevOps Setup"
echo "=================================================="

# Configuration
CONTAINER_NAME="themepark-devops-setup"
UBUNTU_VERSION="22.04"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1"
    exit 1
}

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    log_error "Docker is not running. Please start Docker Desktop."
fi

# Clean up any existing container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    log_info "Removing existing container..."
    docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

log_info "Starting Ubuntu ${UBUNTU_VERSION} container..."

# Run Ubuntu container with systemd support
docker run -d \
    --name "${CONTAINER_NAME}" \
    --privileged \
    --tmpfs /tmp \
    --tmpfs /run \
    --tmpfs /run/lock \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    -v "${PROJECT_ROOT}:/workspace" \
    -p 8080:8080 \
    -p 6443:6443 \
    ubuntu:"${UBUNTU_VERSION}" \
    /sbin/init

# Wait for container to be ready
log_info "Waiting for container to initialize..."
sleep 5

# Install dependencies in container
log_info "Installing dependencies in container..."
docker exec "${CONTAINER_NAME}" bash -c "
    apt-get update
    apt-get install -y python3 python3-pip sudo
    pip3 install ansible
    
    # Create a non-root user for ansible
    useradd -m -s /bin/bash devops
    echo 'devops ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    
    # Set up workspace permissions
    chown -R devops:devops /workspace
"

# Run the Linux setup playbook inside the container
log_info "Running Ansible playbook inside Linux container..."
docker exec -u devops "${CONTAINER_NAME}" bash -c "
    cd /workspace
    ansible-playbook scripts/ansible_linux_setup.yml
"

if [ $? -eq 0 ]; then
    echo ""
    echo "Setup completed successfully!"
    echo "=========================="
    echo ""
    echo "Your Linux development environment is ready inside the container:"
    echo "  Container name: ${CONTAINER_NAME}"
    echo "  Access via: docker exec -it ${CONTAINER_NAME} bash"
    echo "  Project mounted at: /workspace"
    echo ""
    echo "To start working:"
    echo "  1. docker exec -it ${CONTAINER_NAME} bash"
    echo "  2. cd /workspace"
    echo "  3. ./scripts/setup-env.sh"
    echo ""
    echo "To stop the container: docker stop ${CONTAINER_NAME}"
    echo "To remove the container: docker rm ${CONTAINER_NAME}"
    echo ""
else
    log_error "Setup failed. Check the output above for details."
fi