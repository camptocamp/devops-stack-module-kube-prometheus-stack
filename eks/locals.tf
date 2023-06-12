locals {
  metrics_storage = var.metrics_storage != null ? {
    storage_config = {
      type = "s3"
      config = {
        bucket   = "${var.metrics_storage.bucket_id}"
        endpoint = "s3.${var.metrics_storage.region}.amazonaws.com"
      }
    }
  } : null

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
