output "namespace" {
  value = kubernetes_namespace.example.metadata[0].name
}

output "service_url" {
  value = "http://localhost:${kubernetes_service.nginx_service.spec[0].port[0].node_port}"
}
