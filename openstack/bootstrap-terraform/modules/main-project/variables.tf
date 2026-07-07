variable "name" {
  type    = string
  default = "main-project"
}

variable "description" {
  type    = string
  default = "Default Project"
}

variable "enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = list(string)
  default = ["default"]
}

variable "enable_blockstorage_quotas" {
  type    = bool
  default = false
}

variable "region" {
  type    = string
  default = "RegionOne"
}

variable "block_storage_endpoint" {
  type    = string
  default = "http://192.168.0.200:8776/v3/%(project_id)s"
}

# quotaset for cinder
variable "volumes" {
  type    = number
  default = 10
}

variable "snapshots" {
  type    = number
  default = 4
}

variable "gigabytes" {
  type    = number
  default = 100
}

# quotaset for nova
variable "instances" {
  type    = number
  default = 10
}

variable "cores" {
  type    = number
  default = 10
}

variable "ram" {
  type    = number
  default = 1024 * 10
}

variable "member_role_name" {
  type        = string
  description = "Name of the role to assign to eduardo on this project"
  default     = "member"
}

variable "admin_username" {
  type        = string
  description = "Name of the existing OpenStack user to grant admin role on this project"
  default     = "admin"
}

# quotaset for neutron
variable "floatingip" {
  type    = number
  default = 5
}

variable "network" {
  type    = number
  default = 8
}

variable "port" {
  type    = number
  default = 100
}

variable "rbac_policy" {
  type    = number
  default = 10
}

variable "router" {
  type    = number
  default = 4
}

variable "security_group" {
  type    = number
  default = 10
}

variable "security_group_rule" {
  type    = number
  default = 100
}

variable "subnet" {
  type    = number
  default = 8
}

variable "subnetpool" {
  type    = number
  default = 2
}

variable "admin_role_name" {
  type        = string
  description = "Name of the admin role to assign"
  default     = "admin"
}
