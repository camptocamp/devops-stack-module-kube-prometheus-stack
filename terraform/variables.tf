#######################
## Standard variables
#######################

variable "cluster_name" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "oidc" {
  type = any
}

variable "kubernetes" {
  type = any
}

variable "argocd" {
  type = object({
    server     = string
    auth_token = string
  })
}

variable "cluster_issuer" {
  type = string
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
  type = any
}
