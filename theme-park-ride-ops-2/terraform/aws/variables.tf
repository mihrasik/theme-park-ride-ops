variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "theme-park-ride-ops-cluster"
}

variable "node_instance_type" {
  description = "The EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "db_username" {
  description = "The username for the MariaDB database"
  type        = string
}

variable "db_password" {
  description = "The password for the MariaDB database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the MariaDB database"
  type        = string
  default     = "theme_park_db"
}