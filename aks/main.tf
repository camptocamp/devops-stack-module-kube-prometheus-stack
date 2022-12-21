data "azurerm_resource_group" "node_resource_group" {
  name = var.node_resource_group_name
}

resource "azurerm_user_assigned_identity" "kube_prometheus_stack_prometheus" {
  resource_group_name = data.azurerm_resource_group.node_resource_group.name
  location            = data.azurerm_resource_group.node_resource_group.location
  name                = "kube-prometheus-stack-prometheus"
}

module "kube-prometheus-stack" {
  source = "../"

  cluster_name     = var.cluster_name
  argocd_namespace = var.argocd_namespace
  app_autosync     = var.app_autosync
  target_revision  = var.target_revision
  base_domain      = var.base_domain
  cluster_issuer   = var.cluster_issuer
  namespace        = var.namespace
  dependency_ids   = var.dependency_ids

  prometheus   = var.prometheus
  alertmanager = var.alertmanager
  grafana      = var.grafana

  metrics_storage_main = var.metrics_storage != null ? { storage_config = merge({ type = "AZURE" }, { config = var.metrics_storage }) } : null

  helm_values = concat(local.helm_values, var.helm_values)
}

