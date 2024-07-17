locals {
  oauth2_proxy_image       = "quay.io/oauth2-proxy/oauth2-proxy:v7.6.0"
  curl_wait_for_oidc_image = "curlimages/curl:8.6.0"
  domain                   = trimprefix("${var.subdomain}.${var.base_domain}", ".")
  domain_full              = trimprefix("${var.subdomain}.${var.cluster_name}.${var.base_domain}", ".")

  ingress_annotations = {
    "cert-manager.io/cluster-issuer"                   = "${var.cluster_issuer}"
    "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
    "traefik.ingress.kubernetes.io/router.tls"         = "true"
  }

  oidc_proxy_resources = {
    requests = {
      cpu    = "20m"
      memory = "64M"
    }
    limits = {
      memory = "128M"
    }
  }

  grafana_defaults = {
    enabled                  = true
    additional_data_sources  = false
    generic_oauth_extra_args = {}
    domain                   = "grafana.${local.domain_full}"
  }

  grafana = merge(
    local.grafana_defaults,
    var.grafana,
  )

  prometheus_defaults = {
    enabled = true
    domain  = "prometheus.${local.domain_full}"
  }

  prometheus = merge(
    local.prometheus_defaults,
    var.prometheus,
  )

  alertmanager_defaults = {
    enabled            = true
    domain             = "alertmanager.${local.domain_full}"
    deadmanssnitch_url = null
    slack_routes       = []
  }

  alertmanager = merge(
    local.alertmanager_defaults,
    var.alertmanager,
  )

  alertmanager_receivers = flatten([
    [{
      name = "devnull"
    }],
    local.alertmanager.deadmanssnitch_url != null ? [{
      name = "deadmanssnitch"
      webhook_configs = [{
        url           = local.alertmanager.deadmanssnitch_url
        send_resolved = false
      }]
    }] : [],
    [for item in local.alertmanager.slack_routes : {
      name = item["name"]
      slack_configs = [{
        channel       = item["channel"]
        api_url       = item["api_url"]
        send_resolved = true
        icon_url      = "https://avatars3.githubusercontent.com/u/3380462"
        title         = "{{ template \"slack.title\" . }}"
        text          = "{{ template \"slack.text\" . }}"
      }]
    }],
  ])

  alertmanager_routes = {
    group_by = ["alertname"]
    receiver = "devnull"
    routes = flatten([
      local.alertmanager.deadmanssnitch_url != null ? [{ matchers = ["alertname=\"Watchdog\""], receiver = "deadmanssnitch", repeat_interval = "2m" }] : [],
      [for item in local.alertmanager.slack_routes : {
        matchers = item["matchers"]
        receiver = item["name"]
        continue = lookup(item, "continue", false)
      }]
    ])
  }

  alertmanager_template_files = length(local.alertmanager.slack_routes) > 0 ? {
    "slack.tmpl" = <<-EOT
        {{ define "slack.title" -}}
          [{{ .Status | toUpper }}
          {{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{- end -}}
          ] {{ .CommonLabels.alertname }}
        {{ end }}
        {{ define "slack.text" -}}
        {{ range .Alerts }}
          *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`
          {{- if .Annotations.description }}
          *Severity:* `{{ .Labels.severity }}`
          *Description:* {{ .Annotations.description }}
          {{- end }}
          *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:>
          *Labels:*
            {{ range .Labels.SortedPairs }} - *{{ .Name }}:* `{{ .Value }}`
            {{ end }}
          {{- if .Annotations.runbook_url }}
          *Runbook URL:* <{{ .Annotations.runbook_url }}|Click here>
          {{- end }}
        {{ end }}
        {{ end }}
    EOT
  } : {}

  helm_values = [{
    secrets_names = {
      cluster_secret_store  = var.secrets_names.cluster_secret_store_name
      kube_prometheus_stack = var.secrets_names.kube_prometheus_stack
    }

    kube-prometheus-stack = {
      alertmanager = merge(local.alertmanager.enabled ? {
        alertmanagerSpec = {
          initContainers = [
            {
              name  = "wait-for-oidc"
              image = local.curl_wait_for_oidc_image
              command = [
                "/bin/sh",
                "-c",
              ]
              args = [
                <<-EOT
                until curl -skL -w "%%{http_code}\\n" "${replace(var.oidc.api_url, "\"", "\\\"")}" -o /dev/null | grep -vq "^\(000\|404\)$"; do echo "waiting for oidc at ${replace(var.oidc.api_url, "\"", "\\\"")}"; sleep 2; done
              EOT
              ]
            },
          ]
          containers = [
            {
              image     = local.oauth2_proxy_image
              name      = "alertmanager-proxy"
              resources = local.oidc_proxy_resources
              ports = [
                {
                  name          = "proxy"
                  containerPort = 9095
                },
              ]
              args = concat([
                "--http-address=0.0.0.0:9095",
                "--upstream=http://localhost:9093",
                "--provider=oidc",
                "--oidc-issuer-url=${replace(var.oidc.issuer_url, "\"", "\\\"")}",
                "--client-id=${replace(var.oidc.client_id, "\"", "\\\"")}",
                "--cookie-secure=false",
                "--email-domain=*",
                "--redirect-url=https://${local.alertmanager.domain}/oauth2/callback",
              ], var.oidc.oauth2_proxy_extra_args)
              env = [
                {
                  name = "OAUTH2_PROXY_CLIENT_SECRET"
                  valueFrom = {
                    secretKeyRef = {
                      name = "kube-prometheus-stack-oidc-client-secret"
                      key  = "value"
                    }
                  }
                },
                {
                  name = "OAUTH2_PROXY_COOKIE_SECRET"
                  valueFrom = {
                    secretKeyRef = {
                      name = "kube-prometheus-stack-oauth2-proxy-cookie-secret"
                      key  = "value"
                    }
                  }
                }
              ]
            },
          ]
          resources = {
            requests = { for k, v in var.resources.alertmanager.requests : k => v if v != null }
            limits   = { for k, v in var.resources.alertmanager.limits : k => v if v != null }
          }
        }
        ingress = {
          enabled     = true
          annotations = local.ingress_annotations
          servicePort = "9095"
          hosts = [
            "${local.alertmanager.domain}",
            "alertmanager.${local.domain}"
          ]
          tls = [
            {
              secretName = "alertmanager-tls"
              hosts = [
                "${local.alertmanager.domain}",
                "alertmanager.${local.domain}",
              ]
            },
          ]
        }
        service = {
          additionalPorts = [
            {
              name       = "proxy"
              port       = 9095
              targetPort = 9095
            },
          ]
        }
        config = {
          route     = local.alertmanager_routes
          receivers = local.alertmanager_receivers
        }
        templateFiles = local.alertmanager_template_files
        } : null, {
        enabled = local.alertmanager.enabled
      })
      grafana = merge(local.grafana.enabled ? {
        # TODO Remove the `assertNoLeakedSecrets when we start properly managing them:
        # - https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#override-configuration-with-environment-variables
        # - https://github.com/grafana/helm-charts/issues/2896
        assertNoLeakedSecrets = false
        admin = {
          existingSecret = "kube-prometheus-stack-grafana-admin-credentials"
          userKey        = "username"
          passwordKey    = "password"
        }
        "grafana.ini" = {
          "auth.generic_oauth" = merge({
            enabled                  = true
            allow_sign_up            = true
            client_id                = "${replace(var.oidc.client_id, "\"", "\\\"")}"
            client_secret            = "placeholder" # This string here is required in order for this value to be overloaded by the `env` attribute below.
            scopes                   = "openid profile email"
            auth_url                 = "${replace(var.oidc.oauth_url, "\"", "\\\"")}"
            token_url                = "${replace(var.oidc.token_url, "\"", "\\\"")}"
            api_url                  = "${replace(var.oidc.api_url, "\"", "\\\"")}"
            tls_skip_verify_insecure = var.cluster_issuer != "letsencrypt-prod"
            }, {
            # This loop here ensures that the user cannot override the parameters that we are setting by using the `generic_oauth_extra_args` attribute.
            for k, v in var.oidc.generic_oauth_extra_args : k => v if !(contains(["enabled", "allow_sign_up", "client_id", "client_secret", "scopes", "auth_url", "token_url", "api_url"], k))
          })
          users = {
            auto_assign_org_role = "Editor"
          }
          server = {
            domain   = "${local.grafana.domain}"
            root_url = "https://%(domain)s"
          }
          dataproxy = {
            timeout = var.dataproxy_timeout
          }
        }
        envValueFrom = {
          "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET" = {
            secretKeyRef = {
              name = "kube-prometheus-stack-oidc-client-secret"
              key  = "value"
            }
          }
        }
        sidecar = {
          datasources = {
            defaultDatasourceEnabled = false
          }
        }
        additionalDataSources = [merge(var.metrics_storage_enabled ? {
          name = "Thanos"
          url  = "http://thanos-query-frontend.thanos:9090"
          } : {
          name = "Prometheus"
          url  = "http://kube-prometheus-stack-prometheus:9090"
          }, {
          type      = "prometheus"
          access    = "proxy"
          isDefault = true
          jsonData = {
            tlsAuth           = false
            tlsAuthWithCACert = false
            oauthPassThru     = true
          }
          }
        )]
        ingress = {
          enabled     = true
          annotations = local.ingress_annotations
          hosts = [
            "${local.grafana.domain}",
            "grafana.${local.domain}",
          ]
          tls = [
            {
              secretName = "grafana-tls"
              hosts = [
                "${local.grafana.domain}",
                "grafana.${local.domain}",
              ]
            },
          ]
        }
        resources = {
          requests = { for k, v in var.resources.grafana.requests : k => v if v != null }
          limits   = { for k, v in var.resources.grafana.limits : k => v if v != null }
        }
        } : null,
        merge((!local.grafana.enabled && local.grafana.additional_data_sources) ? {
          forceDeployDashboards  = true
          forceDeployDatasources = true
          sidecar = {
            datasources = {
              defaultDatasourceEnabled = false
            }
          }
          additionalDataSources = [merge(var.metrics_storage_enabled ? {
            name = "Thanos"
            url  = "http://thanos-query.thanos:9090"
            } : {
            # Note that since this is for the the Grafana module deployed inside it's
            # own namespace, we need to have the reference to the namespace in the URL.
            name = "Prometheus"
            url  = "http://kube-prometheus-stack-prometheus.kube-prometheus-stack:9090"
            }, {
            type      = "prometheus"
            access    = "proxy"
            isDefault = true
            jsonData = {
              tlsAuth           = false
              tlsAuthWithCACert = false
              oauthPassThru     = true
            }
            }
          )]
          } : null, {
          enabled = local.grafana.enabled
        })
      )
      prometheus = merge(local.prometheus.enabled ? {
        ingress = {
          enabled     = true
          annotations = local.ingress_annotations
          servicePort = "9091"
          hosts = [
            "${local.prometheus.domain}",
            "prometheus.${local.domain}",
          ]
          tls = [
            {
              secretName = "prometheus-tls"
              hosts = [
                "${local.prometheus.domain}",
                "prometheus.${local.domain}",
              ]
            },
          ]
        }
        prometheusSpec = merge({
          initContainers = [
            {
              name  = "wait-for-oidc"
              image = local.curl_wait_for_oidc_image
              command = [
                "/bin/sh",
                "-c",
              ]
              args = [
                <<-EOT
                until curl -skL -w "%%{http_code}\\n" "${replace(var.oidc.api_url, "\"", "\\\"")}" -o /dev/null | grep -vq "^\(000\|404\)$"; do echo "waiting for oidc at ${replace(var.oidc.api_url, "\"", "\\\"")}"; sleep 2; done
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
                "--oidc-issuer-url=${replace(var.oidc.issuer_url, "\"", "\\\"")}",
                "--client-id=${replace(var.oidc.client_id, "\"", "\\\"")}",
                "--cookie-secure=false",
                "--email-domain=*",
                "--redirect-url=https://${local.prometheus.domain}/oauth2/callback",
              ], var.oidc.oauth2_proxy_extra_args)
              image     = local.oauth2_proxy_image
              name      = "prometheus-proxy"
              resources = local.oidc_proxy_resources
              ports = [
                {
                  containerPort = 9091
                  name          = "proxy"
                },
              ]
              env = [
                {
                  name = "OAUTH2_PROXY_CLIENT_SECRET"
                  valueFrom = {
                    secretKeyRef = {
                      name = "kube-prometheus-stack-oidc-client-secret"
                      key  = "value"
                    }
                  }
                },
                {
                  name = "OAUTH2_PROXY_COOKIE_SECRET"
                  valueFrom = {
                    secretKeyRef = {
                      name = "kube-prometheus-stack-oauth2-proxy-cookie-secret"
                      key  = "value"
                    }
                  }
                }
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
          externalLabels = {
            prometheus = "prometheus-${var.cluster_name}"
          }
          resources = {
            requests = { for k, v in var.resources.prometheus.requests : k => v if v != null }
            limits   = { for k, v in var.resources.prometheus.limits : k => v if v != null }
          }
          }, var.metrics_storage_enabled ? {
          thanos = {
            objectStorageConfig = {
              existingSecret = {
                name = "kube-prometheus-stack-metrics-storage-configuration"
                key  = "thanos.yaml"
              }
            }
            resources = {
              requests = { for k, v in var.resources.thanos_sidecar.requests : k => v if v != null }
              limits   = { for k, v in var.resources.thanos_sidecar.limits : k => v if v != null }
            }
          }
        } : null)
        service = {
          additionalPorts = [
            {
              name       = "proxy"
              port       = 9091
              targetPort = 9091
            },
          ]
        }
        } : null, {
        enabled = local.prometheus.enabled
        thanosService = {
          enabled = var.metrics_storage_enabled ? true : false
        }
        thanosServiceMonitor = {
          enabled = var.metrics_storage_enabled ? true : false
        }
        }
      )
      prometheusOperator = {
        resources = {
          requests = { for k, v in var.resources.prometheus_operator.requests : k => v if v != null }
          limits   = { for k, v in var.resources.prometheus_operator.limits : k => v if v != null }
        }
      }
      kube-state-metrics = {
        resources = {
          requests = { for k, v in var.resources.kube_state_metrics.requests : k => v if v != null }
          limits   = { for k, v in var.resources.kube_state_metrics.limits : k => v if v != null }
        }
      }
      prometheus-node-exporter = {
        resources = {
          requests = { for k, v in var.resources.node_exporter.requests : k => v if v != null }
          limits   = { for k, v in var.resources.node_exporter.limits : k => v if v != null }
        }
      }
    }
  }]
}
