---
title: How to install?
description: This page describes how to install a clone of the shared mobility dashboard on your own machine.
---

This page describes how to install the shared mobility dashboard on your own machine. This guide is updated for the last time on 17th of September 2023. This guide is focussed on how to install the dashboard on Debian 12 but can also be used to install the dashboard on other operating systems (altough many things doesn't work out of the box and need manual addaptation.)

The installation process consists of 3 phases, every phase requires some configuration steps.
1. Installing main components
2. Setting up API-gateway
3. Setting up frontend

# Prepare installation

Create a fresh Debian machine and run the following command to install the installation scripts. 

```
apt-get update && apt-get install unzip
curl -LO https://github.com/Stichting-CROW/dashboarddeelmobiliteit-docs/archive/refs/heads/main.zip && unzip main.zip && rm main.zip
```

## Setup DNS

Set A records to your machine, we recommend to define the following domains and subdomains. 

* <your_url.com> -> frontend
* mds.<your_url.com> -> MDS-feed for operators
* auth.<your_url.com> -> fusionauth
* api.<your_url.com> -> api proxy

# Install main components

1. ```cd dashboarddeelmobiliteit-docs-main/install-scripts``````
1. Copy config_example to config ```cp config_example config```
1. Setup variables in config file with your favorite text editor. 
1. Run ./install.sh
1. If you would like to setup https (highly recommended) run ./setup_https.sh, this will install letsencrypt and starts a wizard.
1. Another optional step is to prepare the dashboard with some data (specify script that you need to run)

## Setup API-gateway

1. Go to https://auth.<your_url.com>
1. Finish installation and create an account.
1. Complete the 3 setup steps
1. setup some config with application id and apikey from config
1. run script y

## Setup Frontend

In the frontend a few settings needs to be set to make the frontend work with the newly installed backend and customize the style of the dashboard.

1. Run init script for frontend
1. Modify .env file
1. Modify images.
1. Run deploy step of frontend.