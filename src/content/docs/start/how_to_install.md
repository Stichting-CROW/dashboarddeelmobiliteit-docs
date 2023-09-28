---
title: How to install?
description: This page describes how to install a clone of the shared mobility dashboard on your own machine.
---

This page describes how to install the shared mobility dashboard on your own machine. This guide is updated for the last time on 27th of September 2023. This guide is focussed on how to install the dashboard on Debian 12 but can also be used to install the dashboard on other operating systems (although some things don't work out of the box and need manual adaptation).

The installation process consists of **3 phases**, every phase requires some configuration steps.
1. Installing main components
2. Setting up API gateway
3. Setting up frontend

# Prepare installation

Create a fresh Debian machine and run the following command to install the installation scripts. 

```
apt-get update && apt-get install unzip
curl -LO https://github.com/Stichting-CROW/dashboarddeelmobiliteit-docs/archive/refs/heads/main.zip && unzip main.zip && rm main.zip
```

## Setup DNS

Set DNS A-records to your machine, we recommend to define the following domains and subdomains. 

* <your_url.com> -> frontend
* mds.<your_url.com> -> MDS-feed for operators
* auth.<your_url.com> -> fusionauth
* api.<your_url.com> -> api proxy

# Install main components

1. ```cd dashboarddeelmobiliteit-docs-main/install-scripts```
1. Copy config_example to config ```cp config_example config```
1. Setup variables in config file with your favorite text editor. 
1. Run ```./install.sh```
1. If you would like to setup https (highly recommended) run ```./setup_https.sh```, this will install letsencrypt and starts a wizard.
1. Another optional step is to prepare the dashboard with some data, this depends per country.
    * For Belgium:
        * ```cd init_data_scripts/belgium```
        * Run ```./import_administrative_zones.sh``` to import border of municipalities
        * Run ```./add_open_data_test_feeds.sh``` to add some open data feeds to the dashboard (be aware these open data feeds don't follow the [requirements](https://docs.crow.nl/deelfietsdashboard/hr-dataspec/) of the Dashboard)
1. Navigate to the previous directory using ```cd dashboarddeelmobiliteit-docs-main/install-scripts```, then run ```./run_all_cronjobs.sh``` to make first aggregated data based on the just imported data feeds

## Setup API gateway

1. Go to https://auth.<your_url.com>
1. Finish installation and create an account.
1. Go to Tenants -> edit button -> set issuer (use your auth domain name without https:// for example) -> save
1. Go to the **Dashboard** page and complete the 3 setup steps.
![3 configuration steps](https://dashboarddeelmobiliteit.ams3.digitaloceanspaces.com/images/complete_setup_fusionauth.png)
    1. Create application
        * Give it a name
        * Roles -> Create role with name: `default_role`
        * JWT -> Enabled
            * Set **Access token signing key** to autogenerate on save
        * Security -> Disable 'Require and API key'
        * Save
    1. Create API key (Go to **Dashboard** -> Click the _Add_ button)
    1. Setup email
1. Go to users and register your account with the newly created application.
1. ```cp config_gateway_example config_gateway```
1. Setup variables in `config_gateway` with variables created with step 2, 3 and 4
1. Get key for JWT authentication
    1. Go to Settings -> System -> Key Master
    1. Click **Generate EC key pair**, give it a name and click **Save**.
    1. Click on the loop icon of the just generated key.
    1. Copy public key -> PEM encoded
    1. Create `public-key.pem` into install-scripts folder and paste content.
1. Setup CORS
    1. Go to Settings -> System -> CORS 
    1. Set it to **Enabled**
    1. Put '`content-type`' into allowed headers. 
    1. Allow all methods
    1. Put allow origins to '`*`' (or limit further if you like)
    1. Save
1. Run ```./setup_apigateway.sh```

## Setup Frontend

In the frontend a few settings needs to be set to make the frontend work with the newly installed backend, and to customize the style of the dashboard.

1. Go to frontend directory ```cd dashboarddeelmobiliteit-app-main```
1. ```cp .env.example .env```
1. Make sure to specify all environment variables in the .env file
1. Go to install-scripts folder again and run ```./deploy_new_frontend.sh```
1. Go to your main url and test the dashboard.