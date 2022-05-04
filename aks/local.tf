locals {
  helm_values = [{
    kube-prometheus-stack = {
      prometheus = {
        azureIdentity = {
          resourceID = azurerm_user_assigned_identity.kube_prometheus_stack_prometheus.id
          clientID = azurerm_user_assigned_identity.kube_prometheus_stack_prometheus.client_id
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
}
