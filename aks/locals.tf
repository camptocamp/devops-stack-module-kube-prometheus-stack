locals {
  use_managed_identity = try(var.metrics_storage.managed_identity_node_rg_name != null, false)

  metrics_storage = var.metrics_storage == null ? null : {
    storage_config = {
      type = "AZURE"
      config = merge(
        {
          container       = var.metrics_storage.container
          storage_account = var.metrics_storage.storage_account
        },
        local.use_managed_identity ? null : {
          storage_account_key = var.metrics_storage.storage_account_key
        }
      )
    }
  }

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
