variable "metrics_storage" {
  description = "Azure Blob Storage configuration values for the storage container where the archived metrics will be stored."
  type = object({
    container                     = string
    storage_account               = string
    managed_identity_node_rg_name = optional(string, null)
    storage_account_key           = optional(string, null)
  })

  validation {
    condition     = try((var.metrics_storage.managed_identity_node_rg_name == null) != (var.metrics_storage.storage_account_key == null), true)
    error_message = "You must set one (and only one) of these attributes: managed_identity_node_rg_name, storage_account_key."
  }

  default = null
}
