#!/bin/bash

set -e
set -o pipefail

PASSWD=$(LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c 15)


#setting up user in proxmox with the right permissions
createToken() {
  echo "Setting up user and token in Proxmox..."
  pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"
  pveum user add terraform-prov@pve --password "$PASSWD"
  pveum aclmod / -user terraform-prov@pve -role TerraformProv

  TOKEN=$(pveum user token add terraform-prov@pve terraform-token --output-format json)

  return 0
}

echo "Password for the terraform user; Save it!: $PASSWD" 

if createToken; then
  echo "Success!"
  echo $TOKEN
else
  echo "Something failed..."
