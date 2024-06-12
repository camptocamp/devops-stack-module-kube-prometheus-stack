locals {
  helm_values = [{
    metrics_storage = var.metrics_storage != null ? {
      type = "s3"
      config = {
        bucket   = var.metrics_storage.bucket_name
        endpoint = "sos-${var.metrics_storage.region}.exo.io"
      }
    } : null
  }]
}
