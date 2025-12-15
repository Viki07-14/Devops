#!/bin/bash
set -e

IMAGE_NAME=online-app
TAG=$(date +%Y%m%d%H%M%S)

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "Tagging image as latest..."
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:latest

echo "Build completed!"
