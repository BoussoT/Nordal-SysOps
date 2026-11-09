#!/usr/bin/env bash
# Règles du pare-feu de srv-dns (réseau de l'agence de Lyon)
# Politique par défaut d'ufw : refus en entrée, autorisation en sortie
# Usage : sudo ./ufw-regles.sh
set -euo pipefail

ufw allow OpenSSH        # administration (SSH 22), à ouvrir avant d'activer ufw
ufw allow 53             # DNS (UDP et TCP)
ufw allow 67/udp         # DHCP
ufw allow 80/tcp         # intranet (HTTP)
ufw allow 51820/udp      # VPN WireGuard

ufw --force enable
ufw status verbose
