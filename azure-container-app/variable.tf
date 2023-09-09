variable "ghcr_token" {
  type      = string
}

variable "db_uri" {
  type      = string

  sensitive = true
}