#######################
## Standard variables
#######################

variable "cluster_name" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "cluster_issuer" {
  type    = string
  default = "ca-issuer"
}

variable "namespace" {
  type    = string
  default = "kube-prometheus-stack"
}

variable "helm_values" {
  description = "Helm values, passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "dependency_ids" {
  type = map(string)

  default = {}
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v1.0.0" # x-release-please-version
}

variable "app_autosync" {
  description = "Autosync option configuration for argocd application"
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
  description = "Alertmanager settings"
  type        = any
  default     = {}
}

variable "metrics_archives" {
  description = "Thanos S3 bucket settings"
  type        = any
  default     = {}
}
