#!/bin/bash
set -e  # arrêter le script si une erreur se produit

# --- Variables ---
CONTAINER="djangoapp_container"
DOSSIER="$HOME/django_backups"
DATE=$(date +'%Y-%m-%d_%H-%M')
FICHIER="$DOSSIER/backup_$DATE.tar.gz"

#  Trouver le volume Docker du conteneur 
VOLUME=$(docker inspect -f '{{ range .Mounts }}{{ .Name }}{{ end }}' $CONTAINER)

# Sauvegarde 
echo " Sauvegarde du volume de $CONTAINER..."
mkdir -p "$DOSSIER"

docker run --rm -v $VOLUME:/data -v $DOSSIER:/backup alpine \
  tar czf /backup/$(basename $FICHIER) -C /data .

echo " Sauvegarde terminée : $FICHIER"
