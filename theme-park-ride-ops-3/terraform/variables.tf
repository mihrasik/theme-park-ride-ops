theme-park-ride-ops/theme-park-ride-ops/terraform/variables.tf
variable "app_env" {
  description = "The environment in which the application is running (e.g., local, production)"
  type        = string
  default     = "local"
}

variable "db_host" {
  description = "The hostname of the database"
  type        = string
}

variable "db_port" {
  description = "The port on which the database is running"
  type        = number
  default     = 3306
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_pass" {
  description = "The password for the database"
  type        = string
}

variable "registry_url" {
  description = "The Docker registry URL for pushing images"
  type        = string
}

variable "argocd_namespace" {
  description = "The namespace where ArgoCD is installed"
  type        = string
}

variable "themepark_namespace" {
  description = "The namespace for the theme park application"
  type        = string
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