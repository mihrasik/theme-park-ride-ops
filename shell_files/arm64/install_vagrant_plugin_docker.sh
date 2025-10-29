#!/bin/sh
# Restart with bash to handle advanced features
if [ -z "$BASH" ]; then
  exec /bin/bash "$0" "$@"
fi

set -euo pipefail

# Ensure vagrant is available
if ! command -v vagrant >/dev/null 2>&1; then
  echo "ERROR: Vagrant is not installed. Please install it first."
  exit 1
fi

echo "Installing Vagrant Docker plugin..."
vagrant plugin install docker

echo "Done. Verify with: vagrant plugin list"