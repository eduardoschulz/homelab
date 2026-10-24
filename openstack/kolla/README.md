# Kolla

## Setting up venv and kolla-ansible

```bash

python3 -m venv .venv
source .venv/bin/activate

pip install -U pip
```

```bash
git clone --branch stable/2026.2 https://opendev.org/openstack/kolla-ansible
pip install -e ./kolla-ansible
cp -r kolla-ansible/etc/kolla/* .
cp kolla-ansible/ansible/inventory* .

kolla-ansible install-deps
kolla-genpwd
```
