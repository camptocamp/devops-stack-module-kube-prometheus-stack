locals {
  helm_values = [{
    kube-prometheus-stack = {
      alertmanager = merge(local.alertmanager.enable ? {
        alertmanagerSpec = {
          initContainers = [
            {
              name  = "wait-for-oidc"
              image = "curlimages/curl:7.79.1"
              command = [
                "/bin/sh",
                "-c",
              ]
              args = [
              <<-EOT
                until curl -skL -w "%%{http_code}\\n" "${replace(local.alertmanager.oidc.api_url, "\"", "\\\"")}" -o /dev/null | grep -vq "^\(000\|404\)$"; do echo "waiting for oidc at ${replace(local.alertmanager.oidc.api_url, "\"", "\\\"")}"; sleep 2; done
              EOT
              ]
            },
          ]
          containers = [
            {
              image = "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3"
              name  = "alertmanager-proxy"
              ports = [
                {
                  name          = "web"
                  containerPort = 9095
                },
              ]
              args = concat([
                "--http-address=0.0.0.0:9095",
                "--upstream=http://localhost:9093",
                "--provider=oidc",
                "--oidc-issuer-url=${replace(local.alertmanager.oidc.issuer_url, "\"", "\\\"")}",
                "--client-id=${replace(local.alertmanager.oidc.client_id, "\"", "\\\"")}",
                "--client-secret=${replace(local.alertmanager.oidc.client_secret, "\"", "\\\"")}",
                "--cookie-secure=false",
                "--cookie-secret=${replace(random_password.oauth2_cookie_secret.result, "\"", "\\\"")}",
                "--email-domain=*",
                "--redirect-url=https://${local.alertmanager.domain}/oauth2/callback",
              ], local.alertmanager.oidc.oauth2_proxy_extra_args)
            },
          ]
        }
        ingress = {
          enabled = true
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hosts = [
            "${local.alertmanager.domain}",
            "alertmanager.apps.${var.base_domain}"
          ]
          tls = [
            {
              secretName = "alertmanager-tls"
              hosts = [
                "${local.alertmanager.domain}",
                "alertmanager.apps.${var.base_domain}",
              ]
            },
          ]
        }
        service = {
          targetPort = 9095
        }
        serviceMonitor = {
          selfMonitor = false
        }
        } : null, {
        enabled = local.alertmanager.enable
      })
      grafana = merge(local.grafana.enable ? {
        adminPassword = "${replace(local.grafana.admin_password, "\"", "\\\"")}"
        "grafana.ini" = {
          "auth.generic_oauth" = merge({
            enabled       = true
            allow_sign_up = true
            client_id     = "${replace(local.grafana.oidc.client_id, "\"", "\\\"")}"
            client_secret = "${replace(local.grafana.oidc.client_secret, "\"", "\\\"")}"
            scopes        = "openid profile email"
            auth_url      = "${replace(local.grafana.oidc.oauth_url, "\"", "\\\"")}"
            token_url     = "${replace(local.grafana.oidc.token_url, "\"", "\\\"")}"
            api_url       = "${replace(local.grafana.oidc.api_url, "\"", "\\\"")}"
          }, local.grafana.generic_oauth_extra_args)
          users = {
            auto_assign_org_role = "Editor"
          }
          server = {
            domain   = "${local.grafana.domain}"
            root_url = "https://%(domain)s" # TODO check this
          }
        }
        sidecar = {
          datasources = {
            defaultDatasourceEnabled = false
          }
        }
        additionalDataSources = concat(
          [{
            name = "Prometheus"
            type = "prometheus"
            url       = "http://kube-prometheus-stack-prometheus:9090"
            access    = "proxy"
            isDefault = true
            jsonData = {
              tlsAuth           = false
              tlsAuthWithCACert = false
              oauthPassThru     = true
            }
          }],
          can(var.metrics_archives.bucket_config) ? [{
            name = "Thanos-${var.cluster_name}"
            type = "prometheus"
            url       = "http://thanos-query.thanos:9090"
            access    = "proxy"
            isDefault = false
            jsonData = {
              tlsAuth           = false
              tlsAuthWithCACert = false
              oauthPassThru     = true
            }
          }] : null
        )
        ingress = {
          enabled = true
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hosts = [
            "${local.grafana.domain}",
            "grafana.apps.${var.base_domain}",
          ]
          tls = [
            {
              secretName = "grafana-tls"
              hosts = [
                "${local.grafana.domain}",
                "grafana.apps.${var.base_domain}",
              ]
            },
          ]
        }
        } : null, {
        enabled = local.grafana.enable
      })
      prometheus = merge(local.prometheus.enable ? {
        ingress = {
          enabled = true
          annotations = {
            "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
            "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
            "traefik.ingress.kubernetes.io/router.middlewares" = "traefik-withclustername@kubernetescrd"
            "traefik.ingress.kubernetes.io/router.tls"         = "true"
            "ingress.kubernetes.io/ssl-redirect"               = "true"
            "kubernetes.io/ingress.allow-http"                 = "false"
          }
          hosts = [
            "${local.prometheus.domain}",
            "prometheus.apps.${var.base_domain}",
          ]
          tls = [
            {
              secretName = "prometheus-tls"
              hosts = [
                "${local.prometheus.domain}",
                "prometheus.apps.${var.base_domain}",
              ]
            },
          ]
        }
        prometheusSpec = merge({
          portName = "proxy"
          initContainers = [
            {
              name  = "wait-for-oidc"
              image = "curlimages/curl:7.79.1"
              command = [
                "/bin/sh",
                "-c",
              ]
              args = [
              <<-EOT
                until curl -skL -w "%%{http_code}\\n" "${replace(local.prometheus.oidc.api_url, "\"", "\\\"")}" -o /dev/null | grep -vq "^\(000\|404\)$"; do echo "waiting for oidc at ${replace(local.prometheus.oidc.api_url, "\"", "\\\"")}"; sleep 2; done
              EOT
              ]
            },
          ]
          containers = [
            {
              args = concat([
                "--http-address=0.0.0.0:9091",
                "--upstream=http://localhost:9090",
                "--provider=oidc",
                "--oidc-issuer-url=${replace(local.prometheus.oidc.issuer_url, "\"", "\\\"")}",
                "--client-id=${replace(local.prometheus.oidc.client_id, "\"", "\\\"")}",
                "--client-secret=${replace(local.prometheus.oidc.client_secret, "\"", "\\\"")}",
                "--cookie-secure=false",
                "--cookie-secret=${replace(random_password.oauth2_cookie_secret.result, "\"", "\\\"")}",
                "--email-domain=*",
                "--redirect-url=https://${local.prometheus.domain}/oauth2/callback",
              ], local.prometheus.oidc.oauth2_proxy_extra_args)
              image = "quay.io/oauth2-proxy/oauth2-proxy:v7.1.3"
              name  = "prometheus-proxy"
              ports = [
                {
                  containerPort = 9091
                  name          = "proxy"
                },
              ]
            },
          ]
          alertingEndpoints = [
            {
              name      = "kube-prometheus-stack-alertmanager"
              namespace = "kube-prometheus-stack"
              port      = 9093
            },
          ]
          }, can(var.metrics_archives.bucket_config) ? {
          thanos = {
            objectStorageConfig = {
              key  = "thanos.yaml"
              name = "thanos-objectstorage"
            }
          }
        } : null)
        service = {
          port       = 9091
          targetPort = 9091
          additionalPorts = [
            {
              name       = "web"
              port       = 9090
              targetPort = 9090
            },
          ]
        }
        serviceMonitor = {
          selfMonitor = false
        }
        additionalPodMonitors = [
          {
            name = "alertmanager"
            podMetricsEndpoints = [
              {
                path       = "/metrics"
                targetPort = 9093
              },
            ]
            namespaceSelector = {
              matchNames = [
                "kube-prometheus-stack"
              ]
            }
            selector = {
              matchLabels = {
                alertmanager = "kube-prometheus-stack-alertmanager"
                app          = "alertmanager"
              }
            }
          },
          {
            name = "prometheus"
            podMetricsEndpoints = [
              {
                path       = "/metrics"
                targetPort = 9090
              },
            ]
            namespaceSelector = {
              matchNames = [
                "kube-prometheus-stack"
              ]
            }
            selector = {
              matchLabels = {
                prometheus = "kube-prometheus-stack-prometheus"
                app        = "prometheus"
              }
            }
          },
        ]
        } : null, {
        enabled = local.prometheus.enable
        thanosService = {
          enabled = can(var.metrics_archives.bucket_config) ? true : false
        }
        }
      )
    }
  }]

  grafana_defaults = {
    enable                   = true
    generic_oauth_extra_args = {}
    domain                   = "grafana.apps.${var.cluster_name}.${var.base_domain}"
    admin_password           = random_password.grafana_admin_password.result
  }

  grafana = merge(
    local.grafana_defaults,
    var.grafana,
  )

  prometheus_defaults = {
    domain = "prometheus.apps.${var.cluster_name}.${var.base_domain}"
    enable = true
  }

  prometheus = merge(
    local.prometheus_defaults,
    var.prometheus,
  )

  alertmanager_defaults = {
    enable = true
    domain = "alertmanager.apps.${var.cluster_name}.${var.base_domain}"
  }

  alertmanager = merge(
    local.alertmanager_defaults,
    var.alertmanager,
  )
}

resource "random_password" "grafana_admin_password" {
  length  = 16
  special = false
}
