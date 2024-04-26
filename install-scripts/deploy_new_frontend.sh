#!/bin/bash

. ~/.bashrc

cd dashboarddeelmobiliteit-app-main

nvm use 18
npm install
npm run build

mkdir -p /srv/www/frontend
cp -a build/. /srv/www/frontend/
chown -R www-data:www-data /srv/www/frontend/