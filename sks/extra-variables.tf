variable "metrics_storage" {
  description = "Exoscale SOS bucket configuration values for the bucket where the archived metrics will be stored."
  type = object({
    bucket_name = string
    region      = string
    access_key  = string
    secret_key  = string
  })
  default = null
}
