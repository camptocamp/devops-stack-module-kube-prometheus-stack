# This null_resource is required otherwise Terraform would try to read the resource group data and/or the storage 
# account even if they were not created yet. 
resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

data "azurerm_resource_group" "node_resource_group" {
  count = var.metrics_storage != null ? 1 : 0

  name = var.metrics_storage.managed_identity_node_rg_name

  depends_on = [
    resource.null_resource.dependencies
  ]
}

data "azurerm_storage_container" "container" {
  count = var.metrics_storage != null ? 1 : 0

  name                 = var.metrics_storage.container
  storage_account_name = var.metrics_storage.storage_account

  depends_on = [
    resource.null_resource.dependencies
  ]
}

resource "azurerm_user_assigned_identity" "prometheus" {
  count = var.metrics_storage != null ? 1 : 0

  name                = "prometheus"
  resource_group_name = data.azurerm_resource_group.node_resource_group[0].name
  location            = data.azurerm_resource_group.node_resource_group[0].location
}

resource "azurerm_role_assignment" "storage_contributor" {
  count = var.metrics_storage != null ? 1 : 0

  scope                = data.azurerm_storage_container.container[0].resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.prometheus[0].principal_id
}

resource "azurerm_federated_identity_credential" "prometheus" {
  count = var.metrics_storage != null ? 1 : 0

  name                = "prometheus"
  resource_group_name = data.azurerm_resource_group.node_resource_group[0].name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.metrics_storage.managed_identity_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.prometheus[0].id
  subject             = "system:serviceaccount:kube-prometheus-stack:kube-prometheus-stack-prometheus"
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

  alertmanager_enabled            = var.alertmanager_enabled
  grafana_enabled                 = var.grafana_enabled
  prometheus_enabled              = var.prometheus_enabled
  resources                       = var.resources
  oidc                            = var.oidc
  metrics_storage_enabled         = var.metrics_storage != null
  dataproxy_timeout               = var.dataproxy_timeout
  alertmanager_deadmanssnitch_url = var.alertmanager_deadmanssnitch_url
  alertmanager_slack_routes       = var.alertmanager_slack_routes

  helm_values = concat(local.helm_values, var.helm_values)
}
