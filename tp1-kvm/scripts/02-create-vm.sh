#!/bin/bash
# Création de la VM source rocky9-vm01
export VM="rocky9-vm01"
export DISK="/var/lib/libvirt/images/$VM.qcow2"
export ISO="/var/lib/libvirt/boot/rocky9.iso"

sudo virt-install \
  --connect qemu:///system \
  --name "$VM" \
  --memory 2048 \
  --vcpus 2 \
  --disk path="$DISK",size=15,format=qcow2,bus=virtio \
  --cdrom "$ISO" \
  --network network=default,model=virtio \
  --channel unix,target_type=virtio,name=org.qemu.guest_agent.0 \
  --os-variant "rocky9" \
  --graphics vnc,listen=127.0.0.1 \
  --noautoconsole
