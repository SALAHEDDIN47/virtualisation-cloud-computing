# TP1 - Virtualisation avec KVM/QEMU et libvirt

Ce dépôt contient le travail réalisé pour le TP1 (Parcours Rocky Linux 9).

## Contenu du projet

- **`isos/`** : Contiendra les images d'installation (non incluses pour des raisons de taille).
- **`images/`** : Contiendra les disques QCOW2 des VM (`rocky9-vm01`, `rocky9-vm02`, etc.).
- **`templates/`** : Contiendra l'image de référence généralisée avec `virt-sysprep`.
- **`scripts/`** : Contient les scripts d'automatisation Bash retraçant tout le TP.

## Exécution des scripts

1. **Préparation de l'hôte** : `./scripts/01-install.sh`
2. **Création de la VM source** : `./scripts/02-create-vm.sh`
3. **Clonage complet** : `./scripts/03-clone-vm.sh`
4. **Généralisation (Template)** : `./scripts/04-create-template.sh`
5. **Déploiement automatisé (Cloud-Init)** : `./scripts/05-import.sh`

## Choix techniques et conclusions

- Le clonage (`virt-clone`) duplique les identités virtuelles (MAC, UUID) mais conserve les identités internes (machine-id, clés SSH).
- Le template a été nettoyé via `virt-sysprep` pour garantir des identités uniques à chaque déploiement.
- Le déploiement d'instances (`app01`, `app02`) repose sur Cloud-Init (NoCloud) qui permet de personnaliser le hostname, les utilisateurs et les clés SSH sans réinstallation.

*Note : Les fichiers volumineux (`.iso`, `.qcow2`) sont exclus de ce dépôt via le `.gitignore`.*
