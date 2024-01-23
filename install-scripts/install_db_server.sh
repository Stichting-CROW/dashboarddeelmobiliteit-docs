# This script is meant to install a system that is only used as a db server.

./prepare_install.sh
docker compose -f docker-compose.db.yaml \
    up -d

echo "Wait for 10s to let postgresql start up."
sleep 10

echo "Do you want to init the db? (yes/no)"
read response

export $(grep -v '^#' .env | xargs -d '\n')

if [ "$response" == "yes" ]; then
    echo "Database table generated."
    ./prepare_db.sh
else
    createdb -U postgres -h localhost dashboarddeelmobiliteit
fi
