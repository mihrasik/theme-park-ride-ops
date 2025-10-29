#!/bin/sh
# Restart with bash to handle advanced features
if [ -z "$BASH" ]; then
  exec /bin/bash "$0" "$@"
fi

set -euo pipefail

# Cross-platform Vagrant installer
# - macOS: installs via Homebrew cask
# - Linux (Debian/Ubuntu): installs via apt with HashiCorp repo

fail() { echo "ERROR: $*" >&2; exit 1; }

# Disable history expansion in bash/zsh
set +H 2>/dev/null || true
set +o histexpand 2>/dev/null || true

# Detect if script was sourced
if (return 0 2>/dev/null); then
  echo "This script must not be sourced. Run it with: bash $0"
  return 1 2>/dev/null || exit 1
fi

OS_NAME="$(uname -s)"

if [[ "$OS_NAME" == "Darwin" ]]; then
  echo "macOS detected. Installing Vagrant via Homebrew cask."

  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Please install Homebrew first:"
    echo "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fail "Homebrew is required on macOS. Re-run the script after installing Homebrew."
  fi

  echo "Updating Homebrew..."
  brew update || true

  echo "Installing Vagrant..."
  brew install --cask vagrant || true

  # Optionally install vagrant-manager (GUI)
  read -p "Would you like to install Vagrant Manager (GUI app)? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install --cask vagrant-manager || true
  fi

  echo "Done. Run 'vagrant --version' to verify installation."
  exit 0
fi

# --- Linux (Debian/Ubuntu) branch ---

if command -v apt-get >/dev/null 2>&1; then
  echo "Debian/Ubuntu detected. Installing Vagrant via apt..."

  # Install dependencies
  sudo apt-get update -y
  sudo apt-get install -y curl gpg lsb-release

  # Add HashiCorp GPG key
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  # Add HashiCorp repo
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

  # Install Vagrant
  sudo apt-get update
  sudo apt-get install -y vagrant

  echo "Done. Run 'vagrant --version' to verify installation."
  exit 0
fi

fail "Unsupported OS: $OS_NAME. This script supports macOS and Debian/Ubuntu Linux."