#!/bin/bash
# Généralisation du template avec virt-sysprep
echo "Copie du disque pour le template..."
sudo qemu-img convert -p -f qcow2 -O qcow2 /var/lib/libvirt/images/rocky9-vm01.qcow2 /var/lib/libvirt/images/rocky9-template-v1.qcow2

echo "Nettoyage des identités (sysprep)..."
sudo virt-sysprep \
  -a /var/lib/libvirt/images/rocky9-template-v1.qcow2 \
  --operations machine-id,ssh-hostkeys,udev-persistent-net,logfiles,tmp-files,bash-history

echo "Template prêt."
