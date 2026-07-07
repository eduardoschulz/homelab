terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_networking_network_v2" "public1" {
  name           = var.network_name
  admin_state_up = var.admin_state_up
  shared         = var.shared
  external       = var.external

  segments {
    network_type     = var.network_type
    physical_network = var.physical_network
  }
}

resource "openstack_networking_subnet_v2" "public1_subnet" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.public1.id
  cidr            = var.cidr
  ip_version      = var.ip_version
  enable_dhcp     = var.enable_dhcp
  gateway_ip      = var.gateway_ip

  allocation_pool {
    start = var.allocation_pool_start
    end   = var.allocation_pool_end
  }
}
