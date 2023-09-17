#!/bin/bash

sudo apt-get install nginx -y
export $(grep -v '^#' config | xargs -d '\n')

# Setup nginx for long domain names.
sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/' /etc/nginx/nginx.conf

envsubst < nginx_configs/auth > /etc/nginx/sites-available/$AUTH_URL
envsubst < nginx_configs/api_proxy > /etc/nginx/sites-available/$API_PROXY_URL
envsubst < nginx_configs/frontend > /etc/nginx/sites-available/$FRONTEND_URL
envsubst < nginx_configs/mds > /etc/nginx/sites-available/$MDS_URL

ln -s /etc/nginx/sites-available/$AUTH_URL /etc/nginx/sites-enabled/$AUTH_URL 
ln -s /etc/nginx/sites-available/$API_PROXY_URL /etc/nginx/sites-enabled/$API_PROXY_URL
ln -s /etc/nginx/sites-available/$FRONTEND_URL /etc/nginx/sites-enabled/$FRONTEND_URL
ln -s /etc/nginx/sites-available/$MDS_URL /etc/nginx/sites-enabled/$MDS_URL

sudo systemctl reload nginx 
