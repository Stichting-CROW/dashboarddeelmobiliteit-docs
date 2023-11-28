export $(grep -v '^#' ../../.env | xargs -d '\n')
echo 'Be aware the feeds that are added are not completely suitable to be used in the dashboard because they use rotating ids';

psql -h localhost -U postgres dashboarddeelmobiliteit -f open_data_feeds.sql