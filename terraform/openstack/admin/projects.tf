resource "openstack_identity_project_v3" "core" {
  is_domain = true
  name = "core"
  description = "A Core Domain for core infrastructure and services" 
}

resource "openstack_identity_project_v3" "core-primary" {
  name = "core-primary"
  domain_id = openstack_identity_project_v3.core.id
  description = "primary workloads" 
}

resource "openstack_identity_project_v3" "exp" {
  is_domain = true
  name = "experimental"
  description = "a domain to f around and find out" 
}

resource "openstack_identity_project_v3" "exp_proj" {
  name = "experimental"
  domain_id = openstack_identity_project_v3.exp.id
}
