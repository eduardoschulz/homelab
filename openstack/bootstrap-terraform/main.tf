terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

# TODO: check if cloud.yaml is enough
provider "openstack" {
  user_name = "${var.user_name}" 
  tenant_name = "${var.tenant_name}" #tenant == project 
  password = "${var.password}"
  auth_url = "${var.auth_url}"
}
