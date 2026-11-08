output "vmid" {
  description = "The VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "The VM name"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ipv4_addresses" {
  description = "The VM's IPv4 addresses"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}
