resource "helm_release" "springboot_app" {
  name       = "springboot-app"
  namespace  = var.namespace
  chart      = "../helm"
  version    = "0.1.0"

  create_namespace = true

  atomic = false
  wait = false
  timeout = "600s"

  force_update = true
  cleanup_on_fail = true

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
