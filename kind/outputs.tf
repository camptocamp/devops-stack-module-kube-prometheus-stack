output "id" {
  value = module.kube-prometheus-stack.id
}

output "grafana_admin_password" {
  description = "The admin password for Grafana."
  value       = module.kube-prometheus-stack.grafana_admin_password
  sensitive   = true
}

output "grafana_enabled" {
  value = module.kube-prometheus-stack.grafana_enabled
}

output "prometheus_enabled" {
  value = module.kube-prometheus-stack.prometheus_enabled
}

output "alertmanager_enabled" {
  value = module.kube-prometheus-stack.alertmanager_enabled
}
