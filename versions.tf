terraform {
  required_providers {
    argocd = {
      source = "oboukili/argocd"
    }
    utils = {
      source = "cloudposse/utils"
    }
    kubernetes = { 
      source  = "hashicorp/kubernetes" # Needed for the creation of a Kubernetes secret
    }
  }
}
