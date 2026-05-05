variable "project_name" {}
variable "aws_region" {}
variable "google_client_id" {}
variable "google_client_secret" {}
variable "public_ip" {}

resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]

  callback_urls = [
    "http://localhost/admin.html",
    "https://${var.public_ip}/admin.html",
    "agenda-app://callback"
  ]
  logout_urls   = [
    "http://localhost/admin.html",
    "http://localhost/index.html",
    "http://localhost/login.html",
    "https://${var.public_ip}/admin.html",
    "https://${var.public_ip}/index.html",
    "https://${var.public_ip}/login.html",
    "agenda-app://signout"
  ]

  supported_identity_providers = ["COGNITO", "Google"]

  depends_on = [aws_cognito_identity_provider.google]
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "openid email profile"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
  }

  attribute_mapping = {
    email    = "email"
    name     = "name"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "${var.project_name}-auth-c44f17"
  user_pool_id = aws_cognito_user_pool.this.id
}



output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "domain" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}
