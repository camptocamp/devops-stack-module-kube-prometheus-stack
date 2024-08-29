resource "null_resource" "check_metrics_storage_secret" {
  count = var.metrics_storage != null ? 1 : 0

  lifecycle {
    precondition {
      condition     = var.metrics_storage != null && var.secrets_names.kube_prometheus_stack.metrics_storage != null
      error_message = "The name of the secret where to recover the access and secret keys for the bucket must be defined in the `secret_names` variable."
    }
  }
}

module "kube-prometheus-stack" {
  source = "../"

  cluster_name           = var.cluster_name
  base_domain            = var.base_domain
  subdomain              = var.subdomain
  enable_short_domain    = var.enable_short_domain
  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  secrets_names          = var.secrets_names
  cluster_issuer         = var.cluster_issuer
  deep_merge_append_list = var.deep_merge_append_list
  app_autosync           = var.app_autosync
  dependency_ids         = var.dependency_ids

  alertmanager_enabled                   = var.alertmanager_enabled
  grafana_enabled                        = var.grafana_enabled
  prometheus_enabled                     = var.prometheus_enabled
  resources                              = var.resources
  oidc                                   = var.oidc
  metrics_storage_enabled                = var.metrics_storage != null
  dataproxy_timeout                      = var.dataproxy_timeout
  alertmanager_enable_deadmanssnitch_url = var.alertmanager_enable_deadmanssnitch_url
  alertmanager_slack_routes              = var.alertmanager_slack_routes

  helm_values = concat(local.helm_values, var.helm_values)
}
