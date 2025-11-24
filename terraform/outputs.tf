output "namespace" {
  value = kubernetes_namespace.app_ns.metadata[0].name
}

output "release_name" {
  value = helm_release.springboot_app.name
}

