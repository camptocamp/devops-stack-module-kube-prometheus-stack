locals {

  helm_values = [{
    metrics_storage = var.metrics_storage != null ? {
      type = "s3"
      config = {
        bucket   = var.metrics_storage.bucket_name
        endpoint = var.metrics_storage.endpoint
        insecure = var.metrics_storage.insecure
      }
    } : null
  }]
}
