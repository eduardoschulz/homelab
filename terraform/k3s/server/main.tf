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

resource "proxmox_vm_qemu" "k3s_server" {

  vmid        = 300 + var.instance_index
  name        = "k3s-server${var.instance_index + 1}"
  
  target_node = var.target_node
  agent       = 1
  cores       = 1 
  memory      = 4096 
  
  boot        = "order=scsi0" 
  clone       = "ubuntu-noble-cloudinit" 
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" 
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  # Dynamic IP passed from the root module
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
          storage = "local-lvm"
          size    = "20G" 
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = "local-lvm"  
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
