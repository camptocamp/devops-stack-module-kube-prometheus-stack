variable "metrics_storage" {
  description = "AWS S3 bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    enabled      = bool
    bucket_id    = string
    region       = string
    iam_role_arn = string
  })
  # Since this variable is not mandatory, we provide defaults with empty strings. Note these strings are empty instead
  # of `null` because we Terraform does not like when we try to insert null values inside of strings, which we do when
  # parsing some of these values inside of a string to create a new one.
  default = {
    enabled      = false
    bucket_id    = ""
    region       = ""
    iam_role_arn = ""
  }
}
