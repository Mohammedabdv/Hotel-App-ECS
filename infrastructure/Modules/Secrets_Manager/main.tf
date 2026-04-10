# Creates the secret container (the vault)
resource "aws_secretsmanager_secret" "app_secrets" {
  name = "hotel-app/secrets"
}

# Stores the actual secret values inside the vault
resource "aws_secretsmanager_secret_version" "app_secrets_value" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    APP_KEY     = var.app_key
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
  })
}
