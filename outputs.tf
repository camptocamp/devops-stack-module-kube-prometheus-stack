output "grafana_admin_password" {
  description = "The admin password for Grafana."
  value       = local.grafana.admin_password
  sensitive   = true
}
