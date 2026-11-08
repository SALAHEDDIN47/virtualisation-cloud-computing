#!/bin/bash
# Installation des outils KVM/libvirt sur Rocky Linux 9
echo "Installation des paquets..."
sudo dnf install -y qemu-kvm libvirt virt-install virt-manager virt-viewer qemu-img guestfs-tools genisoimage libguestfs-tools-c

echo "Activation de libvirtd..."
sudo systemctl enable --now libvirtd

echo "Ajout de l'utilisateur au groupe libvirt..."
sudo usermod -aG libvirt "$USER"

echo "Vérification de KVM..."
ls -l /dev/kvm
