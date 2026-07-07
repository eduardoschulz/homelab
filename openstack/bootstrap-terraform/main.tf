variable "enable_main_project" {
  type    = bool
  default = true
}

variable "enable_public_network" {
  type    = bool
  default = true
}

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name #tenant == project 
  password    = var.password
  auth_url    = var.auth_url
}

module "main_project" {
  source = "./modules/main-project"

  count = var.enable_main_project ? 1 : 0
}

module "public_network" {
  source = "./modules/public-network"

  count = var.enable_public_network ? 1 : 0
}
