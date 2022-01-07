resource "argocd_project" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = var.argocd.namespace
    annotations = {
      "devops-stack.io/argocd_namespace" = var.argocd.namespace
    }
  }
 
  spec {
    description  = "Kube-prometheus-stack application project"
    source_repos = ["https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"]
 
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }
 
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-system"
    }
 
    orphaned_resources {
      warn = true
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "random_password" "oauth2_cookie_secret" {                                  
  length  = 16                                                                      
  special = false                                                                   
}   

data "utils_deep_merge_yaml" "values" {
  input = [ for i in var.profiles : templatefile("${path.module}/profiles/${i}.yaml", {
      oidc           = var.oidc,
      base_domain    = var.base_domain,
      cluster_issuer = var.cluster_issuer,
 
      cookie_secret = random_password.oauth2_cookie_secret.result
      metrics_archives = var.metrics_archives
 
      alertmanager = local.alertmanager,
      grafana      = local.grafana,
      prometheus   = local.prometheus,
  }) ]
}

resource "argocd_application" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = var.argocd.namespace
  }

  spec {
    project = argocd_project.this.metadata.0.name

    source {
      repo_url        = "https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"
      path            = "charts/kube-prometheus-stack"
      target_revision = "main"
      helm {
        values = data.utils_deep_merge_yaml.values.output
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }

    sync_policy {
      automated = {
        prune     = true
        self_heal = true
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }
}
