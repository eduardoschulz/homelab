resource "openstack_networking_network_v2" "nw_ext1" {
  name           = "network_external_1"
  admin_state_up = "true"
  shared = "true"
  external = "true"

  segments { 
    network_type = "flat"
    physical_network = "physnet1"

  }
  # value_specs = {
  #   "provider:network_type"     = "flat"
  #   "provider:physical_network" = "physnet1"
  # }
}

resource "openstack_networking_subnet_v2" "sn_ext1" {
  name            = "subnet_external_1"
  network_id      = openstack_networking_network_v2.nw_ext1.id
  cidr            = "192.168.0.0/24"
  ip_version      = 4
  gateway_ip      = "192.168.0.1"
  enable_dhcp     = false
  dns_nameservers = ["1.1.1.1"]

  allocation_pool {
    start = "192.168.0.200"
    end   = "192.168.0.250"
  }
}
