# Virtualisation et Cloud Computing (TP1 & TP2)

Ce dépôt contient l'ensemble des travaux pratiques réalisés dans le cadre du cours de Virtualisation et Cloud Computing. Il documente la mise en place d'une infrastructure virtualisée avec KVM/QEMU, ainsi que l'automatisation du déploiement et de la configuration avec Cloud-Init et Jinja2.

## 🛠️ Prérequis et Résolution de problèmes (Virtualisation imbriquée)

Pour exécuter ce projet, l'environnement hôte doit supporter la virtualisation imbriquée (Nested Virtualization). Lors de la phase de test sous Windows 11 avec VMware Workstation, une erreur `Virtualized Intel VT-x/EPT is not supported` est apparue. 

**Cause :** Les fonctionnalités de sécurité de Windows (Hyper-V, VBS, Windows Hello) verrouillaient les extensions matérielles VT-x, empêchant VMware et KVM d'y accéder.

**Procédure de résolution appliquée :**
1. Désactivation des fonctionnalités Windows via `optionalfeatures.exe` : Hyper-V, Plateforme d'hyperviseur Windows, Plateforme de machine virtuelle, et Bac à sable Windows.
2. Désactivation de l'Isolation du noyau (Intégrité de la mémoire) dans Sécurité Windows.
3. Désactivation du lanceur d'hyperviseur via l'invite de commande : `bcdedit /set hypervisorlaunchtype off`.
4. Désactivation de la VBS (Virtualization-Based Security) via le Registre (`HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard` -> `EnableVirtualizationBasedSecurity = 0`).
5. Suppression du code PIN Windows Hello et désactivation de son scénario dans le registre.
6. Désactivation forcée de VBS via l'outil officiel de Microsoft (`DG_Readiness_Tool`) ou via la touche `F3` au démarrage.

Une fois la virtualisation matérielle libérée, les VM Rocky Linux 9 ont pu être déployées avec succès.

---

## 📂 Architecture du Dépôt

- **tp1-kvm/** : Scripts Bash automatisant la gestion de l'infrastructure KVM.
- **tp2-cloud-init/** : Code Python et fichiers YAML pour l'automatisation Cloud-Init.
- **tp3-ansible/** : (En cours) Espace dédié à la configuration continue avec Ansible.

---

## 💻 TP1 : Virtualisation avec KVM/QEMU et libvirt

L'objectif du TP1 était de maîtriser le cycle de vie d'une VM : création, administration, clonage, capture d'image, et généralisation en template.

**Points clés réalisés :**
- Diagnostic de l'environnement KVM et installation des paquets (`qemu-kvm`, `libvirt`, `virt-install`, `guestfs-tools`).
- Création d'une VM source `rocky9-vm01` et administration via `virsh`.
- Réalisation d'un clone complet (`virt-clone`) et analyse des identités (MAC, UUID, machine-id, clés SSH).
- Capture d'une image système QCOW2 et test de réimportation.
- Généralisation d'un template (`virt-sysprep`) pour préparer le déploiement Cloud-Init.

**Scripts disponibles (dans `tp1-kvm/scripts/`) :**
- `01-install.sh` : Installation de l'environnement.
- `02-create-vm.sh` : Création de la VM initiale.
- `03-clone-vm.sh` : Clonage complet.
- `04-create-template.sh` : Généralisation de l'image.
- `05-import.sh` : Déploiement initial avec Cloud-Init.

---

## ☁️ TP2 : Automatisation avec Cloud-Init et Jinja2

L'objectif du TP2 était d'industrialiser le déploiement de VM grâce à la séparation entre les données (inventaire), la logique (template Jinja2) et la configuration au premier démarrage (Cloud-Init).

**Points clés réalisés :**
- Découverte de l'architecture Cloud-Init (datasources NoCloud).
- Création manuelle de fichiers `user-data`, `meta-data`, et `network-config` injectés via une ISO (`genisoimage`).
- Mise en place de profils réutilisables (`web.yml`, `db.yml`, `admin.yml`).
- Écriture d'un script Python (`generate.py`) utilisant `PyYAML` et `Jinja2` pour générer dynamiquement les configurations.
- Déploiement automatisé de 3 VM distinctes à partir du template du TP1 :
  - `web01` (Nginx)
  - `db01` (MariaDB)
  - `admin01` (Outils d'administration)
- Validation de la configuration via `cloud-init status` et `cloud-init schema`.

---

## 🚀 Reproduction du projet

Pour reproduire ce projet sur une machine Rocky Linux 9 (hôte) :

1. **Cloner le dépôt :**
   git clone https://github.com/SALAHEDDIN47/virtualisation-cloud-computing.git

2. **Préparer le TP1 :**
   cd virtualisation-cloud-computing/tp1-kvm/scripts
   sudo ./01-install.sh

3. **Préparer le TP2 :**
   cd ../../tp2-cloud-init
   python3 -m venv .venv
   source .venv/bin/activate
   pip install Jinja2 PyYAML
   python generate.py

4. **Déployer une VM :**
   (Les instructions détaillées de déploiement via virt-install sont documentées dans le README du TP2).

---
*Auteur : SALAHEDDIN47 - Étudiant en Cloud Computing & Virtualisation.*
