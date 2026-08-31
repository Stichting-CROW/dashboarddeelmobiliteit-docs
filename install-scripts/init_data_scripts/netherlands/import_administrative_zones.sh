# This script downloads zones from PDOK and loads them into a PostgreSQL table.
export $(grep -v '^#' ../../.env | xargs -d '\n')

# Download from PDOK
# https://www.pdok.nl/-/nieuwe-dataset-cbs-wijken-en-buurten-2026-beschikbaar-bij-pdok
wget https://service.pdok.nl/cbs/wijken-en-buurten-2026/atom/downloads/WijkBuurtkaart_2026_v0.gpkg

# Add shapes from municipalities, residential_areas en neighborhoods to zones.
ogr2ogr -t_srs "EPSG:4326" -f PostgreSQL "PG:dbname=dashboarddeelmobiliteit user=postgres port=5432 host=localhost" WijkBuurtkaart_2026_v0.gpkg --config OGR_TRUNCATE YES
psql -U postgres -d dashboarddeelmobiliteit -f insert_in_zones.sql -h localhost