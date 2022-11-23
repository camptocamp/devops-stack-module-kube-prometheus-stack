locals {
  helm_values = can(var.metrics_storage.iam_role_arn) ? [{
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

  metrics_storage_main = can(var.metrics_storage.bucket_id) ? {
    # This flag is needed in order to conditionally create a Kubernetes secret on the main module.
    thanos_enabled = true

    bucket_config = {
      type = "s3"
      config = {
        bucket   = "${var.metrics_storage.bucket_id}"
        endpoint = "s3.${var.metrics_storage.region}.amazonaws.com"
      }
    }
  } : {}
}
