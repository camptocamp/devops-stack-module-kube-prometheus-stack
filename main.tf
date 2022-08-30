resource "null_resource" "dependencies" {
  triggers = var.dependency_ids
}

resource "argocd_project" "this" {
  metadata {
    name      = "kube-prometheus-stack"
    namespace = var.argocd_namespace
    annotations = {
      "devops-stack.io/argocd_namespace" = var.argocd_namespace
    }
  }

  spec {
    description  = "kube-prometheus-stack application project"
    source_repos = ["https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git"]

    destination {
      name      = "in-cluster"
      namespace = var.namespace
    }

    destination {
      name      = "in-cluster"
      namespace = kube-system # Needed by the v1/Service kube-prometheus-stack-coredns that needs to be inside kube-system
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

resource "kubernetes_secret" "thanos_s3_bucket_secret" {
  # This count here is nothing more than a way to conditionally deploy this
  # resource. Although there is no loop inside the resource, if the condition
  # is true, the resource is deployed because there is exactly one iteration.
  count = var.metrics_archives.thanos_enabled ? 1 : 0

  metadata {
    name      = "thanos-objectstorage"
    namespace = var.namespace
  }

  data = {
    "thanos.yaml" = yamlencode(
      var.metrics_archives.bucket_config
    )
  }

  depends_on = [
    resource.argocd_application.this,
  ]
}

resource "random_password" "oauth2_cookie_secret" {
  length  = 16
  special = false
}

data "utils_deep_merge_yaml" "values" {
  input = [for i in concat(local.helm_values, var.helm_values) : yamlencode(i)]
}

resource "argocd_application" "this" {
  timeouts {
    create = "15m"
    delete = "15m"
  }

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
        allow_empty = false
        prune       = true
        self_heal   = true
      }

      retry {
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }

  depends_on = [
    resource.null_resource.dependencies,
  ]
}

resource "null_resource" "this" {
  depends_on = [
    resource.argocd_application.this,
  ]
}
