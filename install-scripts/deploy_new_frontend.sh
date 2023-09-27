#!/bin/bash

. ~/.bashrc

cd dashboarddeelmobiliteit-app-main

nvm use 16
npm install
npm run build

mkdir -p /srv/www/frontend
cp -a build/. /srv/www/frontend/
chown -r www-data:www-data /srv/www/frontend/