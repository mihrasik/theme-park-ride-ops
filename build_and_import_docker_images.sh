#!/bin/bash

# Define paths to Dockerfiles and image tar files
DOCKERFILES=(
  "containers/app/Dockerfile"
  "containers/mariadb/Dockerfile"
  "containers/lb/Dockerfile"
)

IMAGE_TARS=(
  "docker-images/app.tar"
  "docker-images/mariadb.tar"
  "docker-images/lb.tar"
)

# Function to build and save Docker images
build_and_save_image() {
  local dockerfile=$1
  local image_tar=$2

  # Extract the base name of the Dockerfile (without path)
  local image_name=$(basename "$dockerfile" | sed 's/Dockerfile//')

  echo "Building Docker image for $image_name..."
  docker build -f "$dockerfile" -t "local/$image_name:latest" .

  echo "Saving Docker image to $image_tar..."
  docker save "local/$image_name:latest" -o "$image_tar"
}

# Function to import Docker images into k3s
import_image_to_k3s() {
  local image_tar=$1

  echo "Importing Docker image $image_tar into k3s..."
  k3s ctr images import "$image_tar"
}

# Build and save each Docker image
for i in "${!DOCKERFILES[@]}"; do
  build_and_save_image "${DOCKERFILES[i]}" "${IMAGE_TARS[i]}"
done

# Import each Docker image into k3s
for image_tar in "${IMAGE_TARS[@]}"; do
  import_image_to_k3s "$image_tar"
done

echo "All Docker images have been built and imported into k3s."