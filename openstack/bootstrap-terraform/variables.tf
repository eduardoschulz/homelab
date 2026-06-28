variable "user_name" {
  description = "OpenStack username"
  type        = string
}

variable "tenant_name" {
  description = "Tenant Name or Project Name"
  type        = string
}

variable "password" {
  description = "OpenStack password found at cloud.yaml"
  type        = string
  sensitive   = true
}

variable "auth_url" {
  description = "OpenStack instance url"
  type        = string
}

