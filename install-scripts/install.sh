#!/bin/bash

./prepare_install.sh
docker compose -f docker-compose.db.yaml \
    up -d

echo "Wait for 10s to let postgresql start up."
sleep 10
./prepare_db.sh

./run.sh
./setup_nginx.sh

