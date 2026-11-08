# TP2 - Personnalisation et Automatisation avec Cloud-Init

Ce projet déploie une infrastructure de 3 machines virtuelles (web, db, admin) à partir de l'image généralisée du TP1, en utilisant Cloud-Init (NoCloud) et la génération de templates Jinja2.

## Architecture du projet

- images/ : Contient les fichiers ISO (seeds) générés.
- profiles/ : Définit les rôles des serveurs (web.yml, db.yml, admin.yml).
- templates/ : Contient le modèle user-data.j2.
- inventory/ : Contient vms.yml (liste des VM à créer).
- output/ : Contient les configurations générées (user-data, meta-data, network-config).
- generate.py : Script Python qui assemble l'inventaire, les profils et le template Jinja2.

## Procédure de déploiement

1. Générer les configurations :
   python3 -m venv .venv
   source .venv/bin/activate
   pip install Jinja2 PyYAML
   python generate.py

2. Créer les ISO NoCloud :
   for vm in vm-web vm-db vm-admin; do
     genisoimage -output images/${vm}-seed.iso -volid cidata -joliet -rock output/$vm/user-data output/$vm/meta-data output/$vm/network-config
   done

3. Déployer les VM (exemple pour vm-web) :
   sudo qemu-img convert -f qcow2 -O qcow2 /var/lib/libvirt/images/rocky9-template-v1.qcow2 /var/lib/libvirt/images/vm-web.qcow2
   sudo virt-install --name vm-web --memory 2048 --vcpus 2 --import --disk path=/var/lib/libvirt/images/vm-web.qcow2,format=qcow2 --disk path=/var/lib/libvirt/boot/vm-web-seed.iso,device=cdrom --network network=default --os-variant rocky9 --noautoconsole

## Résultats obtenus

- web01 : Nginx installé et actif. curl localhost renvoie la page par défaut.
- db01 : MariaDB installé et actif.
- admin01 : Outils installés (sauf htop, à activer via EPEL).

## Choix techniques

- Jinja2 permet de séparer la logique de configuration des données (inventaire).
- Cloud-init (NoCloud) permet une configuration 100% automatisée au premier démarrage (utilisateurs, clés SSH, paquets).
- Pas de clé privée dans le dépôt : seule la clé publique est injectée via le template.
