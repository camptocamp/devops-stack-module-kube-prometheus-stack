locals {
  use_managed_identity = try(var.metrics_storage.managed_identity_node_rg_name != null, false)

  helm_values = [{
    kube-prometheus-stack = {
      prometheus = {
        prometheusSpec = merge(local.use_managed_identity ? {
          podMetadata = {
            labels = {
              aadpodidbinding = "prometheus"
            }
          }
        } : null, {})
      }
    }
    }, local.use_managed_identity ? {
    azureIdentity = {
      resourceID = azurerm_user_assigned_identity.prometheus[0].id
      clientID   = azurerm_user_assigned_identity.prometheus[0].client_id
    }
  } : null]
}
