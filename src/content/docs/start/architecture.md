---
title: Architecture
description: A high level overview of the architecture of the dashboard deelmobiliteit
---

## Overview of the architecture

The architecture is divided in multiple layers, the Databases are responsible for storing all the data that is collected by the dashboard. The Data-services are responsible for importing data and making aggregates of those data to make them quickly accessible by the API-layer. The dashboard self is a standalone PWA that is connected with the API-layer via an API-gateway.

![Architecture Image](https://dashboarddeelmobiliteit.ams3.digitaloceanspaces.com/images/architecture_shared_mobility_dashboard.png)

## Databases

### PostgreSQL
[PostgreSQL](https://www.postgresql.org/) is used for persistent storage. The [PostGIS](https://postgis.net/) and [TimescaleDB](https://github.com/timescale/timescaledb) extensions are used for extending the capabilities of PostgreSQL with geographical and timeseries related functionality.

### Redis
In memory database for volatile non-geography related data. [Redis](https://redis.io/)

### Tile38
In memory database for volatile geography related data. [Tile38](https://tile38.com/)

## Data-services (importers and aggregators)

### importer

### zone-stats-aggregator

Counts the number of vehicles and rentals started and ended in every custom made zone every 5 minutes and stores it as timeseries data in PostgreSQL. [source code](https://github.com/Stichting-CROW/dd-zone-stats-aggregator)

### daily-report

### microhubs-controller

Counts every 30s the number of vehicles in every microhub and decides if a microhubs should closed when reaching the maximum capacity. [source code](https://github.com/Stichting-CROW/dd-microhubs-controller)

### od-matrix aggregator

## API-layer

### dashboard-api

### admin-api

### od-api

### policy-api

## API-gateway

### FusionAuth

Responsible for the authentication of users, authorization (what priviliges do every user have, and what data can a user is accessed) is handled by every individual API. [FusionAuth](https://fusionauth.io/)

### Kong

Kong is an API-gateway that authenticates all the traffic and proxies it to the right API. [Kong](https://konghq.com/products/kong-gateway)