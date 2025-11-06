# terraform/providers.tf
terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 3.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# provider "aws" {
#   region = var.aws_region
# }

# provider "kubernetes" {
#   config_path = var.kubeconfig_path
# }