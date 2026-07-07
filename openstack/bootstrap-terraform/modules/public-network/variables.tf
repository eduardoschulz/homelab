variable "network_name" {
  description = "Name of the public network"
  type        = string
  default     = "public1"
}

variable "network_type" {
  description = "Type of the public network (e.g., flat, vlan, vxlan)"
  type        = string
  default     = "flat"
}

variable "physical_network" {
  description = "Physical network name"
  type        = string
  default     = "physnet1"
}

variable "subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "public1-subnet"
}

variable "cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "192.168.0.0/24"
}

variable "ip_version" {
  description = "IP version (4 or 6)"
  type        = number
  default     = 4
}

variable "enable_dhcp" {
  description = "Enable DHCP on the subnet"
  type        = bool
  default     = true
}

variable "gateway_ip" {
  description = "Gateway IP for the subnet"
  type        = string
  default     = "192.168.0.1"
}

variable "allocation_pool_start" {
  description = "Start of the allocation pool"
  type        = string
  default     = "192.168.0.201"
}

variable "allocation_pool_end" {
  description = "End of the allocation pool"
  type        = string
  default     = "192.168.0.249"
}

variable "admin_state_up" {
  description = "Administrative state of the network"
  type        = bool
  default     = true
}

variable "shared" {
  description = "Whether the network is shared across projects"
  type        = bool
  default     = true
}

variable "external" {
  description = "Whether the network is external"
  type        = bool
  default     = true
}
