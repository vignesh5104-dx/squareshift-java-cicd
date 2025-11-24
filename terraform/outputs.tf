output "namespace" {
  description = "The namespace used for deployment"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "kubeconfig" {
  description = "Kubeconfig path used by Terraform"
  value       = var.kubeconfig
}