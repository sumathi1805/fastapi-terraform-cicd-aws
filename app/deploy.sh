#!/bin/bash
# app/deploy.sh

set -e

# Move to app directory
cd "$APP_DIR"

# Write environment variables
echo "IMAGE_TAG=$IMAGE_TAG" > .env
echo "MYSQL_USER=$MYSQL_USER" >> .env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> .env
echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> .env

# Pull and start Docker Compose containers
docker compose -f docker-compose.runtime.yml pull
docker compose -f docker-compose.runtime.yml up -d
