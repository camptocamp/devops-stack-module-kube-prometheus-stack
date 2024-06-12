locals {
  # We use the try() function to avoid errors here when we deactivate the metrics storage by setting the 
  # `metrics_storage` variable to `null`.
  iam_role_arn = try(var.metrics_storage.create_role ? module.iam_assumable_role_kube_prometheus_stack.iam_role_arn : var.metrics_storage.iam_role_arn, null)

  helm_values = var.metrics_storage != null ? [{
    metrics_storage = var.metrics_storage != null ? {
      type = "s3"
      config = {
        bucket   = "${data.aws_s3_bucket.kube_prometheus_stack[0].id}"
        endpoint = "s3.${data.aws_s3_bucket.kube_prometheus_stack[0].region}.amazonaws.com"
      }
    } : null

    kube-prometheus-stack = {
      prometheus = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = local.iam_role_arn
          }
        }
      }
    }
  }] : []
}
