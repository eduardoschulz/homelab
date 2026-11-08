terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

provider "openstack" { 
  tenant_name           = "admin"
  project_domain_name   = "Default"
}
