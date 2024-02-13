# This script is meant to install a system that is only used as a db server.

docker compose -f docker-compose.db.yaml \
    -f docker-compose.auth.yaml \
    up -d
