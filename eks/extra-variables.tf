variable "metrics_storage" {
  description = "AWS S3 bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    bucket_id    = string
    region       = string
    iam_role_arn = string
  })
  default = null
}
