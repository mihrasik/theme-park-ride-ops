#!/bin/bash

# Multi-Architecture Docker Build Script for Theme Park Ride Ops
# This script builds Docker images for both AMD64 and ARM64 architectures

set -e

# Source environment configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/setup-env.sh"

# Configuration - Auto-detect project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-theme-park-ride-ops}"
TAG="${1:-latest}"
REGISTRY="${DOCKER_REGISTRY:-docker.io/themepark}"

echo "Theme Park Ride Ops - Multi-Architecture Build"
echo "==============================================="

log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    # Check Docker buildx
    if ! docker buildx version &> /dev/null; then
        log_error "Docker buildx is not available. Please upgrade Docker to latest version."
        exit 1
    fi
    
    # Check if multiarch builder exists, create if not
    if ! docker buildx ls | grep -q "multiarch"; then
        log_info "Creating multiarch builder..."
        docker buildx create --name multiarch --platform linux/amd64,linux/arm64 --use
        docker buildx inspect --bootstrap
    else
        log_info "Using existing multiarch builder..."
        docker buildx use multiarch
    fi
    
    log_info "Prerequisites check passed!"
}

# Build the application
build_application() {
    log_info "Building Spring Boot application..."
    cd "${PROJECT_ROOT}"
    
    # Clean and build
    ./gradlew clean build -x test
    
    if [ $? -eq 0 ]; then
        log_info "Application build completed successfully!"
    else
        log_error "Application build failed!"
        exit 1
    fi
}

# Build multi-architecture Docker images
build_docker_images() {
    log_info "Building multi-architecture Docker images..."
    cd "${PROJECT_ROOT}"
    
    # Build and push multi-arch image
    docker buildx build \
        --platform linux/amd64,linux/arm64 \
        --file containers/app/Dockerfile.multiarch \
        --tag "${REGISTRY}/${IMAGE_NAME}:${TAG}" \
        --tag "${REGISTRY}/${IMAGE_NAME}:latest" \
        --push \
        .
    
    if [ $? -eq 0 ]; then
        log_info "Multi-architecture Docker images built and pushed successfully!"
        log_info "Image: ${REGISTRY}/${IMAGE_NAME}:${TAG}"
    else
        log_error "Docker build failed!"
        exit 1
    fi
}

# Build for local testing (current architecture only)
build_local() {
    log_info "Building for local testing (current architecture)..."
    cd "${PROJECT_ROOT}"
    
    # Detect current architecture
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        PLATFORM="linux/amd64"
    elif [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
        PLATFORM="linux/arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        exit 1
    fi
    
    log_info "Building for platform: $PLATFORM"
    
    docker buildx build \
        --platform "$PLATFORM" \
        --file containers/app/Dockerfile.multiarch \
        --tag "${IMAGE_NAME}:${TAG}-local" \
        --load \
        .
    
    if [ $? -eq 0 ]; then
        log_info "Local Docker image built successfully!"
        log_info "Image: ${IMAGE_NAME}:${TAG}-local"
    else
        log_error "Local Docker build failed!"
        exit 1
    fi
}

# Test the built image
test_image() {
    local image_name="$1"
    log_info "Testing image: $image_name"
    
    # Run basic container test
    container_id=$(docker run -d -p 8080:8080 "$image_name")
    
    if [ $? -eq 0 ]; then
        log_info "Container started with ID: $container_id"
        
        # Wait for application to start
        log_info "Waiting for application to start..."
        sleep 30
        
        # Test health endpoint
        if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
            log_info "Health check passed!"
        else
            log_warn "Health check failed, but container is running"
        fi
        
        # Cleanup
        docker stop "$container_id" > /dev/null
        docker rm "$container_id" > /dev/null
        log_info "Test container cleaned up"
    else
        log_error "Failed to start test container!"
        exit 1
    fi
}

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS] [TAG]"
    echo "Options:"
    echo "  --local     Build for local testing only (current architecture)"
    echo "  --no-push   Build multi-arch but don't push to registry"
    echo "  --test      Test the built image"
    echo "  --help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Build multi-arch and push with 'latest' tag"
    echo "  $0 v1.0.0             # Build multi-arch and push with 'v1.0.0' tag"
    echo "  $0 --local            # Build for local testing only"
    echo "  $0 --local --test     # Build locally and test"
}

# Main execution
main() {
    local local_only=false
    local no_push=false
    local run_test=false
    local tag="latest"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --local)
                local_only=true
                shift
                ;;
            --no-push)
                no_push=true
                shift
                ;;
            --test)
                run_test=true
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            -*)
                log_error "Unknown option $1"
                usage
                exit 1
                ;;
            *)
                tag="$1"
                shift
                ;;
        esac
    done
    
    log_info "Starting build process..."
    log_info "Tag: $tag"
    log_info "Local only: $local_only"
    log_info "Registry: $REGISTRY"
    
    check_prerequisites
    build_application
    
    if [ "$local_only" = true ]; then
        build_local
        if [ "$run_test" = true ]; then
            test_image "${IMAGE_NAME}:${tag}-local"
        fi
    else
        if [ "$no_push" = true ]; then
            log_warn "--no-push not implemented for multi-arch builds yet"
            log_warn "Building with push enabled"
        fi
        build_docker_images
    fi
    
    echo ""
    echo "Build process completed successfully!"
    echo ""
}

# Run main function with all arguments
main "$@"