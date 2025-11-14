#!/bin/bash

# Theme Park Ride Ops - macOS Quick Setup
# Alternative to Ansible for macOS systems

set -e

echo "Theme Park Ride Ops - macOS DevOps Setup"
echo "========================================="

# Function to print status
log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1"
    exit 1
}

# Check if we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is for macOS only. Use the Ansible playbook for Linux."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    log_info "Homebrew is already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# Install essential tools
log_info "Installing DevOps tools..."

tools=(
    "docker"
    "terraform"
    "k3d"
    "kubectl"
    "helm"
    "openjdk@11"
)

for tool in "${tools[@]}"; do
    if brew list "$tool" &> /dev/null; then
        log_info "$tool is already installed"
    else
        log_info "Installing $tool..."
        if [[ "$tool" == "docker" ]]; then
            brew install --cask docker
        else
            brew install "$tool"
        fi
    fi
done

# Setup Java environment
log_info "Setting up Java environment..."
if [[ -z "${JAVA_HOME}" ]]; then
    echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@11"' >> ~/.zprofile
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zprofile
fi

# Verify installations
echo ""
log_info "Verifying installations..."

verification_commands=(
    "docker --version"
    "terraform --version"
    "k3d --version"
    "kubectl version --client"
    "helm version"
    "java --version"
)

for cmd in "${verification_commands[@]}"; do
    if eval "$cmd" &> /dev/null; then
        tool=$(echo "$cmd" | cut -d' ' -f1)
        version=$(eval "$cmd" 2>/dev/null | head -1)
        echo "[OK] $tool: $version"
    else
        tool=$(echo "$cmd" | cut -d' ' -f1)
        echo "[FAILED] $tool: Not available"
    fi
done

echo ""
echo "Setup completed successfully!"
echo "==============================="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zprofile"
echo "2. Start Docker Desktop from Applications"
echo "3. Run: ./scripts/setup-env.sh"
echo ""
echo "Your macOS development environment is ready!"