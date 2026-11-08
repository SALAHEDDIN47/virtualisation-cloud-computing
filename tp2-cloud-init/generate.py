from pathlib import Path
import yaml
from jinja2 import Environment, FileSystemLoader

root = Path(__file__).resolve().parent
inventory = yaml.safe_load((root/'inventory/vms.yml').read_text())
env = Environment(loader=FileSystemLoader(root/'templates'), autoescape=False)
template = env.get_template('user-data.j2')

# Récupérer la clé publique
key = Path.home().joinpath('.ssh/id_ed25519.pub').read_text().strip()

for vm in inventory['vms']:
    # Lire le profil associé
    profile = yaml.safe_load((root/f"profiles/{vm['profile']}.yml").read_text())
    
    # Créer le dossier de sortie
    target = root/f"output/{vm['name']}"
    target.mkdir(parents=True, exist_ok=True)
    
    # Générer user-data et meta-data
    (target/'user-data').write_text(template.render(**vm, **profile, ssh_public_key=key))
    (target/'meta-data').write_text(f"instance-id: iid-{vm['name']}\nlocal-hostname: {vm['hostname']}\n")
    
    # Ajouter le network-config DHCP par défaut
    (target/'network-config').write_text("version: 2\nethernets:\n  enp1s0:\n    dhcp4: true\n")
    
    print(f"Généré : {target}")
