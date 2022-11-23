module "kube-prometheus-stack" {
  source = "../"

  cluster_name     = var.cluster_name
  argocd_namespace = var.argocd_namespace
  base_domain      = var.base_domain
  cluster_issuer   = var.cluster_issuer
  namespace        = var.namespace
  dependency_ids   = var.dependency_ids

  prometheus       = var.prometheus
  alertmanager     = var.alertmanager
  grafana          = var.grafana

  metrics_archives = local.metrics_storage_main

  helm_values = concat(local.helm_values, var.helm_values)
}
