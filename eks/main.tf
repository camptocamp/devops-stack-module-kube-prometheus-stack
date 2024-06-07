data "aws_s3_bucket" "kube_prometheus_stack" {
  count = var.metrics_storage != null ? 1 : 0

  bucket = var.metrics_storage.bucket_id
}

data "aws_iam_policy_document" "kube_prometheus_stack" {
  count = var.metrics_storage != null ? (var.metrics_storage.create_role ? 1 : 0) : 0

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      data.aws_s3_bucket.kube_prometheus_stack[0].arn,
      format("%s/*", data.aws_s3_bucket.kube_prometheus_stack[0].arn),
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "kube_prometheus_stack" {
  count = var.metrics_storage != null ? (var.metrics_storage.create_role ? 1 : 0) : 0

  name_prefix = "kube-prometheus-stack-s3-"
  description = "IAM policy for the kube-prometheus-stack to access the S3 bucket named ${data.aws_s3_bucket.kube_prometheus_stack[0].id}"
  policy      = data.aws_iam_policy_document.kube_prometheus_stack[0].json
}

module "iam_assumable_role_kube_prometheus_stack" {
  source                     = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                    = "~> 5.0"
  create_role                = var.metrics_storage != null ? var.metrics_storage.create_role : false
  number_of_role_policy_arns = 1
  role_name_prefix           = "kube-prometheus-stack-s3-"

  # We use the try() function to avoid errors here when we deactivate the metrics storage by setting the 
  # `metrics_storage` variable to `null`.
  provider_url     = try(trimprefix(var.metrics_storage.cluster_oidc_issuer_url, "https://"), "")
  role_policy_arns = [try(resource.aws_iam_policy.kube_prometheus_stack[0].arn, null)]

  # List of ServiceAccounts that have permission to attach to this IAM role
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:kube-prometheus-stack:kube-prometheus-stack-prometheus"
  ]
}

module "kube-prometheus-stack" {
  source = "../"

  cluster_name           = var.cluster_name
  base_domain            = var.base_domain
  subdomain              = var.subdomain
  argocd_project         = var.argocd_project
  argocd_labels          = var.argocd_labels
  destination_cluster    = var.destination_cluster
  target_revision        = var.target_revision
  cluster_issuer         = var.cluster_issuer
  deep_merge_append_list = var.deep_merge_append_list
  app_autosync           = var.app_autosync
  dependency_ids         = var.dependency_ids

  resources = var.resources

  prometheus   = var.prometheus
  alertmanager = var.alertmanager
  grafana      = var.grafana

  metrics_storage_main = local.metrics_storage

  helm_values = concat(local.helm_values, var.helm_values)
}
