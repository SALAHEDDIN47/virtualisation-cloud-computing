#!/bin/bash
# Déploiement d'une instance à partir du template avec Cloud-Init
export N=app01
export PREFIX=rocky9
export TEMPLATE="/var/lib/libvirt/images/rocky9-template-v1.qcow2"
export INSTANCE_DISK="/var/lib/libvirt/images/${PREFIX}-$N.qcow2"
export SEED="/var/lib/libvirt/boot/${PREFIX}-$N-seed.iso"

# 1. Copie du template
sudo qemu-img convert -p -f qcow2 -O qcow2 "$TEMPLATE" "$INSTANCE_DISK"

# 2. Création de la VM
sudo virt-install \
  --connect qemu:///system \
  --name "${PREFIX}-${N}" \
  --memory 2048 \
  --vcpus 2 \
  --import \
  --disk path="$INSTANCE_DISK",format=qcow2,bus=virtio \
  --disk path="$SEED",device=cdrom,readonly=on \
  --network network=default,model=virtio \
  --channel unix,target_type=virtio,name=org.qemu.guest_agent.0 \
  --os-variant "rocky9" \
  --graphics vnc,listen=127.0.0.1 \
  --noautoconsole
