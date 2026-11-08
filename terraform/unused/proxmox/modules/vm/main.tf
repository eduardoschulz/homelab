terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.76.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  vm_id     = var.vmid
  node_name = var.target_node
  name      = var.name
  started   = var.started
  template  = false

  clone {
    vm_id = var.clone_vm_id
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  initialization {
    datastore_id = var.cloudinit_storage
    interface    = "ide1"

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    user_account {
      username = var.ciuser
      password = var.cipassword != "" ? var.cipassword : null
      keys     = [var.ssh_key]
    }
  }

  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  serial_device {
    device = "socket"
  }
}
