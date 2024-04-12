variable "metrics_storage" {
  description = "Azure Blob Storage configuration for metric archival."
  type = object({
    container                        = string
    storage_account                  = string
    managed_identity_node_rg_name    = optional(string, null)
    managed_identity_oidc_issuer_url = optional(string, null)
    storage_account_key              = optional(string, null)
  })

  validation {
    condition     = try((var.metrics_storage.managed_identity_node_rg_name == null && var.metrics_storage.managed_identity_oidc_issuer_url == null) != (var.metrics_storage.storage_account_key == null), true)
    error_message = "You can either set the variables for the managed identity or use storage account key, not both at the same time."
  }

  validation {
    condition     = try((var.metrics_storage.managed_identity_node_rg_name == null) == (var.metrics_storage.managed_identity_oidc_issuer_url == null), true)
    error_message = "When using the managed identity, both `managed_identity_node_rg_name` and `managed_identity_oidc_issuer_url` are required."
  }

  default = null
}
