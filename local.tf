locals {
  helm_values = [{
    kube-prometheus-stack = {
      global = {
        rbac = {
          pspEnabled = false
        }
      }
      kube-state-metrics = {
        resources = {
          limits = {
            memory = "32Mi"
          }
          requests = {
            cpu = "10m"
            memory = "16Mi"
          }
        }
        podSecurityPolicy = {
          enabled = false
        }
      }
      prometheus-node-exporter = {
        resources = {
          limits = {
            memory = "24Mi"
          }
          requests = {
            cpu = "10m"
            memory = "16Mi"
          }
        }
        rbac = {
          pspEnabled = false
        }
      }
      prometheusOperator = {
        resources = {
          limits = {
            memory = "48Mi"
          }
          requests = {
            cpu = "100m"
            memory = "32Mi"
          }
        }
      }
    }
  }]


  grafana_defaults = {
    enable                   = true
    generic_oauth_extra_args = {}
    domain                   = "grafana.apps.${var.cluster_name}.${var.base_domain}"
    admin_password           = random_password.grafana_admin_password.result
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

  default_yaml = [templatefile("${path.module}/values.tmpl.yaml", {
    oidc           = var.oidc,
    base_domain    = var.base_domain,
    cluster_issuer = var.cluster_issuer,

    cookie_secret    = random_password.oauth2_cookie_secret.result
    metrics_archives = var.metrics_archives

    alertmanager = local.alertmanager,
    grafana      = local.grafana,
    prometheus   = local.prometheus,
  })]
  all_yaml = concat(local.default_yaml, var.extra_yaml)
}

resource "random_password" "grafana_admin_password" {
  length  = 16
  special = false
}
