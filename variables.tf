#######################
## Standard variables
#######################

variable "cluster_name" {
  description = "Name given to the cluster. Value used for naming some the resources created by the module."
  type        = string
}

variable "base_domain" {
  description = "Base domain of the cluster. Value used for the ingress' URL of the application."
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace used by Argo CD where the Application and AppProject resources should be created."
  type        = string
  default     = "argocd"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v3.2.0" # x-release-please-version
}

variable "cluster_issuer" {
  description = "SSL certificate issuer to use. Usually you would configure this value as `letsencrypt-staging` or `letsencrypt-prod` on your root `*.tf` files."
  type        = string
  default     = "ca-issuer"
}

variable "namespace" {
  description = "Namespace where the applications's Kubernetes resources should be created. Namespace will be created in case it doesn't exist."
  type        = string
  default     = "kube-prometheus-stack"
}

variable "helm_values" {
  description = "Helm chart value overrides. They should be passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "deep_merge_append_list" {
  description = "A boolean flag to enable/disable appending lists instead of overwriting them."
  type        = bool
  default     = false
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  type    = map(string)
  default = {}
}

#######################
## Module variables
#######################

variable "grafana" {
  description = "Grafana settings"
  type        = any
  default     = {}
}

variable "prometheus" {
  description = "Prometheus settings"
  type        = any
  default     = {}
}

variable "alertmanager" {
  description = <<-EOT
    Object containing Alertmanager settings. The following attributes are supported:

    * enabled: whether Alertmanager is deployed or not (default: `true`).
    * domain: domain name configured in the Ingress (default: `prometheus.apps.$${var.cluster_name}.$${var.base_domain}`).
    * oidc: OIDC configuration to be used by oauth2_proxy in front of Alertmanager (Mandatory).
    * dead_mans_snitch_url: url of a Dead Man's Snitch service Alertmanager should report to (by default this reporing is disabled).
    * slack_api_url: webhook URL you received when configuring an integration in Slack.
    * slack_routes: list of objects configuring routing of alerts to Slack channels, with the following attributes:
      * name: name of the configured route.
      * channel: channel where the alerts will be sent (with '#').
      * matchers: list of route matchers filtering which alerts will be sent.
  EOT
  type        = any
  default     = {}
}

variable "metrics_storage_main" {
  description = "Storage settings for the Thanos sidecar. Needs to be of type `any` because the structure is different depending on the provider used."
  type        = any
  default     = {}
}
