#!/bin/sh
# Restart with bash to handle advanced features
if [ -z "$BASH" ]; then
  exec /bin/bash "$0" "$@"
fi

set -euo pipefail

# Function to print error messages
fail() { echo "ERROR: $*" >&2; exit 1; }

OS_NAME="$(uname -s)"

if [[ "$OS_NAME" == "Darwin" ]]; then
    echo "macOS detected. Installing Multipass via Homebrew..."
    
    # Check for Homebrew
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Please install Homebrew first:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        fail "Homebrew is required on macOS"
    fi

    # Install Multipass
    brew install --cask multipass
elif command -v apt-get >/dev/null 2>&1; then
    echo "Ubuntu/Debian detected. Installing Multipass via Snap..."
    
    # Ensure snap is installed
    if ! command -v snap >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y snapd
    fi
    
    # Install Multipass
    sudo snap install multipass
else
    fail "Unsupported OS: $OS_NAME. This script supports macOS and Ubuntu/Debian Linux."
fi

echo "Multipass installation completed. Run 'multipass version' to verify."