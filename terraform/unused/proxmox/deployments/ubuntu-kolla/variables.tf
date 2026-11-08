variable "api_url" {
  description = "Proxmox API endpoint"
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

variable "vmid" {
  description = "VM ID"
  type        = number
  default     = 900
}

variable "name" {
  description = "VM name"
  type        = string
  default     = "ubuntu-kolla"
}

variable "target_node" {
  description = "Proxmox node"
  type        = string
  default     = "delta-px"
}

variable "clone_vm_id" {
  description = "Numeric VM ID of the template to clone"
  type        = number
}

variable "cores" {
  description = "CPU cores"
  type        = number
  default     = 4
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "disk_storage" {
  description = "Storage pool (local-lvm, proxmox-nfs, etc.)"
  type        = string
  default     = "local-lvm"
}

variable "disk_size" {
  description = "Root disk size (GB)"
  type        = number
  default     = 40
}

variable "ipv4_address" {
  description = "Static IPv4 address in CIDR (e.g. 192.168.0.90/24)"
  type        = string
  default     = ""
}

variable "ciuser" {
  description = "Cloud-init user"
  type        = string
  default     = "ubuntu"
}

variable "ipv4_gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = ""
}
