provider "argocd" {
  server_addr = var.argocd.server
  auth_token  = var.argocd.auth_token
  insecure    = true
  grpc_web    = true
}
 
resource "argocd_project" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = "argocd"
  }
 
  spec {
    description  = "Kube-prometheus-stack application project"
    source_repos = ["https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack"]
 
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-prometheus-stack"
    }
 
    orphaned_resources {
      warn = true
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
  }

  spec {
    source {
      repo_url        = "https://github.com/camptocamp/devops-stack-module-kube-prometheus-sta"
      path            = "charts/kube-prometheus-stack"
      target_revision = "master"
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
  }
}
