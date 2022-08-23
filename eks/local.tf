locals {
  helm_values = [{
    kube-prometheus-stack = {
      prometheus = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = can(var.metrics_archives.bucket_config) ? var.metrics_archives.iam_role_arn : "thanos_not_deployed"
          }
        }
      }
    }
  }]
}
# TODO replace the condition above with a merge or something!