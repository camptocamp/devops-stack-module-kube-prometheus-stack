# devops-stack-module-kube-prometheus-stack

A [DevOps Stack](https://devops-stack.io) module to deploy and configure [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).


## Usage

```hcl
module "monitoring" {
  source = "git::https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git//modules"

  cluster_name     = var.cluster_name
  oidc             = module.oidc.oidc
  argocd_namespace = module.cluster.argocd_namespace
  base_domain      = module.cluster.base_domain
  cluster_issuer   = "letsencrypt-prod"
  metrics_archives = {}

  depends_on = [ module.oidc ]
}
```
