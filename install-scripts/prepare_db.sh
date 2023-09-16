#!/bin/bash

# Add .env credentials Fusionauth
if grep -q "DATABASE_FUSIONAUTH_USERNAME" .env
then
    echo "Fusionauth credentials already set"
else
    echo "DATABASE_FUSIONAUTH_USERNAME=fusionauth" >> .env
    echo "DATABASE_FUSIONAUTH_PASSWORD=$(openssl rand -hex 16)" >> .env
    echo "FUSIONAUTH_APP_MEMORY=512M" >> .env
fi

echo $PGPASSWORD
export $(grep -v '^#' .env | xargs -d '\n')
echo $PGPASSWORD

# prepare DB kong
createdb -U postgres -h localhost kong
docker run --rm \
    --network backend \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=postgresql" \
    -e "KONG_PG_USER=postgres" \
    -e "KONG_PG_PASSWORD=$PGPASSWORD" \
    kong kong migrations bootstrap -v

# prepare application DB
mkdir -p sql
cd sql
# Get main table structure
curl -O https://raw.githubusercontent.com/Stichting-CROW/dd-importer-v2/master/sql/main_model.sql
# Get table structure for admin functionality
curl -O https://raw.githubusercontent.com/Stichting-CROW/dashboarddeelmobiliteit-api-admin/main/sql/admin.sql
# Get table structure od aggregation functionality 
curl -O https://raw.githubusercontent.com/Stichting-CROW/dashboarddeelmobiliteit-od-matrix-aggregator/main/sql/od.sql
# Get table for zone aggregation functionality 
curl -O  https://raw.githubusercontent.com/Stichting-CROW/dd-zone-stats-aggregator/main/sql/timescaledb.sql

cd ..
createdb -U postgres -h localhost dashboarddeelmobiliteit
psql dashboarddeelmobiliteit -h '127.0.0.1' -p 5432 -U postgres -f sql/main_model.sql -f sql/admin.sql -f sql/od.sql -f sql/timescaledb.sql