locals {
  helm_values = []

  metrics_storage_main = {
    thanos_enabled = (var.metrics_storage.bucket_name != "")
    storage_config = {
      type = "s3"
      config = {
        bucket     = "${var.metrics_storage.bucket_name}"
        endpoint   = "${var.metrics_storage.endpoint}"
        access_key = "${var.metrics_storage.access_key}"
        secret_key = "${var.metrics_storage.secret_access_key}"
      }
    }
  }
}
