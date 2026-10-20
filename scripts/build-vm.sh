#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Bugema Linux Development Environment - VM build script
# Student : NAMBALIRWA JOVIA (24/BCC/BU/R/0003)
# Host    : Ubuntu 24.04 LTS, Intel i5-8350U, 8 threads, 7.6 GiB RAM, /dev/kvm
# Guest   : Ubuntu LTS (amd64) official cloud image, provisioned with cloud-init
# Resources: 2 vCPU, 4 GB RAM, 40 GB disk, NAT networking, 64-bit
# ---------------------------------------------------------------------------
set -euo pipefail

WORK=/home/medisoft/Desktop/bugema-work
PREFIX=$WORK/qemu-prefix
export LD_LIBRARY_PATH=$PREFIX/usr/lib/x86_64-linux-gnu:$PREFIX/usr/lib:${LD_LIBRARY_PATH:-}
export QEMU_LD_PREFIX=$PREFIX/usr
QEMU=$PREFIX/usr/bin/qemu-system-x86_64
QEMU_IMG=$PREFIX/usr/bin/qemu-img
CLOUD_LOCALDS=$PREFIX/usr/bin/cloud-localds

VM_DIR=$WORK/vm
ISO_DIR=$WORK/iso
DISK=$VM_DIR/bugema-linux.qcow2
SEED=$VM_DIR/seed.iso
SSH_KEY=$HOME/.ssh/id_ed25519
SSH_PORT=2222
VNC_DISPLAY=1
QMP_PORT=4444
GUEST_USER=jovian

mkdir -p "$VM_DIR" "$WORK/evidence"

echo "==> [1/6] Selecting the guest image"
IMG=""
for cand in "$ISO_DIR/ubuntu-26.04-server-cloudimg-amd64.img" \
            "$ISO_DIR/noble-server-cloudimg-amd64.img"; do
  if [ -s "$cand" ]; then IMG="$cand"; break; fi
done
if [ -z "$IMG" ]; then echo "no guest image available"; exit 1; fi
echo "    guest image: $IMG ($(stat -c%s "$IMG") bytes)"

echo "==> [2/6] Creating the 40 GB qcow2 disk (virtio)"
rm -f "$DISK"
cp "$IMG" "$DISK"
"$QEMU_IMG" resize "$DISK" 40G
"$QEMU_IMG" info "$DISK" | sed 's/^/    /'

echo "==> [3/6] Building the cloud-init seed (user, SSH key, packages)"
PUBKEY=$(cat "$SSH_KEY.pub")
cat > "$VM_DIR/user-data" <<EOF
#cloud-config
hostname: bugema-dev
manage_etc_hosts: true
timezone: Africa/Kampala

users:
  - name: $GUEST_USER
    gecos: NAMBALIRWA JOVIA
    groups: [adm, sudo]
    shell: /bin/bash
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    lock_passwd: false
    plain_text_passwd: "Bugema@2026"
    ssh_authorized_keys:
      - $PUBKEY

package_update: true
packages:
  - git
  - openssh-server
  - python3
  - curl
  - vim
  - net-tools

runcmd:
  - [ sh, -c, "systemctl enable --now ssh" ]

final_message: "Bugema Linux development environment ready"
EOF

cat > "$VM_DIR/meta-data" <<EOF
instance-id: bugema-linux-dev-01
local-hostname: bugema-dev
EOF

"$CLOUD_LOCALDS" "$SEED" "$VM_DIR/user-data" "$VM_DIR/meta-data"
echo "    seed built: $SEED"

echo "==> [4/6] Booting the virtual machine (2 vCPU, 4 GB RAM, NAT, VNC :$VNC_DISPLAY)"
"$QEMU" \
  -name Bugema-Linux-Development \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 2 \
  -m 4096 \
  -drive "file=$DISK,if=virtio,format=qcow2,cache=writeback" \
  -drive "file=$SEED,if=virtio,format=raw,readonly=on" \
  -netdev user,id=net0,hostfwd=tcp:127.0.0.1:$SSH_PORT-:22 \
  -device virtio-net-pci,netdev=net0 \
  -device virtio-vga \
  -display none \
  -vnc 127.0.0.1:$VNC_DISPLAY \
  -qmp "tcp:127.0.0.1:$QMP_PORT,server=on,wait=off" \
  -pidfile "$VM_DIR/qemu.pid" \
  -daemonize
sleep 5
echo "    QEMU pid: $(cat "$VM_DIR/qemu.pid" 2>/dev/null || echo unknown)"

echo "==> [5/6] Waiting for cloud-init to finish provisioning"
SSHOPTS="-i $SSH_KEY -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -o BatchMode=yes"
for i in $(seq 1 120); do
  if ssh $SSHOPTS "$GUEST_USER@127.0.0.1" true 2>/dev/null; then
    echo "    SSH is up after $((i*10)) seconds - waiting for cloud-init"
    break
  fi
  echo "    ... waiting for SSH ($((i*10))s)"
  sleep 10
  if [ "$i" = "120" ]; then echo "    SSH did not come up"; exit 1; fi
done
ssh $SSHOPTS "$GUEST_USER@127.0.0.1" 'sudo cloud-init status --wait' 2>&1 | tail -2

echo "==> [6/6] VM is running"
echo "    ssh -i $SSH_KEY -p $SSH_PORT $GUEST_USER@127.0.0.1"
echo "    VNC display: 127.0.0.1:$((VNC_DISPLAY+5900))"
