# This script downloads zones from the CBS and loads them into a PostgreSQL table.
apt-get install -y postgis
wget -O cbs_data.zip https://www.cbs.nl/-/media/cbs/dossiers/nederland-regionaal/wijk-en-buurtstatistieken/wijkbuurtkaart_2019_v1.zip
unzip cbs_data.zip -d cbs_data

cd cbs_data

echo 'Import gemeentes (municipalities) CBS'
shp2pgsql -s 28992:4326 gemeente_2019_v1.shp public.municipalities | psql deelfietsdashboard
echo 'Import wijken (areas) CBS'
shp2pgsql -s 28992:4326 wijk_2019_v1.shp public.areas | psql deelfietsdashboard
echo 'Import buurten (neighboorhoods) CBS'
shp2pgsql -s 28992:4326 buurt_2019_v1.shp public.neighborhoods | psql deelfietsdashboard

# Add shapes from municipalities, residential_areas en neighborhoods to zones.
#psql deelfietsdashboard -f insert_in_zones.sql
#  update zones set area==ST_makevalid(area) where NOT ST_isValid(area);
# Run deze query om zones te fixen.
