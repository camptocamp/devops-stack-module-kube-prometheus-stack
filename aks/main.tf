data "azurerm_resource_group" "node" {
  count = try(var.metrics_storage.use_managed_identity.enabled, false) ? 1 : 0

  name = var.metrics_storage.use_managed_identity.node_rg_name
}

data "azurerm_storage_container" "container" {
  count = try(var.metrics_storage.use_managed_identity.enabled, false) ? 1 : 0

  name                 = var.metrics_storage.container
  storage_account_name = var.metrics_storage.storage_account
}

resource "azurerm_user_assigned_identity" "prometheus" {
  count = try(var.metrics_storage.use_managed_identity.enabled, false) ? 1 : 0

  resource_group_name = data.azurerm_resource_group.node[0].name
  location            = data.azurerm_resource_group.node[0].location
  name                = "prometheus"
}

resource "azurerm_role_assignment" "contributor" {
  count = try(var.metrics_storage.use_managed_identity.enabled, false) ? 1 : 0

  scope                = data.azurerm_storage_container.container[0].resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.prometheus[0].principal_id
}

module "kube-prometheus-stack" {
  source = "../"

  cluster_name     = var.cluster_name
  base_domain      = var.base_domain
  argocd_namespace = var.argocd_namespace
  target_revision  = var.target_revision
  cluster_issuer   = var.cluster_issuer
  namespace        = var.namespace
  app_autosync     = var.app_autosync
  dependency_ids   = var.dependency_ids

  prometheus   = var.prometheus
  alertmanager = var.alertmanager
  grafana      = var.grafana

  metrics_storage_main = var.metrics_storage != null ? { storage_config = merge({ type = "AZURE" }, { config = merge({
    container       = var.metrics_storage.container
    storage_account = var.metrics_storage.storage_account
    }, var.metrics_storage.use_managed_identity.enabled ? null : {
    storage_account_key = var.metrics_storage.storage_account_key
  }) }) } : null

  helm_values = concat(local.helm_values, var.helm_values)
}

