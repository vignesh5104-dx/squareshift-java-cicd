variable "namespace" {
  description = "Namespace where the app will run"
  type        = string
  default     = "springboot-app"
}

variable "kubeconfig" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}
