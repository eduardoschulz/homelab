resource "openstack_identity_user_v3" "iac-user" {
  default_project_id                  = data.openstack_identity_project_v3.admin.id
  name                                = "iac-user"
  description                         = "a user to do iac stuff and more"
  ignore_change_password_upon_first_use = true

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}

resource "openstack_identity_role_assignment_v3" "role_assignment" {
   user_id = openstack_identity_user_v3.iac-user.id
   project_id = data.openstack_identity_project_v3.admin.id
   role_id = data.openstack_identity_role_v3.admin.id
}

resource "openstack_identity_inherit_role_assignment_v3" "iac_core" {
  user_id   = openstack_identity_user_v3.iac-user.id
  domain_id = openstack_identity_project_v3.core.id
  role_id   = data.openstack_identity_role_v3.admin.id
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "openstack_identity_user_v3" "eduardo" {
  default_project_id                  = openstack_identity_project_v3.core-primary.id
  name                                = "eduardo"
  ignore_change_password_upon_first_use = true
  password = random_password.password.result

  lifecycle {
    ignore_changes = [
      password,
    ]
  }

}

resource "openstack_identity_role_assignment_v3" "role_assignment_eduardo" {
   user_id = openstack_identity_user_v3.eduardo.id
   project_id = openstack_identity_project_v3.core-primary.id
   role_id = data.openstack_identity_role_v3.admin.id
}

resource "openstack_identity_role_assignment_v3" "role_assignment_eduardo_exp" {
   user_id = openstack_identity_user_v3.eduardo.id
   project_id = openstack_identity_project_v3.exp_proj.id
   role_id = data.openstack_identity_role_v3.admin.id
}
