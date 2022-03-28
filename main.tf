resource "argocd_project" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = var.argocd_namespace
    annotations = {
      "devops-stack.io/argocd_namespace" = var.argocd_namespace
    }
  }

  spec {
    description  = "Kube-prometheus-stack application project"
    source_repos = ["https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"]

    destination {
      name      = "in-cluster"
      namespace = var.namespace
    }

    destination {
      name      = "in-cluster"
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
  input = concat(local.all_yaml, tolist([yamlencode(local.helm_values)]))
}

resource "argocd_application" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = var.argocd_namespace
  }

  wait = true

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
      name      = "in-cluster"
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
