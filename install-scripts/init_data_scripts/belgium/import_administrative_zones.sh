# This script downloads zones from the CBS and loads them into a PostgreSQL table.
export $(grep -v '^#' ../../.env | xargs -d '\n')

apt-get install -y postgis unzip
wget -O statistical_sectors_belgium.zip https://statbel.fgov.be/sites/default/files/files/opendata/Statistische%20sectoren/sh_statbel_statistical_sectors_3812_20230101.shp.zip
unzip statistical_sectors_belgium.zip  

# hardcoded for now
cd sh_statbel_statistical_sectors_3812_20230101.shp
# rm statistical_sectors_belgium.zip


echo 'Import statistical sectors'
shp2pgsql -s 3812:4326 sh_statbel_statistical_sectors_3812_20230101.shp  public.statistical_sectors_belgium | psql dashboarddeelmobiliteit -h localhost -p 5432 -U postgres

psql -h localhost -U postgres dashboarddeelmobiliteit -f transform_data.sql
