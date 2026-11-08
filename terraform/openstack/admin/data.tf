data "openstack_identity_project_v3" "admin" {
  project_id = "d77066b3204a4b88a79dc70242df7dad"
}

data "openstack_identity_role_v3" "admin" {
  name = "admin"
}
