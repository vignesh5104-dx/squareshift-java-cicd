variable "kubeconfig" {
  description = "Path to kubeconfig file for Rancher Desktop"
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Namespace for the Spring Boot app"
  type        = string
  default     = "springboot-app"
}

variable "image_repository" {
  description = "Container image repository"
  type        = string
  default     = "your-docker-username/springboot-app"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

