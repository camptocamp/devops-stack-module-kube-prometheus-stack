locals {
  grafana_defaults = {
    enable                   = true
    generic_oauth_extra_args = {}
    domain                   = "grafana.apps.${var.cluster_name}.${var.base_domain}"
  }
  grafana = merge(
    local.grafana_defaults,
    var.grafana,
  )

  prometheus_defaults = {
    domain = "prometheus.apps.${var.cluster_name}.${var.base_domain}"
    enable = true
  }
  prometheus = merge(
    local.prometheus_defaults,
    var.prometheus,
  )

  alertmanager_defaults = {
    enable = true
    domain = "alertmanager.apps.${var.cluster_name}.${var.base_domain}"
  }
  alertmanager = merge(
    local.alertmanager_defaults,
    var.alertmanager,
  )
}
