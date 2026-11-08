#!/bin/bash
# Clonage de la VM source vers rocky9-vm02
sudo virt-clone \
  --connect qemu:///system \
  --original rocky9-vm01 \
  --name rocky9-vm02 \
  --file /var/lib/libvirt/images/rocky9-vm02.qcow2 \
  --check disk_size=off
