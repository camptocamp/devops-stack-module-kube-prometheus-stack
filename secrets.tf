resource "random_string" "grafana_admin_credentials_secret_suffix" {
  length  = 8
  special = false
}

resource "random_password" "grafana_admin_password" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "grafana_admin_credentials" {
  count = var.secrets_backend == "aws-secrets-manager" ? 1 : 0

  name = "devops-stack-grafana-admin-credentials-${resource.random_string.grafana_admin_credentials_secret_suffix.result}"

  tags = {
    "devops-stack" = "true"
    "cluster"      = var.cluster_name
  }
}

resource "aws_secretsmanager_secret_version" "grafana_admin_credentials" {
  count = var.secrets_backend == "aws-secrets-manager" ? 1 : 0

  secret_id = resource.aws_secretsmanager_secret.grafana_admin_credentials[0].id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.grafana_admin_password.result
  })
}
