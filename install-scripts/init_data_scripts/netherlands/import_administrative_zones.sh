# This script downloads zones from PDOK and loads them into a PostgreSQL table.
export $(grep -v '^#' ../../.env | xargs -d '\n')

# Download from PDOK
# https://www.pdok.nl/atom-downloadservices/-/article/cbs-wijken-en-buurten#3af4dfc5c041640dbd8e17c9b69c8356
wget https://service.pdok.nl/cbs/wijkenbuurten/2022/atom/downloads/wijkenbuurten_2022_v1.gpkg

# Add shapes from municipalities, residential_areas en neighborhoods to zones.
ogr2ogr -t_srs "EPSG:4326" -f PostgreSQL "PG:dbname=dashboarddeelmobiliteit user=postgres port=5432 host=localhost" wijkenbuurten_2022_v1.gpkg --config OGR_TRUNCATE YES
psql -U postgres -d dashboarddeelmobiliteit -f insert_in_zones.sql -h localhost