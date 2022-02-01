# devops-stack-module-kube-prometheus-stack

A [DevOps Stack](https://devops-stack.io) module to deploy and configure [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack).


## Usage

```hcl
module "monitoring" {
  source = "git::https://github.com/camptocamp/devops-stack-module-kube-prometheus-stack.git//modules"

  cluster_info     = module.cluster.info
  oidc             = module.oidc.oidc
  cluster_issuer   = "letsencrypt-prod"
  metrics_archives = {}

  depends_on = [ module.oidc ]
}
```
