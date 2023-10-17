#!/bin/bash

# Install docker compose
./install_docker-compose.sh

# Generate random postgresql password
if grep -q "PGPASSWORD" .env
then
    echo "Database environment variables already exist"
else
    echo "PGPASSWORD=$(openssl rand -hex 16)" >> .env
    echo "POSTGRES_USER=postgres" >> .env
fi
export $(grep -v '^#' .env | xargs -d '\n')


# Install helpfull utilities.
sudo apt-get install postgresql-client redis-tools -y
docker network create backend

echo '{
  "log-driver": "local"
}' > /etc/docker/daemon.json
