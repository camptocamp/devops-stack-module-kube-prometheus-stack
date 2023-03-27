locals {
  helm_values = [{
    kube-prometheus-stack = {
      prometheus = {
        prometheusSpec = merge(try(var.metrics_storage.use_managed_identity.enabled, false) ? {
          podMetadata = {
            labels = {
              aadpodidbinding = "prometheus"
            }
          }
        } : null, {})
      }
    }
    }, try(var.metrics_storage.use_managed_identity.enabled, false) ? {
    azureIdentity = {
      resourceID = azurerm_user_assigned_identity.prometheus[0].id
      clientID   = azurerm_user_assigned_identity.prometheus[0].client_id
    }
  } : null]
}
