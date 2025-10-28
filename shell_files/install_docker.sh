#!/bin/sh
# Restart with bash to handle advanced features
if [ -z "$BASH" ]; then
  exec /bin/bash "$0" "$@"
fi

set -euo pipefail

# Function to print error messages
fail() { echo "ERROR: $*" >&2; exit 1; }

# Check if running on macOS
if [ "$(uname -s)" != "Darwin" ]; then
    fail "This script is for macOS only"
fi

# Check for Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

# Install Docker Desktop for Mac
if ! command -v docker >/dev/null 2>&1; then
    echo "Installing Docker Desktop for Mac..."
    brew install --cask docker
    
    echo "Starting Docker Desktop..."
    open -a Docker
    
    echo "Waiting for Docker daemon to start..."
    # Wait for Docker daemon to be available
    for i in {1..30}; do
        if docker info >/dev/null 2>&1; then
            echo "Docker daemon is running!"
            break
        fi
        echo "Waiting for Docker daemon to start... ($i/30)"
        sleep 2
    done
    
    if ! docker info >/dev/null 2>&1; then
        echo "Please start Docker Desktop manually:"
        echo "1. Open Docker Desktop application"
        echo "2. Wait for it to finish starting up"
        echo "3. Try running 'vagrant up --provider=docker' again"
        exit 1
    fi
else
    echo "Docker is already installed"
    
    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        echo "Starting Docker Desktop..."
        open -a Docker
        
        echo "Waiting for Docker daemon to start..."
        for i in {1..30}; do
            if docker info >/dev/null 2>&1; then
                echo "Docker daemon is running!"
                break
            fi
            echo "Waiting for Docker daemon to start... ($i/30)"
            sleep 2
        done
        
        if ! docker info >/dev/null 2>&1; then
            echo "Please start Docker Desktop manually:"
            echo "1. Open Docker Desktop application"
            echo "2. Wait for it to finish starting up"
            echo "3. Try running 'vagrant up --provider=docker' again"
            exit 1
        fi
    else
        echo "Docker daemon is already running"
    fi
fi

echo "Docker installation and setup completed successfully!"