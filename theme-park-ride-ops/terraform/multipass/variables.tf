variable "multipass_instance_count" {
  description = "Number of Multipass instances to create for the Kubernetes cluster"
  type        = number
  default     = 3
}

variable "multipass_memory" {
  description = "Memory allocated for each Multipass instance (in MB)"
  type        = number
  default     = 2048
}

variable "multipass_cpu" {
  description = "Number of CPUs allocated for each Multipass instance"
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Kubernetes version to install on the Multipass instances"
  type        = string
  default     = "1.21.0"
}

variable "docker_version" {
  description = "Docker version to install on the Multipass instances"
  type        = string
  default     = "20.10.7"
}

variable "helm_version" {
  description = "Helm version to install on the Multipass instances"
  type        = string
  default     = "3.6.3"
}

variable "argocd_version" {
  description = "ArgoCD version to install on the Multipass instances"
  type        = string
  default     = "1.8.1"
}