# Setup Terraform in Proxmox 9

To use a terraform provider for proxmox you first need to setup a user exclusive for terraform.

## 1.Create a Terraform User
```bash
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve --password YOUR_PASSWORD
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

If for some reason you need to modify the role's permissions:
```bash
pveum role modify TerraformProv -privs "Datastore.AllocateSpace ..."
```

## 2.Create a Terraform Token
```bash
pveum user token add terraform-prov@pve terraform-token --privsep 0
```
