---
title: How to install?
description: This page describes how to install a clone of the shared mobility dashboard on your own machine.
---

This page describes how to install the shared mobility dashboard on your own machine. This guide is updated for the last time on 17th of September 2023. This guide is focussed on how to install the dashboard on Debian 12 but can also be used to install the dashboard on other operating systems (altough many things doesn't work out of the box and need manual addaptation.)

# Prepare installation

```
TODO: add download link.
```

## Setup DNS

Set A records to your machine, we recommend to define the following domains and subdomains. 

* <your_url.com> -> frontend
* mds.<your_url.com> -> MDS-feed for operators
* auth.<your_url.com> -> fusionauth
* api.<your_url.com> -> api proxy

# Installation

1. Copy config_example to config ```cp config_example example```
1. Setup variables in config file with your favorite text editor. 
1. Run ./install.sh
1. If you would like to setup https (highly recommended) run ./setup_https.sh, this will install letsencrypt and starts a wizard.

## setting up fusionauth

1. Go to https://auth.<your_url.com>
1. Finish installation and create an account.
1. Complete setup.