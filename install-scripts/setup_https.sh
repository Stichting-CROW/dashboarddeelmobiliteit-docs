#!/bin/bash

sudo apt-get install certbot python3-certbot-nginx -y
certbot --nginx
