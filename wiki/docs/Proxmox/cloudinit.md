# Setting up a Cloudinit Template for future VMs



## 0. Prerequisites


For this example I'll be using ubuntu-cloudimg. You can either download the image through the terminal or through the
proxmox webui.
```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img /var/lib/vz/templates/iso
```

## 1. Setup VM Template

First step is to create a VM in Proxmox:

```bash
qm create 5000 --name ubuntu-noble-cloudinit
```

Second step is to import the image to the VM using this command:

```bash
qm set 5000 --scsi0 local-lvm:0,import-from=/var/lib/vz/template/iso/noble-server-cloudimg-amd64.img
```

Resize disk to wanted amount:
```bash
qm set 5000 resize 5000 scsi0 15G
```

Add cloud init CD-ROM drive:
```bash
qm set 5000 --ide2 local-lvm:cloudinit
qm set 5000 --boot order=scsi0
```

Enable serial console for VM
```bash
qm set 5000 --serial0 socket --vga serial0
```

Now we can transform this VM into a template. Beware that this step is not reversible, once the vm is converted into a template you can't transform it back.

```bash
qm template 5000
```

## Create a Snippet

Create this directory:

```bash
mkdir /var/lib/vz/snippets
```
 
Edit ```/var/lib/vz/snippets/qemu-guest-agent.yml``` :

```yaml
#cloud-config
runcmd:
  - apt update
  - apt install -y qemu-guest-agent
  - systemctl start qemu-guest-agent
```

