resource "openstack_images_image_v2" "ubuntu2604" {
  name             = "ubuntu-2026.04-LTS"
  image_source_url = "https://cloud-images.ubuntu.com/minimal/releases/resolute/release/ubuntu-26.04-minimal-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  protected = false
  visibility = "public"
}

