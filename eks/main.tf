module "kube-prometheus-stack" {
  source = "../"

  cluster_name     = var.cluster_name
  argocd_namespace = var.argocd_namespace
  base_domain      = var.base_domain
  cluster_issuer   = var.cluster_issuer
  metrics_archives = var.metrics_archives

  prometheus = {
    oidc = var.prometheus.oidc
  }
  alertmanager = {
    oidc = var.alertmanager.oidc
  }
  grafana = {
    oidc = var.grafana.oidc
  }

  helm_values = concat(local.helm_values, var.helm_values)
}
