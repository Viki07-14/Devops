#!/bin/bash
set -e

echo "Stopping old containers and removing orphans..."
docker-compose down --remove-orphans || true

echo "Starting new containers..."
docker-compose up -d

echo "Deployment completed!"
