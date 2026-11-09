# Captures d'écran

Captures à ajouter dans ce dossier (format PNG) :

| Fichier | Contenu |
| --- | --- |
| `tcpdump-wg0.png` | `sudo tcpdump -n -A -i wg0` sur srv-dns : la requête `GET /` et la page « Intranet Nordal » lisibles dans le tunnel |
| `tcpdump-ens37.png` | `sudo tcpdump -n -A -i ens37 udp port 51820` sur srv-dns : le même échange, chiffré et illisible |
| `wg-show.png` | `sudo wg show` sur poste-lyon : pair connecté, `latest handshake` récent, clé privée masquée |
| `dnsmasq-leases.png` | `cat /var/lib/misc/dnsmasq.leases` sur srv-dns : bail DHCP attribué à poste-lyon |

Avant d'ajouter une capture, vérifier qu'aucune clé privée ni aucun mot de passe n'y apparaît.
