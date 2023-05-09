locals {
  helm_values = var.metrics_storage != null ? [{
    kube-prometheus-stack = {
      prometheus = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_storage.iam_role_arn
          }
        }
      }
    }
  }] : []
}
