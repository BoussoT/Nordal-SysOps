# INC-2026-10-27 · Intranet injoignable depuis l'agence de Lyon

| Champ | Valeur |
| --- | --- |
| Référence | INC-2026-10-27 |
| Date | 27/10/2026 |
| Priorité | Haute |
| Service touché | Intranet `intranet.nordal.local` (nginx sur srv-dns) |
| Impact | Les postes de l'agence de Lyon n'accèdent plus à l'intranet. Internet fonctionne. |
| Statut | Résolu |

## Résumé

Une règle du pare-feu de srv-dns refusait les connexions entrantes sur le port 80. Le serveur web fonctionnait, mais les requêtes des postes étaient jetées sans réponse. La règle a été supprimée et l'autorisation du port 80 rétablie.

## Symptôme

Depuis poste-lyon, `curl` reste bloqué après la résolution du nom, sans réponse :

```
* Host intranet.nordal.local:80 was resolved.
* IPv4: 192.168.50.10
*   Trying 192.168.50.10:80...
```

## Diagnostic

| Étape | Commande | Résultat | Conclusion |
| --- | --- | --- | --- |
| Adresse et route | `ip a`, `ip route` | IP et route vers `192.168.50.0/24` présentes | OK |
| Joignabilité | `ping -c 3 192.168.50.10` | réponses | réseau OK |
| Nom | `dig intranet.nordal.local` | `192.168.50.10` | DNS OK |
| Port, depuis le serveur | `nc -zv 192.168.50.10 80` | `succeeded` | nginx écoute |
| Port, depuis le poste | `nc -zv 192.168.50.10 80` | `Connection timed out` | bloqué entre les deux |
| Filtrage | `sudo ufw status verbose` | port 80 en `DENY` | **cause trouvée** |

Le point décisif : le port répondait en local sur le serveur mais pas depuis le poste, et le message était `timed out` (paquets jetés) et non `refused` (personne n'écoute). C'est la signature d'un filtrage, pas d'un service arrêté.

## Cause racine

Une règle `deny 80/tcp` dans le pare-feu ufw de srv-dns, à la place de l'autorisation prévue.

## Résolution

```bash
sudo ufw status numbered
sudo ufw delete deny 80/tcp
sudo ufw allow 80/tcp
sudo ufw status verbose
```

## Vérification

Depuis poste-lyon : `nc -zv 192.168.50.10 80` renvoie `succeeded`, et `curl http://intranet.nordal.local` affiche la page de l'intranet.

## Actions préventives

- Toute modification du pare-feu passe par une demande de changement documentée.
- Les règles du pare-feu sont versionnées (voir [`ufw-regles.sh`](../../config/srv-dns/ufw-regles.sh)) et comparées à l'état réel en cas d'incident.
- Un service se teste toujours depuis un client, jamais seulement depuis le serveur.

## Enseignements

- `Connection timed out` : paquets jetés, donc filtrage. `Connection refused` : la machine répond mais aucun service n'écoute.
- Une connexion qu'un serveur s'envoie à lui-même ne passe pas par les mêmes règles que le trafic entrant : un test local réussi ne garantit pas l'accès des clients.
- ufw applique la première règle qui correspond : un refus placé avant une autorisation l'emporte.
