---
title: How to install?
description: This page describes how to install a clone of the shared mobility dashboard on your own machine.
---

This page describes how to install the shared mobility dashboard on your own machine. This guide is updated for the last time on 27th of September 2023. This guide is focussed on how to install the dashboard on Debian 12 but can also be used to install the dashboard on other operating systems (although some things don't work out of the box and need manual adaptation).

The installation process consists of **3 phases**, every phase requires some configuration steps.
1. Installing main components
2. Setting up API gateway
3. Setting up frontend

The guidelines and scripts were tested on a VM with 4 vCPUs, 8GB RAM and 160 GB local disk storage.

> Note: The following documentation assumes that the commands are executed as `root` user.

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
1. Copy example_config to config ```cp example_config config```
1. Setup variables in config file with your favorite text editor. 
1. Run ```./install.sh```
1. Run ```./setup_https.sh```, this will install letsencrypt and starts a wizard.
1. Another optional step is to prepare the dashboard with some data, this depends per country.
    * For Belgium:
        * ```cd init_data_scripts/belgium```
        * Run ```./import_administrative_zones.sh``` to import border of municipalities
        * Run ```./add_open_data_test_feeds.sh``` to add some open data feeds to the dashboard (be aware these open data feeds don't follow the [requirements](https://docs.crow.nl/deelfietsdashboard/hr-dataspec/) of the Dashboard)
1. Navigate to the previous directory using ```cd dashboarddeelmobiliteit-docs-main/install-scripts```, then run ```./run_all_cronjobs.sh``` to make first aggregated data based on the just imported data feeds

## Setup API gateway

1. Go to https://auth.<your_url.com>
1. Finish installation and create an account.
1. Go to Tenants -> edit button -> set issuer (use your auth domain name without https:// for example dd.vlaanderen.transbits.nl) -> save
1. Go to the **Dashboard** page and complete the 3 setup steps.
![3 configuration steps](https://dashboarddeelmobiliteit.ams3.digitaloceanspaces.com/images/complete_setup_fusionauth.png)
    1. Create application
        * Give it a name
        * Roles -> Create role with name: `default_user`
        * JWT -> Enabled
            * Set **Access token signing key** to autogenerate on save
        * Security -> Disable 'Require and API key'
        * Save
        * Copy generated app id from 'Applications'.
    1. Create API key (Go to **Dashboard** or go to Settings -> API Keys and click the _Add_ button). Copy the API key to be used later.
    1. Setup email
1. Go to users and register your account with the newly created application with the role `default_role`.
1. ```cp example_config_gateway config_gateway```
1. Setup the following variables in `config_gateway`:
    * `FUSIONAUTH_APP_ID` app id generated in step 4
    * `FUSIONAUTH_API_KEY` api key generated in step 4
    * `FIRST_USER` first user account that was registered in fusionauth in step 2
    * `JWT_ISSUER` the issuer that was setup in step 3
1. Get key for JWT authentication
    1. Go to Settings -> System -> Key Master
    1. Click on the loop icon of the in step 4 generated key
    1. Copy public key (the key so not the certificate) -> PEM encoded
    1. Create `public-key.pem` into install-scripts folder and paste content.
1. Setup CORS
    1. Go to Settings -> System -> CORS 
    1. Set it to **Enabled**
    1. Put '`content-type`' into allowed headers. 
    1. Allow all methods
    1. Put allow origins to '`*`', don't forget to press enter in this field (or limit further if you like)
    1. Save
1. Run ```./setup_apigateway.sh```

## Setup Frontend

In the frontend a few settings needs to be set to make the frontend work with the newly installed backend, and to customize the style of the dashboard.

1. Go to frontend directory ```cd dashboarddeelmobiliteit-app-main```
1. ```cp .env.example .env```
1. Make sure to specify all environment variables in the .env file. Make sure to include the full URLs (including eg. `https://<your_url.com>/`)
    * `REACT_APP_MAPBOX_TOKEN` token for map functionality, right now [Mapbox](https://www.mapbox.com/) is used, but you can also use alternatives like [Maptiler](https://www.maptiler.com/) or host your own maps.
    * `REACT_APP_FUSIONAUTH_APPLICATION_ID` should be the same value as variable `FUSIONAUTH_APP_ID` in `config_gateway`.
    * `REACT_APP_FUSIONAUTH_URL` same value as `AUTH_URL`  in `config`
    * `REACT_APP_MAIN_API_URL` same value as `API_PROXY_URL` in `config`
    * `REACT_APP_MDS_URL` same value as `MDS_URL`  in `config`
1. Go to install-scripts folder again and run ```./deploy_new_frontend.sh```
1. Go to your main url and test the dashboard.

# Restarting processes

Want to restart everything? Just reboot: `reboot`.

Want to see what processes are running? Run `docker ps`. It will show all running docker containers.

Want to restart one specific docker container?
1. First run `docker ps` to see what's the name of the process
1. Stop the process: `docker stop install-scripts-dashboard-api-1` (in this example `install-scripts-dashboard-api-1` is the name of the process)
1. Start the process again: `docker stop install-scripts-dashboard-api-1`

For more information on how Docker works, see the [Docker documentation](https://docs.docker.com/).

# Final notes

Now everything is installed and running, you can use and adapt this new application to your whishes.

If you adapt/improve the code, publish this code open source as the [open source license](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-app/) requires. This way other/similar projects can learn from each other and reuse each others code if relevant. This saves time and energy. Win-win!

Also, feel free to enhance this documentation during the process of installment or use of the app. Potentially it can be extended with server-specific information, or some things could be clarified further. You can edit the documentation [here](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-docs/), if you're logged in with a GitHub-account.
