#!/bin/bash

# Theme Park Ride Ops - Portable Environment Setup
# This script sets up environment variables and paths dynamically
# Source this script: source ./scripts/setup-env.sh

set -e

# Auto-detect project structure
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
export SCRIPTS_DIR="${PROJECT_ROOT}/scripts"

echo "Theme Park Ride Ops - Environment Setup"
echo "======================================="

# Function to print output
log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1"
}

# Check if we're in the correct project - flexible detection
project_markers=(
    "build.gradle"
    "settings.gradle" 
    "pom.xml"
    "theme-park-ride-ops-5"
    "ARCHITECTURE.md"
    "README.md"
)

project_valid=false
for marker in "${project_markers[@]}"; do
    if [[ -f "${PROJECT_ROOT}/${marker}" ]] || [[ -d "${PROJECT_ROOT}/${marker}" ]]; then
        project_valid=true
        break
    fi
done

if [[ "${project_valid}" != "true" ]]; then
    log_error "Not in a valid Theme Park Ride Ops project directory!"
    log_error "Expected to find one of: ${project_markers[*]} in: ${PROJECT_ROOT}"
    return 1 2>/dev/null || exit 1
fi

# Set up application paths
export APP_NAME="${APP_NAME:-theme-park-ride-ops}"
export APP_VERSION="${APP_VERSION:-latest}"

# Legacy structure (root level)
export LEGACY_SRC_DIR="${PROJECT_ROOT}/src"
export LEGACY_BUILD_DIR="${PROJECT_ROOT}/build"
export LEGACY_CONTAINERS_DIR="${PROJECT_ROOT}/containers"

# New structure (theme-park-ride-ops-5)
export NEW_BASE_DIR="${PROJECT_ROOT}/theme-park-ride-ops-5"
export NEW_APP_DIR="${NEW_BASE_DIR}/app/ride-ops"
export NEW_K8S_DIR="${NEW_BASE_DIR}/k8s"
export NEW_HELM_DIR="${NEW_BASE_DIR}/helm"
export NEW_TERRAFORM_DIR="${NEW_BASE_DIR}/terraform"
export NEW_ANSIBLE_DIR="${NEW_BASE_DIR}/ansible"

# Container configuration
export DOCKER_REGISTRY="${DOCKER_REGISTRY:-docker.io/themepark}"
export CONTAINER_IMAGE="${APP_NAME}"
export CONTAINER_TAG="${APP_VERSION}"

# Kubernetes configuration
export K8S_NAMESPACE="${K8S_NAMESPACE:-themepark-app}"
export K8S_CLUSTER_NAME="${K8S_CLUSTER_NAME:-themepark}"
export KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/config}"

# Database configuration
export DB_HOST="${DB_HOST:-mariadb}"
export DB_PORT="${DB_PORT:-3306}"
export DB_NAME="${DB_NAME:-themepark}"
export DB_USER="${DB_USER:-themeuser}"
export DB_PASSWORD="${DB_PASSWORD:-themedb123}"

# Development configuration
export JAVA_HOME="${JAVA_HOME:-$(which java | xargs dirname | xargs dirname)}"
export GRADLE_HOME="${GRADLE_HOME:-${PROJECT_ROOT}}"

# Detect architecture
export ARCH="$(uname -m)"
export OS="$(uname -s)"

# Set platform-specific paths
case "${OS}" in
    "Darwin")
        export PLATFORM="darwin"
        export PKG_MANAGER="brew"
        if [[ "${ARCH}" == "arm64" ]]; then
            export HOMEBREW_PREFIX="/opt/homebrew"
        else
            export HOMEBREW_PREFIX="/usr/local"
        fi
        ;;
    "Linux")
        export PLATFORM="linux"
        if command -v apt-get >/dev/null 2>&1; then
            export PKG_MANAGER="apt"
        elif command -v yum >/dev/null 2>&1; then
            export PKG_MANAGER="yum"
        elif command -v dnf >/dev/null 2>&1; then
            export PKG_MANAGER="dnf"
        fi
        ;;
    *)
        log_warn "Unknown operating system: ${OS}"
        export PLATFORM="unknown"
        ;;
esac

# Docker platform mapping
case "${ARCH}" in
    "x86_64")
        export DOCKER_ARCH="amd64"
        export DOCKER_PLATFORM="linux/amd64"
        ;;
    "arm64"|"aarch64")
        export DOCKER_ARCH="arm64"
        export DOCKER_PLATFORM="linux/arm64"
        ;;
    *)
        log_warn "Unknown architecture: ${ARCH}"
        export DOCKER_ARCH="${ARCH}"
        export DOCKER_PLATFORM="linux/${ARCH}"
        ;;
esac

# Function to check if required tools are installed
check_tools() {
    local required_tools=("docker" "kubectl" "helm")
    local optional_tools=("terraform" "k3d" "ansible")
    local missing_tools=()
    
    log_info "Checking required tools..."
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "${tool}" >/dev/null 2>&1; then
            missing_tools+=("${tool}")
            log_error "Required tool not found: ${tool}"
        else
            log_info "✓ ${tool} found"
        fi
    done
    
    log_info "Checking optional tools..."
    for tool in "${optional_tools[@]}"; do
        if command -v "${tool}" >/dev/null 2>&1; then
            log_info "✓ ${tool} found"
        else
            log_warn "Optional tool not found: ${tool}"
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Run the universal setup script: ./scripts/ansible_playbook_universal_setup.yml"
        return 1
    fi
    
    return 0
}

# Function to print environment summary
print_env() {
    cat << EOF

${BLUE}🎢 Theme Park Ride Ops - Environment Configuration${NC}
=====================================================

${GREEN}Project Structure:${NC}
  Project Root:     ${PROJECT_ROOT}
  Scripts Dir:      ${SCRIPTS_DIR}
  Legacy App:       ${LEGACY_SRC_DIR}
  New App:          ${NEW_APP_DIR}
  Kubernetes:       ${NEW_K8S_DIR}
  Terraform:        ${NEW_TERRAFORM_DIR}

${GREEN}System Information:${NC}
  OS:               ${OS} (${PLATFORM})
  Architecture:     ${ARCH}
  Docker Platform:  ${DOCKER_PLATFORM}
  Package Manager:  ${PKG_MANAGER:-unknown}

${GREEN}Application Configuration:${NC}
  App Name:         ${APP_NAME}
  App Version:      ${APP_VERSION}
  Container Image:  ${DOCKER_REGISTRY}/${CONTAINER_IMAGE}:${CONTAINER_TAG}
  K8s Namespace:    ${K8S_NAMESPACE}
  K8s Cluster:      ${K8S_CLUSTER_NAME}

${GREEN}Database Configuration:${NC}
  Host:             ${DB_HOST}:${DB_PORT}
  Database:         ${DB_NAME}
  User:             ${DB_USER}

${GREEN}Development Tools:${NC}
  Java Home:        ${JAVA_HOME}
  Gradle Home:      ${GRADLE_HOME}

EOF
}

# Export functions for use in other scripts
export -f log_info log_warn log_error check_tools print_env

# Main execution
main() {
    log_info "Setting up Theme Park Ride Ops environment..."
    
    # Validate project structure
    if [[ ! -d "${PROJECT_ROOT}" ]]; then
        log_error "Project root not found: ${PROJECT_ROOT}"
        return 1
    fi
    
    # Create any missing directories
    mkdir -p "${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/tmp"
    
    # Print environment configuration
    print_env
    
    # Show banner
    
    # Check tools (optional)
    if [[ "${CHECK_TOOLS:-}" == "true" ]]; then
        check_tools
    fi
    
    echo ""
    echo "Environment setup complete!"
    echo "Project root: ${PROJECT_ROOT}"
    echo "Use 'print_env' to view configuration anytime"
    echo ""
}

# Only run main if script is being executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi