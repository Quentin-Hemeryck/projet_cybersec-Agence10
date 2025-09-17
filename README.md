# Projet Cybersécurité - Agence 10

## Description

Projet académique de déploiement et sécurisation d'une infrastructure réseau multisite dans le cadre du cours de Cybersécurité à la Haute École en Hainaut.

## Équipe

- **Hemeryck Quentin** - quentin.hemeryck@std.heh.be
- **Lubanguku Lua Ntoto Esdras** - esdras.lubangukuluantoto@std.heh.be

**Encadrant :** M. Mandoux  
**Année académique :** 2024-2025

## Objectifs

- Déployer un réseau local segmenté avec VLANs
- Sécuriser l'infrastructure avec pare-feu FortiGate
- Configurer les services réseau (DHCP, routage, filtrage)
- Héberger un serveur web en zone DMZ

## Architecture

### Équipements utilisés
- **Switch :** Cisco Catalyst 1000 Series
- **Pare-feu :** FortiGate 60E  
- **Routeur :** Cisco 8200 Edge Series (partagé avec Agence 11)
- **Serveur :** AlmaLinux en machine virtuelle

### Plan d'adressage
Réseau principal : `172.29.x.0/24`

| VLAN | Service | Réseau |
|------|---------|--------|
| 10 | Informatique | 172.29.10.0/24 |
| 15 | Commerciaux | 172.29.15.0/24 |
| 20 | Technique | 172.29.20.0/24 |
| 25 | Finances | 172.29.25.0/24 |
| 50 | Gestion | 172.29.50.0/24 |
| ... | ... | ... |

**DMZ :** 172.29.250.0/24 (Serveur web : 172.29.250.40)

## Contenu du dépôt

```
├── scripts/           # Scripts de configuration et déploiement
├── topologie/         # Schémas et plans réseau
└── README.md
```

## Sécurité implémentée

- **Switch :** Port-security, DHCP Snooping, protection VLAN hopping
- **Pare-feu :** Filtrage applicatif, antivirus, segmentation par zones
- **Général :** Durcissement des configurations, accès SSH sécurisé

## Utilisation

1. Consulter les schémas dans `topologie/` pour comprendre l'architecture
2. Utiliser les scripts de `scripts/` pour le déploiement automatique
3. Adapter les configurations selon votre environnement

---

**Confidentialité :** Usage interne HEH uniquement
