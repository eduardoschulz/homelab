variable "api_url" {
  description = "Proxmox API endpoint (e.g. https://host:8006/)"
  type        = string
}

variable "token_id" {
  description = "Proxmox API token ID"
  type        = string
  sensitive   = true
}

variable "token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "ssh_key" {
  description = "Public SSH key"
  type        = string
}
