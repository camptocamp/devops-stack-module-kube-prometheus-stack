provider "argocd" {
  server_addr = "127.0.0.1:8080"
  auth_token  = var.argocd.auth_token
  insecure = true
  plain_text = true
  port_forward = true
  port_forward_with_namespace = var.argocd.namespace

  kubernetes {
    host                   = var.kubernetes.host
    client_certificate     = var.kubernetes.client_certificate
    client_key             = var.kubernetes.client_key
    cluster_ca_certificate = var.kubernetes.cluster_ca_certificate
  }
}
 
resource "argocd_project" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = "argocd"
    annotations = {
      "argocd_namespace" = var.argocd.namespace
    }
  }
 
  spec {
    description  = "Kube-prometheus-stack application project"
    source_repos = ["https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"]
 
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-prometheus-stack"
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

resource "argocd_application" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = "kube-prometheus-stack"
    annotations = {
      "argocd_namespace" = var.argocd.namespace
    }
  }

  spec {
    project = argocd_project.this.metadata.0.name

    source {
      repo_url        = "https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"
      path            = "charts/kube-prometheus-stack"
      target_revision = "main"
      helm {
        values = templatefile("${path.module}/values.tmpl.yaml", {
          oidc           = var.oidc,
          base_domain    = var.base_domain,
          cluster_issuer = var.cluster_issuer,

          cookie_secret = random_password.oauth2_cookie_secret.result
          metrics_archives = var.metrics_archives

          alertmanager = local.alertmanager,
          grafana      = local.grafana,
          prometheus   = local.prometheus,
        })
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-prometheus-stack"
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

  depends_on = [
    argocd_project.this
  ]
}
