#!/bin/sh
# Restart with bash to handle advanced features
if [ -z "$BASH" ]; then
  exec /bin/bash "$0" "$@"
fi

set -euo pipefail

# Function to print error messages
fail() { echo "ERROR: $*" >&2; exit 1; }

# Check if multipass is installed
if ! command -v multipass >/dev/null 2>&1; then
    fail "Multipass is not installed. Please run ./install_multipass.sh first"
fi

# Check if the instance exists
if ! multipass info park-project >/dev/null 2>&1; then
    echo "Creating Multipass instance 'park-project'..."
    multipass launch --name park-project --memory 2G --disk 10G
fi

echo "Mounting project directories..."

# Mount the directories with error checking
mount_dir() {
    local src="$1"
    local dest="$2"
    if [ ! -d "$src" ]; then
        fail "Source directory does not exist: $src"
    fi
    echo "Mounting $src to $dest..."
    multipass mount "$src" "park-project:$dest"
}

# Mount the theme-park-ride-ops directory
mount_dir "/Users/rahulsingh/Ekta/DataScientest/theme-park-ride-ops" "/home/ubuntu/project/theme-park-ride-ops"

echo "Mount completed successfully. You can verify with: multipass info park-project"