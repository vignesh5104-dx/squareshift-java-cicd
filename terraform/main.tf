resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}
