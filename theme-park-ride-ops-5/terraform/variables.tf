# terraform/variables.tf
variable "app_env" {
  description = "The environment in which the application is running (e.g., local, production)"
  type        = string
  default     = "local"
}

variable "db_host" {
  description = "The hostname of the database"
  type        = string
  default     = "mariadb"
}

variable "db_port" {
  description = "The port on which the database is running"
  type        = number
  default     = 3306
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "themepark"
}

variable "db_user" {
  description = "The username for the database"
  type        = string
  default     = "themeuser"
}

variable "db_pass" {
  description = "The password for the database"
  type        = string
  default     = "themedb123"
}

variable "registry_url" {
  description = "The Docker registry URL"
  type        = string
  default     = "docker.io/myrepo"
}

variable "argocd_namespace" {
  description = "The namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "themepark_namespace" {
  description = "The namespace for the theme park application"
  type        = string
  default     = "themepark-app"
}

variable "prometheus_port" {
  description = "The port for Prometheus"
  type        = number
  default     = 9090
}

variable "grafana_port" {
  description = "The port for Grafana"
  type        = number
  default     = 3000
}

variable "image_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
  default     = "latest"
}
