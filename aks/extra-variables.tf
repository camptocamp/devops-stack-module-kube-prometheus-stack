variable "metrics_storage" {
  description = "Azure Blob Storage configuration values for the storage container where the archived metrics will be stored."
  type = object({
    container       = string
    storage_account = string
    use_managed_identity = object({
      enabled      = bool
      node_rg_name = optional(string, null)
    })
    storage_account_key = optional(string, null)
  })

  validation {
    condition     = try(var.metrics_storage.use_managed_identity.enabled == (var.metrics_storage.storage_account_key == null), true)
    error_message = "Setting storage_account_key and using a managed identity are mutually exclusive."
  }

  validation {
    condition     = try(var.metrics_storage.use_managed_identity.enabled == (var.metrics_storage.use_managed_identity.node_rg_name != null), true)
    error_message = "use_managed_identity.node_rg_name must only be set when using a managed identity."
  }
  default = null
}
