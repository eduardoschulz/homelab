#Set your public SSH key here
variable "ssh_key" {
}
#Establish which Proxmox host you'd like to spin a VM up on
variable "proxmox_host" {
    default = "delta-px"
}
#Specify which template name you'd like to use
variable "template_name" {
    default = "ubuntu-noble-cloudinit-template"
}
#Establish which nic you would like to utilize
variable "nic_name" {
    default = "vmbr0"
}
#Establish the VLAN you'd like to use
# variable "vlan_num" {
#     default = "place_vlan_number_here"
# }

#Provide the url of the host you would like the API to communicate on.
#It is safe to default to setting this as the URL for what you used
#as your `proxmox_host`, although they can be different
variable "api_url" {
    default = "https://192.168.0.130:8006/api2/json"
}
#Blank var for use by terraform.tfvars
variable "token_secret" {
}
#Blank var for use by terraform.tfvars
variable "token_id" {
}
