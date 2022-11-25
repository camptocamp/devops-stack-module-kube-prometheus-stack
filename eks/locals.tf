locals {
  helm_values = (var.metrics_storage.iam_role_arn != "") ? [{
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

  metrics_storage_main = {
    thanos_enabled = var.metrics_storage.enabled
    storage_config = {
      type = "s3"
      config = {
        bucket   = "${var.metrics_storage.bucket_id}"
        endpoint = "s3.${var.metrics_storage.region}.amazonaws.com"
      }
    }
  }
}
