terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

variable "target_node" {}
variable "ssh_key" {}
variable "ipconfig0" {}
variable "instance_index" { 
  type = number
}

resource "proxmox_vm_qemu" "k3s_agent" {
  vmid        = 310 + var.instance_index
  name        = "k3s-agent${var.instance_index + 1}"
  
  target_node = var.target_node
  agent       = 1
  #TODO fix deprecated core flag
  cores       = 6 
  memory      = 16384
  
  boot        = "order=scsi0"
  clone       = "ubuntu-noble-cloudinit" 
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" 
  ciupgrade  = false
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = var.ipconfig0 
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "Enter123!"  
  sshkeys    = var.ssh_key

  serial { id = 0 } 

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "nfs-truenas"
          size    = "20G" 
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = "nfs-truenas" 
        }
      }
    }
  }

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}
