variable "cluster_resource_group_name" {
variable "node_resource_group_name" {
  description = "The Resource Group of the Managed Kubernetes Cluster."
  type        = string
}
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
