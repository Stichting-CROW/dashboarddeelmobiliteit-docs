#!/bin/bash

docker compose -f docker-compose.db.yaml \
    -f docker-compose.api-services.yaml \
    -f docker-compose.data-services.yaml \
    -f docker-compose.gateway.yaml \
    -f docker-compose.frontend.yaml \
    up -d
