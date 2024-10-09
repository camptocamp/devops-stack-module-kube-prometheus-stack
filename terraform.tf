terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 6"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes" # Needed for the creation of a Kubernetes secret
      version = ">= 2"
    }
  }
}
