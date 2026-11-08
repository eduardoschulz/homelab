resource "proxmox_virtual_environment_download_file" "ubuntu_noble" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.target_node
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "ubuntu-noble-kolla.img"
  overwrite    = false
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.target_node

  # source_file {
  #   path = "cloud-init.yaml"
  # }

  source_raw {
    data = <<-EOF
    #cloud-config
    packages:
      - qemu-guest-agent
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
    EOF
    file_name = "ubuntu-kolla-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "template" {
  node_name = var.target_node
  vm_id     = var.clone_vm_id
  name      = "ubuntu-noble-kolla-template"
  template  = true
  started   = false

  agent {
    enabled = true
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    file_id      = proxmox_virtual_environment_download_file.ubuntu_noble.id
    size         = 20
  }

  initialization {
    datastore_id      = var.disk_storage
    interface         = "ide1"
    upgrade           = true
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data.id

    user_account {
      username = "ubuntu"
      keys     = [var.ssh_key]
    }
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  serial_device {
    device = "socket"
  }
}
