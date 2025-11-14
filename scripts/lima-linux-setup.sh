#!/bin/bash

# Theme Park Ride Ops - Lima Linux VM Setup
# Alternative to Docker - uses Lima for lightweight Linux VM

set -e

echo "Theme Park Ride Ops - Lima Linux VM Setup"
echo "========================================="

# Configuration
VM_NAME="themepark-devops"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1"
    exit 1
}

# Check if Lima is installed
if ! command -v lima >/dev/null 2>&1; then
    log_info "Installing Lima..."
    if command -v brew >/dev/null 2>&1; then
        brew install lima
    else
        log_error "Homebrew not found. Please install Homebrew first or install Lima manually."
    fi
fi

# Create Lima VM configuration
log_info "Creating Lima VM configuration (using host Docker)..."
cat > "/tmp/${VM_NAME}.yaml" << EOF
arch: null  # Let Lima auto-detect architecture
images:
  - location: "https://cloud-images.ubuntu.com/releases/22.04/release-20231211/ubuntu-22.04-server-cloudimg-amd64.img"
    arch: "x86_64"
  - location: "https://cloud-images.ubuntu.com/releases/22.04/release-20231211/ubuntu-22.04-server-cloudimg-arm64.img"
    arch: "aarch64"

cpus: 2
memory: "4GiB"
disk: "50GiB"

mounts:
  - location: "${PROJECT_ROOT}"
    writable: true
  - location: "/var/run/docker.sock"
    writable: true

networks:
  - lima: shared

# Use host Docker - no need for containerd in VM
containerd:
  system: false
  user: false

provision:
  - mode: system
    script: |
      #!/bin/bash
      set -eux -o pipefail
      
      # Update system
      apt-get update
      apt-get upgrade -y
      
      # Install required packages (no Docker daemon)
      apt-get install -y \\
        curl wget unzip git vim htop \\
        python3 python3-pip \\
        software-properties-common \\
        apt-transport-https \\
        ca-certificates \\
        gnupg \\
        lsb-release \\
        docker.io
      
      # Install Ansible
      pip3 install ansible
      
      # Add user to docker group for host Docker socket access
      usermod -aG docker lima-${VM_NAME}
      
      # Stop and disable Docker service (we'll use host Docker)
      systemctl stop docker || true
      systemctl disable docker || true

probes:
  - script: |
      #!/bin/bash
      set -eux -o pipefail
      if ! timeout 30s bash -c "until command -v ansible >/dev/null 2>&1; do sleep 3; done"; then
        echo >&2 "ansible is not installed yet"
        exit 1
      fi
    hint: See "/var/log/cloud-init-output.log" in the guest

portForwards:
  - guestPort: 8080
    hostPort: 8080
  - guestPort: 6443
    hostPort: 6443

ssh:
  loadDotSSHPubKeys: true
EOF

# Stop existing VM if running
if limactl list | grep -q "${VM_NAME}"; then
    log_info "Stopping existing VM..."
    limactl stop "${VM_NAME}" || true
    limactl delete "${VM_NAME}" || true
fi

# Start Lima VM
log_info "Starting Lima VM (lightweight, using host Docker)..."
limactl start "/tmp/${VM_NAME}.yaml" --name="${VM_NAME}"

# Wait for VM to be ready
log_info "Waiting for VM to be ready..."
limactl shell "${VM_NAME}" sudo cloud-init status --wait

# Run the Ansible playbook inside the VM
log_info "Running Ansible setup inside Linux VM (using host Docker)..."
limactl shell "${VM_NAME}" bash -c "
    cd '${PROJECT_ROOT}'
    sudo ansible-playbook scripts/ansible_linux_host_docker.yml
"

if [ $? -eq 0 ]; then
    echo ""
    echo "Setup completed successfully!"
    echo "=========================="
    echo ""
    echo "Your Linux VM is ready:"
    echo "  VM name: ${VM_NAME}"
    echo "  Access via: limactl shell ${VM_NAME}"
    echo "  Project mounted at: ${PROJECT_ROOT}"
    echo "  Docker: Using host Docker (macOS)"
    echo ""
    echo "To start working:"
    echo "  1. limactl shell ${VM_NAME}"
    echo "  2. cd ${PROJECT_ROOT}"
    echo "  3. ./scripts/setup-env.sh"
    echo ""
    echo "VM management:"
    echo "  Status: limactl list"
    echo "  Stop: limactl stop ${VM_NAME}"
    echo "  Start: limactl start ${VM_NAME}"
    echo "  Delete: limactl delete ${VM_NAME}"
    echo ""
else
    log_error "Setup failed. Check the output above for details."
fi

# Clean up temporary file
rm -f "/tmp/${VM_NAME}.yaml"