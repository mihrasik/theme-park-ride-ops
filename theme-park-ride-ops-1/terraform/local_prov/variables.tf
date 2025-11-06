variable "k8s_cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  default     = "theme-park-ride-ops-cluster"
}

variable "k8s_node_count" {
  description = "The number of nodes in the Kubernetes cluster"
  type        = number
  default     = 3
}

variable "k8s_node_size" {
  description = "The size of the nodes in the Kubernetes cluster"
  type        = string
  default     = "t3.medium"
}

variable "docker_image_repo" {
  description = "Docker image repository for the microservices"
  type        = string
  default     = "your-dockerhub-username/theme-park-ride-ops"
}

variable "mariadb_root_password" {
  description = "Root password for MariaDB"
  type        = string
  sensitive   = true
}

variable "mariadb_database" {
  description = "Database name for the application"
  type        = string
  default     = "theme_park_db"
}

variable "mariadb_user" {
  description = "Username for the MariaDB database"
  type        = string
  default     = "theme_park_user"
}

variable "mariadb_user_password" {
  description = "Password for the MariaDB user"
  type        = string
  sensitive   = true
}