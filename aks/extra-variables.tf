variable "node_resource_group_name" {
  description = "The Resource Group of the Managed Kubernetes Cluster."
  type        = string
}

variable "metrics_storage" {
  description = "Azure Blob Storage configuration values for the storage container where the archived metrics will be stored."
  type = object({
    container_name       = string
    storage_account_name = string
    storage_account_key  = string
  })
  # Since this variable is not mandatory, we provide defaults with empty strings. Note these strings are empty instead
  # of `null` because we Terraform does not like when we try to instert null values inside of strings, which we do when
  # parsing some of these values inside of a string to create a new one.
  default = {
    container_name       = ""
    storage_account_name = ""
    storage_account_key  = ""
  }
  sensitive = true
}
