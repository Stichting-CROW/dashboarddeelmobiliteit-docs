#!/bin/bash

./prepare_install.sh
docker compose -f docker-compose.db.yaml \
    up -d

echo "Wait for 5s to let postgresql start up."
sleep 5
./prepare_db.sh

./run.sh
