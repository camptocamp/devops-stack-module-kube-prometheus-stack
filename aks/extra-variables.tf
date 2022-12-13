variable "cluster_resource_group_name" {
  description = "The Resource Group for the kube-prometheus-stack managed identity creation."
  type        = string
}

variable "metrics_storage" {
  description = "Azure Blob Storage configuration values for the storage container where the archived metrics will be stored."
  type = object({
    container           = string
    storage_account     = string
    storage_account_key = string
  })
  default = null
}
