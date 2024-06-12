variable "metrics_storage" {
  description = "Azure Blob Storage configuration for metric archival."
  type = object({
    container                        = string
    storage_account                  = string
    managed_identity_node_rg_name    = string
    managed_identity_oidc_issuer_url = string
  })

  default = null
}
