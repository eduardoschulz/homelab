terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.76.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.api_url
  api_token = "${var.token_id}=${var.token_secret}"
  insecure  = true
}
