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
  default     = "v11.1.1" # x-release-please-version
}

variable "secrets_names" {
  description = "Name of the `ClusterSecretStore` used by the External Secrets Operator and the names of the secrets required for this module."
  type = object({
    cluster_secret_store_name = string
    kube_prometheus_stack = object({
      grafana_admin_credentials  = string
      metrics_storage            = string
      oauth2_proxy_cookie_secret = string
      oidc_client_secret         = string
    })
  })
  nullable = false
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

variable "alertmanager_enabled" {
  description = "Boolean to activate Alertmanager."
  type        = bool
  default     = true
  nullable    = false
}

variable "grafana_enabled" {
  description = "Boolean to activate Grafana."
  type        = bool
  default     = true
  nullable    = false
}

variable "prometheus_enabled" {
  description = "Boolean to activate Prometheus."
  type        = bool
  default     = true
  nullable    = false
}

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

variable "oidc" {
  description = <<-EOT
    OIDC settings to configure the access to the web interfaces of Prometheus, Alertmanager and Grafana.

    Most of the parameters are self-explanatory, but the `oauth2_proxy_extra_args` and `generic_oauth_extra_args` need some explanation:
    - `oauth2_proxy_extra_args`: list of strings to pass extra arguments to the OAuth2 Proxy used for the Prometheus and Alertmanager interfaces;
    - `generic_oauth_extra_args`: map of strings to pass extra parameters to the OIDC configuration for Grafana; you can pass any of the parameters listed in https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/generic-oauth/#configuration-options[this table] on the Grafana documentation, except the ones already configured by our module in the `locals.tf`.
  EOT
  type = object({
    issuer_url               = string
    oauth_url                = string
    token_url                = string
    api_url                  = string
    client_id                = string
    oauth2_proxy_extra_args  = optional(list(string), [])
    generic_oauth_extra_args = optional(map(string), {})
  })
  nullable = false
}

variable "metrics_storage_enabled" {
  description = "Boolean to activate the Thanos sidecar and data source, depending if the variants receive said configuration and pass it to the main module. *This variable is only meant to be used by the variants when calling the main module.*"
  type        = bool
  default     = false
}

variable "dataproxy_timeout" {
  description = "Variable to set the time when a query times out. This applies to all the Grafana's data sources and can be manually configured per data source if desired."
  type        = number
  default     = 30
}

variable "alertmanager_deadmanssnitch_url" {
  description = "URL of a Dead Man's Snitch service Alertmanager should report to (by default this reporting is disabled)."
  type        = string
  default     = null
}

variable "alertmanager_slack_routes" {
  description = <<-EOT
    List of objects configuring routing of alerts to Slack channels.

    Each object should have the following attributes:
    * `name`: name of the configured route.
    * `channel`: channel where the alerts will be sent (with '#').
    * `api_url`: Slack URL you received when configuring a webhook integration.
    * `matchers`: list of strings for filtering which alerts will be sent.
    * `continue`: whether an alert should continue matching subsequent sibling nodes.
  EOT
  type = list(object({
    name     = string
    channel  = string
    api_url  = string
    matchers = list(string)
    continue = bool
  }))
  default = []
}
