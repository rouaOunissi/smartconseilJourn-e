#!/bin/bash

set -e  # stoppe le script en cas d’erreur

# Variables à adapter
REPO_URL="https://gitlab.com/rouaounissi5/djangoci.git"
PROJECT_DIR="djangoci"
IMAGE_NAME="roua123/djangoapp"
IMAGE_TAG="latest"
CONTAINER_NAME="djangoapp_container"
PORT=8000
VOLUME_NAME="django_data"  

# Cloner le projet
if [ -d "$PROJECT_DIR" ]; then
  echo "PROJET DEJA CLONE. MISE A JOUR.."
  cd "$PROJECT_DIR"
  git pull
else
  echo "CLONAGE DU PROJET"
  git clone "$REPO_URL"
  cd "$PROJECT_DIR"
fi

# Pull de l’image depuis le registre Docker
echo "PULL DE L IMAGE DOCKER"
docker pull "$IMAGE_NAME:$IMAGE_TAG"

# Créer le volume Docker si inexistant
docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1 || docker volume create "$VOLUME_NAME"

# Tester le déploiment
echo "LANCEMENT DU CONTENEUR POUR TEST"
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
docker run -d \
  --name "$CONTAINER_NAME" \
  --network mynet \
  -v $VOLUME_NAME:/app \
  -p $PORT:8000 \
  "$IMAGE_NAME:$IMAGE_TAG"


# Vérification
echo " TEST DE DEPLOIMENT"
sleep 5
if curl -s http://localhost:$PORT > /dev/null; then
  echo "APP ACCESSIBLE SUR  http://localhost:$PORT"
else
  echo " Le conteneur ne répond pas. Vérifie les logs :"
  docker logs "$CONTAINER_NAME"
fi
