locals {
  helm_values = can(var.metrics_archives.bucket_config) ? [{
    kube-prometheus-stack = {
      prometheus = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = var.metrics_archives.iam_role_arn
          }
        }
      }
    }
  }] : []
}
