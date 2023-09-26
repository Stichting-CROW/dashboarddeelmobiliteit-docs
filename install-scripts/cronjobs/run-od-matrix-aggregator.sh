#!/bin/bash

export $(grep -v '^#' $ENVFILE | xargs -d '\n')
docker run \
    --net backend \
    -e DB_HOST='postgresql' \
    -e DB_NAME='dashboarddeelmobiliteit' \
    -e DB_PASSWORD=$PGPASSWORD \
    -e DB_USER=$POSTGRES_USER \
    -e TZ='Europe/Amsterdam' \
    ghcr.io/stichting-crow/dashboarddeelmobiliteit-od-matrix-aggregator:1.0.1