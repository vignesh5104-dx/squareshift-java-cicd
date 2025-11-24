resource "helm_release" "springboot_app" {
  name       = "springboot-app"
  namespace  = var.namespace
  create_namespace = true

  chart      = "../helm"
  version    = "0.1.0"

  force_update = true     # <---- important
  cleanup_on_fail = true  # <---- auto fixes failed states
  atomic = true           # <---- safe upgrades

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "replicaCount"
    value = "2"
  }

  set {
    name  = "autoscaling.enabled"
    value = "true"
  }
}
