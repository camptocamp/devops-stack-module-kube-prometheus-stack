variable "metrics_storage" {
  description = "MinIO S3 bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    bucket_name       = string
    endpoint          = string
    access_key        = string
    secret_access_key = string
  })
  # Since this variable is not mandatory, we provide defaults with empty strings. Note these strings are empty instead
  # of `null` because we Terraform does not like when we try to instert null values inside of strings, which we do when
  # parsing some of these values inside of a string to create a new one.
  default = {
    bucket_name       = ""
    endpoint          = ""
    access_key        = ""
    secret_access_key = ""
  }
  sensitive = true
}
