#!/bin/bash

./prepare_install.sh
docker compose -f docker-compose.db.yaml \
    up -d

echo "Wait for 5s to let postgresql start up."
sleep 5
./prepare_db.sh

docker compose -f docker-compose.db.yaml \
    -f docker-compose.api-services.yaml \
    -f docker-compose.data-services.yaml \
    -f docker-compose.gateway.yaml \
    up -d
