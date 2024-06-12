locals {
  helm_values = [{
    metrics_storage = var.metrics_storage != null ? {

      type = "AZURE"
      config = {
        container       = var.metrics_storage.container
        storage_account = var.metrics_storage.storage_account
      }
    } : null

    kube-prometheus-stack = {
      prometheus = var.metrics_storage != null ? {
        serviceAccount = {
          annotations = {
            "azure.workload.identity/client-id" = resource.azurerm_user_assigned_identity.prometheus[0].client_id
          }
        }
        prometheusSpec = {
          podMetadata = {
            labels = {
              "azure.workload.identity/use" = "true"
            }
          }
        }
      } : null
    }
  }]
}
