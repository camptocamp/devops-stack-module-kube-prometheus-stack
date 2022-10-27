data "azurerm_resource_group" "this" {
  name = var.cluster_resource_group_name
}

resource "azurerm_user_assigned_identity" "kube_prometheus_stack_prometheus" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  name                = "kube-prometheus-stack-prometheus"
}

module "kube-prometheus-stack" {
  source = "../"

  cluster_name     = var.cluster_name
  oidc             = var.oidc
  argocd_namespace = var.argocd_namespace
  app_autosync     = var.app_autosync
  target_revision  = var.target_revision
  base_domain      = var.base_domain
  cluster_issuer   = var.cluster_issuer
  metrics_archives = var.metrics_archives

  helm_values = concat(local.helm_values, var.helm_values)
}
