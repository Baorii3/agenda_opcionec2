variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "agenda-barata"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  sensitive   = true
}
