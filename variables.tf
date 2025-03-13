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

variable "subdomain" {
  description = "Subdomain of the cluster. Value used for the ingress' URL of the application."
  type        = string
  default     = "apps"
  nullable    = false
}

variable "argocd_project" {
  description = "Name of the Argo CD AppProject where the Application should be created. If not set, the Application will be created in a new AppProject only for this Application."
  type        = string
  default     = null
}

variable "argocd_labels" {
  description = "Labels to attach to the Argo CD Application resource."
  type        = map(string)
  default     = {}
}

variable "destination_cluster" {
  description = "Destination cluster where the application should be deployed."
  type        = string
  default     = "in-cluster"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v14.2.0" # x-release-please-version
}

variable "cluster_issuer" {
  description = "SSL certificate issuer to use. Usually you would configure this value as `letsencrypt-staging` or `letsencrypt-prod` on your root `*.tf` files."
  type        = string
  default     = "selfsigned-issuer"
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

variable "resources" {
  description = <<-EOT
    Resource limits and requests for kube-prometheus-stack's components. Follow the style on https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/[official documentation] to understand the format of the values.

    IMPORTANT: These are not production values. You should always adjust them to your needs.
  EOT
  type = object({

    prometheus = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "512Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "1024Mi")
      }), {})
    }), {})

    prometheus_operator = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    thanos_sidecar = optional(object({
      requests = optional(object({
        cpu    = optional(string, "100m")
        memory = optional(string, "256Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    alertmanager = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "256Mi")
      }), {})
    }), {})

    kube_state_metrics = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

    grafana = optional(object({
      requests = optional(object({
        cpu    = optional(string, "250m")
        memory = optional(string, "512Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "512Mi")
      }), {})
    }), {})

    node_exporter = optional(object({
      requests = optional(object({
        cpu    = optional(string, "50m")
        memory = optional(string, "128Mi")
      }), {})
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string, "128Mi")
      }), {})
    }), {})

  })
  default = {}
}

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

    * `enabled`: whether Alertmanager is deployed or not (default: `true`).
    * `domain`: domain name configured in the Ingress (default: `prometheus.apps.$${var.cluster_name}.$${var.base_domain}`).
    * `oidc`: OIDC configuration to be used by OAuth2 Proxy in front of Alertmanager (**required**).
    * `deadmanssnitch_url`: url of a Dead Man's Snitch service Alertmanager should report to (by default this reporing is disabled).
    * `slack_routes`: list of objects configuring routing of alerts to Slack channels, with the following attributes:
      * `name`: name of the configured route.
      * `channel`: channel where the alerts will be sent (with '#').
      * `api_url`: slack URL you received when configuring a webhook integration.
      * `matchers`: list of strings for filtering which alerts will be sent.
      * `continue`: whether an alert should continue matching subsequent sibling nodes.
  EOT
  type        = any
  default     = {}
}

variable "metrics_storage_main" {
  description = "Storage settings for the Thanos sidecar. Needs to be of type `any` because the structure is different depending on the variant used."
  type        = any
  default     = {}
}

variable "dataproxy_timeout" {
  description = "Variable to set the time when a query times out. This applies to all the Grafana's data sources and can be manually configured per data source if desired."
  type        = number
  default     = 30
}

variable "alertmanager_storage_size" {
  description = "Default PVC size for Alertmanager data."
  type        = string
  default     = "10Gi"
}
