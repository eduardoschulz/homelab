resource "openstack_identity_project_v3" "project_1" {
  name        = var.name
  description = var.description
  enabled     = var.enabled
  tags        = var.tags
}

resource "openstack_identity_service_v3" "block_storage" {
  count = var.enable_blockstorage_quotas ? 1 : 0

  name = "cinderv3"
  type = "block-storage"
}

resource "openstack_identity_endpoint_v3" "block_storage" {
  count = var.enable_blockstorage_quotas ? 1 : 0

  service_id      = openstack_identity_service_v3.block_storage[0].id
  interface       = "public"
  name            = "block-storage"
  endpoint_region = var.region
  url             = var.block_storage_endpoint
}

resource "openstack_blockstorage_quotaset_v3" "quotaset_1" {
  count = var.enable_blockstorage_quotas ? 1 : 0

  depends_on = [openstack_identity_endpoint_v3.block_storage]

  project_id = openstack_identity_project_v3.project_1.id
  volumes    = var.volumes
  snapshots  = var.snapshots
  gigabytes  = var.gigabytes
}

resource "openstack_compute_quotaset_v2" "quotaset_1" {
  project_id = openstack_identity_project_v3.project_1.id
  ram        = var.ram
  cores      = var.cores
  instances  = var.instances
}

resource "openstack_networking_quota_v2" "quota_1" {
  project_id          = openstack_identity_project_v3.project_1.id
  floatingip          = var.floatingip
  network             = var.network
  port                = var.port
  rbac_policy         = var.rbac_policy
  router              = var.router
  security_group      = var.security_group
  security_group_rule = var.security_group_rule
  subnet              = var.subnet
  subnetpool          = var.subnetpool
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }
}

resource "openstack_identity_user_v3" "user_1" {
  default_project_id = openstack_identity_project_v3.project_1.id
  name               = "eduardo"
  description        = "eduardo user"
  password           = random_password.password.result
}

data "openstack_identity_role_v3" "member_role" {
  name = var.member_role_name
}

resource "openstack_identity_role_assignment_v3" "eduardo_on_project" {
  user_id    = openstack_identity_user_v3.user_1.id
  project_id = openstack_identity_project_v3.project_1.id
  role_id    = data.openstack_identity_role_v3.member_role.id
}

data "openstack_identity_user_v3" "admin_user" {
  name = var.admin_username
}

data "openstack_identity_role_v3" "admin_role" {
  name = var.admin_role_name
}

resource "openstack_identity_role_assignment_v3" "admin_on_project" {
  user_id    = data.openstack_identity_user_v3.admin_user.id
  project_id = openstack_identity_project_v3.project_1.id
  role_id    = data.openstack_identity_role_v3.admin_role.id
}
