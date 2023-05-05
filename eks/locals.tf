locals {
  helm_values = var.metrics_storage != null ? ( var.metrics_storage.iam_role_arn != "" ? [{
    kube-prometheus-stack = {
      prometheus = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_storage.iam_role_arn
          }
        }
      }
    }
  }] : []) : []
}
