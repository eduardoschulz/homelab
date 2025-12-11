terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.api_url
  pm_api_token_id     = var.token_id
  pm_api_token_secret = var.token_secret
  pm_tls_insecure     = true
  pm_debug            = true
}

# Generates ip addresses for each vm following the pattern
locals {
  base_ip_prefix = "192.168.0"
  start_ip_suffix = 60
  ips = [
    for i in range(5) : 
    "ip=${local.base_ip_prefix}.${local.start_ip_suffix + i}/24,gw=${local.base_ip_prefix}.1"
  ]
}

module "k3s_servers" {
  source    = "./server"

  count     = 2
  instance_index = count.index

  ipconfig0 = local.ips[count.index] 
  
  target_node = "delta-px"
  ssh_key     = var.ssh_key 
}

module "k3s_agents" {
  source    = "./agent"
  count     = 3
  instance_index = count.index

  ipconfig0 = local.ips[count.index + 2] 
  
  # Pass other required variables
  target_node = "delta-px"
  ssh_key     = var.ssh_key 
}

