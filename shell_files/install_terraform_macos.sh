#!/bin/bash

# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Install HashiCorp tap if it's not already added
if ! brew tap | grep -q hashicorp/tap; then
    echo "Adding HashiCorp tap..."
    brew tap hashicorp/tap
else
    echo "HashiCorp tap is already added."
fi

# Install Terraform from the HashiCorp tap
echo "Installing Terraform..."
brew install hashicorp/tap/terraform

# Verify the installation of Terraform
echo "Verifying Terraform installation..."
terraform -help

# Enable tab completion for Terraform commands if using Bash or Zsh
if [[ "$SHELL" == *"/bash"* ]]; then
    echo "Enabling tab completion for Terraform in Bash..."
    terraform -install-autocomplete
    echo "Please restart your terminal session to enable autocomplete."
elif [[ "$SHELL" == *"/zsh"* ]]; then
    echo "Enabling tab completion for Terraform in Zsh..."
    terraform -install-autocomplete
    echo "Please restart your terminal session to enable autocomplete."
else
    echo "Shell not supported for autocomplete. Please refer to the Terraform documentation for manual setup."
fi

echo "Terraform installation and configuration complete."
