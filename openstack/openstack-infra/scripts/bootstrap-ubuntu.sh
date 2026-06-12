#!/usr/bin/env bash
# =============================================================================
# bootstrap-ubuntu.sh
# OS-level prerequisites for Kolla-Ansible on Ubuntu 24.04 host.
#
# Run ONCE on 192.168.0.10 before the first deploy.
# =============================================================================

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "==> Updating packages..."
apt-get update -q

echo "==> Installing system dependencies..."
apt-get install -y --no-install-recommends \
    python3 python3-dev python3-venv \
    docker.io \
    nfs-common \
    chrony \
    git curl \
    software-properties-common

echo "==> Enabling Docker..."
systemctl enable --now docker

echo "==> Setting up NTP (Chrony)..."
systemctl enable --now chrony
chronyc -a makestep 2>/dev/null || true

echo "==> Loading kernel modules..."
cat > /etc/modules-load.d/kolla-openstack.conf <<'EOF'
8021q
openvswitch
nf_conntrack
EOF
systemctl restart systemd-modules-load

echo "==> Installing Open vSwitch..."
apt-get install -y openvswitch-switch
systemctl enable --now openvswitch-switch

# ---------------------------------------------------------------------------
# Glance NFS mount (host-side)
# Kolla bind-mounts /var/lib/glance/images into the glance-api container
# because glance_file_datadir_volume is set to this path in globals.yml.
# ---------------------------------------------------------------------------
echo "==> Mounting Glance NFS share..."
mkdir -p /var/lib/glance/images
mount -t nfs4 -o rw,hard,intr,noatime 192.168.0.15:/exports/glance /var/lib/glance/images || true

if ! grep -q "192.168.0.15:/exports/glance" /etc/fstab; then
    echo "192.168.0.15:/exports/glance /var/lib/glance/images nfs4 rw,hard,intr,noatime 0 0" >> /etc/fstab
fi

# ---------------------------------------------------------------------------
# Cinder NFS — the cinder-volume container mounts NFS shares directly.
# No host-side mount needed. The nfs_shares file in /etc/kolla/config/cinder/
# is copied into the container, and the NFS driver handles mounting.
# ---------------------------------------------------------------------------

echo ""
echo "===================================================================="
echo " Bootstrap complete."
echo ""
echo " NFS server-side (192.168.0.15) — add to /etc/exports:"
echo "   /exports/glance  192.168.0.10(rw,sync,no_root_squash,no_subtree_check)"
echo "   /exports/cinder  192.168.0.10(rw,sync,no_root_squash,no_subtree_check)"
echo "   Then: exportfs -rav"
echo ""
echo "   no_root_squash is REQUIRED. Container processes writing as root"
echo "   get squashed to nobody without it, causing silent write failures."
echo "===================================================================="
