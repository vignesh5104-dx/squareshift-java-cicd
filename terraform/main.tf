resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "springboot_app" {
  name       = "springboot-app"
  namespace  = kubernetes_namespace.app_ns.metadata[0].name
  chart      = "../helm/springboot-app"
  version    = "0.1.0"
  create_namespace = false

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

