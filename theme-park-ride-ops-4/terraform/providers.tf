terraform/providers.tf
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "docker" {
  host = "tcp://localhost:2375/"
}