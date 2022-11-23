variable "metrics_storage" {
  description = "value"
  type = object({
    bucket_id    = string
    region       = string
    iam_role_arn = string
  })
  default = {
    bucket_id    = null
    region       = null
    iam_role_arn = null
  }
}
