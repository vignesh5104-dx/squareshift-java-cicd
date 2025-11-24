output "namespace" {
  value = helm_release.springboot_app.namespace
}

output "release_name" {
  value = helm_release.springboot_app.name
}
