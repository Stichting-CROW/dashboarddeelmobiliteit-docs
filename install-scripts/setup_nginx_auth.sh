#!/bin/bash

sudo apt-get install nginx -y
export $(grep -v '^#' config | xargs -d '\n')

# Setup nginx for long domain names.
sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/' /etc/nginx/nginx.conf

envsubst < nginx_configs/auth > /etc/nginx/sites-available/$AUTH_URL

ln -s /etc/nginx/sites-available/$AUTH_URL /etc/nginx/sites-enabled/$AUTH_URL 

sudo systemctl reload nginx 
