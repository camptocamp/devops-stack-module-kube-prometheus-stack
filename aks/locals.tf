locals {
  helm_values = [{
    kube-prometheus-stack = {
      prometheus = {
        azureIdentity = {
          resourceID = azurerm_user_assigned_identity.kube_prometheus_stack_prometheus.id
          clientID   = azurerm_user_assigned_identity.kube_prometheus_stack_prometheus.client_id
        }
        prometheusSpec = {
          podMetadata = {
            labels = {
              aadpodidbinding = "kube-prometheus-stack-prometheus"
            }
          }
        }
      }
    }
  }]

  metrics_storage_main = {
    thanos_enabled = var.metrics_storage.enabled
    storage_config = {
      type = "AZURE"
      config = {
        container           = var.metrics_storage.container_name
        storage_account     = var.metrics_storage.storage_account_name
        storage_account_key = var.metrics_storage.storage_account_key
      }
    }
  }
}
