#!/bin/bash

# Cross-platform install script
# On macOS this script will attempt to use Homebrew to install Docker Desktop (cask).
# On Linux (Debian/Ubuntu) it will continue to use apt-get as before.

# Safety and compatibility hardening
# - prevent accidental sourcing
# - try to disable history expansion in zsh/bash to avoid "event not found" on pasted lines
# - fail fast on errors

# Try to disable history expansion in bash and zsh (no-op if not supported)
(set +H 2>/dev/null || true) || true
(set +o histexpand 2>/dev/null || true) || true

# Detect if the script was sourced. If so, refuse and instruct the user to run with bash.
if (return 0 2>/dev/null); then
	# We're in a shell where 'return' is valid; check if $0 equals the script path
	case "${BASH_SOURCE[0]:-}" in
		"" )
			# If BASH_SOURCE is empty (e.g. running under /bin/sh), fall back to $0 check below
			: ;;
		* )
			if [ "${BASH_SOURCE[0]}" != "$0" ]; then
				echo "This script must not be sourced. Run it with: bash $0"
				return 1 2>/dev/null || exit 1
			fi
			;;
	esac
fi

# For zsh, check ZSH_EVAL_CONTEXT to detect sourcing
if [ -n "$ZSH_VERSION" ] && [ "${ZSH_EVAL_CONTEXT:-}" = "toplevel" ]; then
	# running as a script
	:
elif [ -n "$ZSH_VERSION" ] && [[ "${ZSH_EVAL_CONTEXT:-}" == *:file ]]; then
	echo "This script must not be sourced. Run it with: bash $0"
	return 1 2>/dev/null || exit 1
fi

set -euo pipefail

OS_NAME="$(uname -s)"

if [[ "${OS_NAME}" == "Darwin" ]]; then
	echo "Detected macOS (Darwin). Using Homebrew to install Docker Desktop."

	# Ensure Homebrew exists
	if ! command -v brew >/dev/null 2>&1; then
		echo "Homebrew not found. Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "If the Homebrew installer printed instructions about adding Homebrew to your PATH, we'll try to add it now."

		# Try to add the common Homebrew locations to PATH for this session
		if [ -x "/opt/homebrew/bin/brew" ]; then
			eval "$(/opt/homebrew/bin/brew shellenv)" || true
		elif [ -x "/usr/local/bin/brew" ]; then
			eval "$(/usr/local/bin/brew shellenv)" || true
		fi

		if ! command -v brew >/dev/null 2>&1; then
			echo "Homebrew still not available in PATH. Follow the installer's printed instructions, then re-run: bash $0"
			exit 1
		fi
	fi

	echo "Updating Homebrew..."
	brew update || true

	echo "Installing Docker Desktop via Homebrew Cask..."
	# This installs the Docker Desktop app. It may require user interaction the first time you run Docker Desktop.
	brew install --cask docker || true

	echo "Installation attempted. To start Docker Desktop now, run: open -a Docker"
	echo "Notes: Docker Desktop will show a GUI and may prompt for permissions on first run."
	echo "If you'd prefer a headless option, consider using Colima: 'brew install colima docker docker-compose' and then 'colima start'."
	exit 0
fi

# --- Original Ubuntu/Debian steps (kept for Linux hosts) ---

# Ensure apt-get exists on this host
if ! command -v apt-get >/dev/null 2>&1; then
	echo "apt-get not found on this host. This script currently supports Debian/Ubuntu via apt-get or macOS via Homebrew."
	echo "If you're running a different Linux distribution, install Docker using your distro's package manager or follow Docker's docs: https://docs.docker.com/engine/install/"
	exit 1
fi

# System Update
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Added official Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adding Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Updated list of available packages
sudo apt-get update

# Replace docker-ce with docker.io for standard Ubuntu installation
sudo apt-get install -y docker.io
sudo apt-get install -y docker-compose-plugin
# Package docker-ce is not available, but is referred to by another package.
# Docker version 28.5.1, build e180ab8
# sudo apt-get install -y docker-ce-cli
# Installing Docker version 25
# sudo apt-get install -y docker-ce=5:25.0.0~3-0~ubuntu

# Verifying Docker Installation
if command -v docker >/dev/null 2>&1; then
	docker --version
else
	echo "docker command not found after install. There may have been an error."
fi

# Starting and Activating the Docker Service (only if systemctl is available)
if command -v systemctl >/dev/null 2>&1; then
	sudo systemctl start docker
	sudo systemctl enable docker
else
	echo "systemctl not found; skipping service start/enable. If your system uses a different init system, start the docker service manually."
fi