output "namespace" {
  value = var.namespace
}

output "kubeconfig" {
  description = "Kubeconfig path used by Terraform"
  value       = var.kubeconfig
}