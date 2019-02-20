output "external_host_name" {
  depends_on  = ["kubernetes_service.service"]
  value       = "${kubernetes_service.service.load_balancer_ingress.0.hostname}"
}