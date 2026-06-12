#!/usr/bin/env bash
# =============================================================================
# deploy.sh — Kolla-Ansible GitOps pipeline (single-node)
#
# Prerequisites:
#   1. scripts/bootstrap-ubuntu.sh must have been run on the target node
#   2. /etc/kolla/globals.yml and /etc/kolla/passwords.yml must exist
#   3. Kolla-Ansible reads both from /etc/kolla/ automatically
#
# Usage:
#   ./scripts/deploy.sh [--skip-bootstrap] [--skip-pull] [--skip-prechecks]
#   ./scripts/deploy.sh --smoke-test
# =============================================================================

set -euo pipefail

KOLLA_VERSION="${KOLLA_VERSION:-17.0.0}"
VENV_DIR="${VENV_DIR:-$HOME/kolla-venv}"
INVENTORY="${INVENTORY:-inventory/all-in-one}"

log()   { echo "[$(date '+%H:%M:%S')] $*"; }
die()   { log "ERROR: $*"; exit 1; }

SKIP_BOOTSTRAP=false
SKIP_PULL=false
SKIP_PRECHECKS=false
DO_SMOKE=false

for arg in "$@"; do
    case "$arg" in
        --skip-bootstrap) SKIP_BOOTSTRAP=true ;;
        --skip-pull)      SKIP_PULL=true ;;
        --skip-prechecks) SKIP_PRECHECKS=true ;;
        --smoke-test)     DO_SMOKE=true ;;
        *) die "Unknown argument: $arg" ;;
    esac
done

# ------------------------------------
# Smoke test
# ------------------------------------
if $DO_SMOKE; then
    [ -f /etc/kolla/clouds.yaml ] || die "/etc/kolla/clouds.yaml not found. Run deploy first."
    export OS_CLIENT_CONFIG_FILE=/etc/kolla/clouds.yaml

    log "Uploading Cirros image..."
    openstack image create "cirros-smoke" \
        --file /tmp/cirros-0.6.3-x86_64-disk.img \
        --disk-format qcow2 \
        --container-format bare \
        --public

    log "Creating volume..."
    openstack volume create --size 1 smoke-vol

    log "Booting instance..."
    openstack server create smoke-instance \
        --flavor m1.tiny \
        --image cirros-smoke \
        --network public1 \
        --wait

    log "Attaching volume..."
    openstack server add volume smoke-instance smoke-vol

    log "Assigning floating IP..."
    FIP=$(openstack floating ip create public1 -f value -c floating_ip_address)
    openstack server add floating ip smoke-instance "$FIP"
    log "Floating IP: $FIP"
    log "Smoke test PASSED."
    exit 0
fi

# ------------------------------------
# 0. Ensure kolla configs are in place
# ------------------------------------
log "Ensuring /etc/kolla/ configs..."
sudo mkdir -p /etc/kolla

if [ ! -f /etc/kolla/globals.yml ]; then
    sudo cp etc/kolla/globals.yml /etc/kolla/globals.yml
    log "  -> globals.yml copied to /etc/kolla/"
fi

if [ ! -f /etc/kolla/passwords.yml ]; then
    die "/etc/kolla/passwords.yml not found.  Generate it with: kolla-genpwd"
fi

if [ -d etc/kolla/config ] && [ ! -d /etc/kolla/config ]; then
    sudo cp -r etc/kolla/config /etc/kolla/config
    log "  -> config/ copied to /etc/kolla/"
fi

# ------------------------------------
# 1. Virtualenv + Kolla-Ansible
# ------------------------------------
if [ ! -d "$VENV_DIR" ]; then
    log "Creating virtualenv at $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"

if ! pip show kolla-ansible >/dev/null 2>&1; then
    log "Installing Kolla-Ansible ${KOLLA_VERSION} and ansible-core..."
    pip install --upgrade pip
    pip install 'ansible-core>=2.15,<2.16.99'
    pip install "kolla-ansible==${KOLLA_VERSION}"
fi

log "Installing Ansible Galaxy dependencies..."
kolla-ansible install-deps

# ------------------------------------
# 2. Bootstrap servers
# ------------------------------------
if ! $SKIP_BOOTSTRAP; then
    log "Bootstrapping servers..."
    kolla-ansible -i "$INVENTORY" bootstrap-servers
fi

# ------------------------------------
# 3. Pre-deployment checks
# ------------------------------------
if ! $SKIP_PRECHECKS; then
    log "Running prechecks..."
    kolla-ansible -i "$INVENTORY" prechecks
fi

# ------------------------------------
# 4. Pull container images
# ------------------------------------
if ! $SKIP_PULL; then
    log "Pulling container images..."
    kolla-ansible -i "$INVENTORY" pull
fi

# ------------------------------------
# 5. Deploy
# ------------------------------------
log "Deploying OpenStack..."
kolla-ansible -i "$INVENTORY" deploy

# ------------------------------------
# 6. Post-deploy
# ------------------------------------
log "Running post-deploy..."
kolla-ansible -i "$INVENTORY" post-deploy

log "Deployment complete!"
log "Credentials: /etc/kolla/clouds.yaml"
log ""
log "=== Next steps ==="
log "  export OS_CLIENT_CONFIG_FILE=/etc/kolla/clouds.yaml"
log ""
log "  openstack network create --share --external \\"
log "    --provider-physical-network physnet1 \\"
log "    --provider-network-type flat public1"
log ""
log "  openstack subnet create --network public1 \\"
log "    --allocation-pool start=192.168.0.200,end=192.168.0.250 \\"
log "    --subnet-range 192.168.0.0/24 \\"
log "    --gateway 192.168.0.1 public1-subnet"
log ""
log "  ./scripts/deploy.sh --smoke-test"
