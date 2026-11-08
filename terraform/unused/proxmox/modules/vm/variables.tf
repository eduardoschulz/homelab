variable "vmid" {
  description = "VM ID"
  type        = number
}

variable "name" {
  description = "VM name"
  type        = string
}

variable "target_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "clone_vm_id" {
  description = "Numeric VM ID of the template to clone"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Root disk size (e.g. 20G)"
  type        = string
  default     = "20G"
}

variable "disk_storage" {
  description = "Storage pool for the root disk"
  type        = string
  default     = "local-lvm"
}

variable "cloudinit_storage" {
  description = "Storage pool for the cloud-init disk"
  type        = string
  default     = "local-lvm"
}

variable "started" {
  description = "Start the VM after creation"
  type        = bool
  default     = true
}

variable "network_bridge" {
  description = "Bridge interface"
  type        = string
  default     = "vmbr0"
}

variable "ipv4_address" {
  description = "Static IPv4 address in CIDR notation (e.g. 192.168.0.90/24)"
  type        = string
  default     = ""
}

variable "ipv4_gateway" {
  description = "IPv4 gateway (e.g. 192.168.0.1)"
  type        = string
  default     = ""
}

variable "ciuser" {
  description = "Cloud-init user"
  type        = string
  default     = "ubuntu"
}

variable "cipassword" {
  description = "Cloud-init password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_key" {
  description = "Public SSH key"
  type        = string
}
