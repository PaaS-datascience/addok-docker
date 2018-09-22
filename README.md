# Conteneurs Addok pour Docker / version scalable

Ces images permettent de simplifier grandement la mise en place d'une instance [addok](https://github.com/addok/addok) **scalable** avec les données de références diffusées par [Etalab](https://www.etalab.gouv.fr).

## Guides d'installation

Les scripts d'installation on été rédigé pour linux, testé sous ubuntu. Leur adaptation est faisable pour d'autres environnements (centos, mac, windows)

### Pré-requis

La version initiale d'addok peut fonctionner dans un environnement de ce type :
* Au moins 6 Go de RAM disponible (à froid)
* 8 Go d'espace disque disponible (hors logs)
* Make
* [Docker CE 1.10+](https://docs.docker.com/engine/installation/)
* [Docker Compose 1.10+](https://docs.docker.com/compose/install/)
* `unzip` ou équivalent
* `wget` ou équivalent

Pour installer les prérequis :
```
make install-prerequisites
```

La configuration initiale de la scalabilité proposée (8 workers) est faite pour fonctionner avec au moins 16vCPUs mais peut fonctionner avec un laptop en downscalant.

### Installer une instance avec les données de la Base Adresse Nationale en ODbL

Tout d'abord placez vous dans un dossier de travail, appelez-le par exemple `ban`.

#### Télécharger les données pré-indexées

```
make download
```

#### Démarrer l'instance

L'instance par défaut installe par défaut 2x8 workers et 2 instances redis:
```
make up
```

Suivant les performances de votre machine, l'instance mettra entre 30 secondes et 2 minutes à démarrer effectivement, le temps de charger les données dans la mémoire vive.

* 90 secondes sur une VPS-SSD-3 OVH (2 vCPU, 8 Go)
* 50 secondes sur une VM EG-15 OVH (4 vCPU, 15 Go)

Par défaut l'instance écoute sur le port `7878`.

#### Tester l'instance

```bash
curl "http://localhost:7878/search?q=1+rue+de+la+paix+paris"
```

### Paramètres avancés

Vous pouvez surcharger les paramètres par défaut en les ajoutant dans le fichier `artifacts`

| Nom du paramètre | Description |
| ----- | ----- |
| `PORT` | port d'exposition nginx . Valeur par défaut: `7878` |
| `ADDOK_NODES` | Nombre de noeuds addok à lancer. Valeur par défaut : `2`. |
| `WORKERS` | Nombre de workers addok à lancer pour chaque noeud. Valeur par défaut : `8`. |
