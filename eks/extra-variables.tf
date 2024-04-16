variable "metrics_storage" {
  description = "AWS S3 bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    bucket_id               = string
    create_role             = bool
    iam_role_arn            = optional(string, null)
    cluster_oidc_issuer_url = optional(string, null)
  })

  default = null

  validation {
    # We use the try() function to avoid errors here when we deactivate the metrics storage by setting the 
    # `metrics_storage` variable to `null`.
    condition     = try(var.metrics_storage.create_role ? var.metrics_storage.cluster_oidc_issuer_url != null : var.metrics_storage.iam_role_arn != null, true)
    error_message = "If you want to create a role, you need to provide the OIDC issuer's URL for the EKS cluster. Otherwise, you need to provide the ARN of the IAM role you created."
  }
}
