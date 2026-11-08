terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.76.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.api_url
  api_token = "${var.token_id}=${var.token_secret}"
  insecure  = true

  ssh {
    username = "root"
    agent    = true
  }
}

module "ubuntu_kolla" {
  source = "../../modules/vm"

  vmid               = var.vmid
  name               = var.name
  target_node        = var.target_node
  clone_vm_id        = var.clone_vm_id
  cores              = var.cores
  memory             = var.memory
  disk_storage       = var.disk_storage
  cloudinit_storage  = var.disk_storage
  disk_size          = var.disk_size
  ipv4_address       = var.ipv4_address
  ipv4_gateway       = var.ipv4_gateway
  ciuser             = var.ciuser

  ssh_key = var.ssh_key

  depends_on = [proxmox_virtual_environment_vm.template]
}
