---
title: How to add a data feed?
description: How to add a data feed of an operator to the dashboard
---

The recommended way to share data between operators and the dashboard is the [MDS /vehicle](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#vehicles) endpoint. At this moment the dashboard support version 1.2 of MDS. When implemented by operators version 2.0 (where /vehicles and /vehicle/status is splitted up in two parts) will also be added. Also support for the [MDS /trips](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#trips) endpoint will be added in the near future.

The dashboard has deprecated compitability with [GBFS 1.x](https://github.com/MobilityData/gbfs/blob/v1.1/gbfs.md#free_bike_statusjson) free_bike_status.json and the TOMP api. We don't recommend to add new operators with these data feeds anymore. Because these standards started focussing on only exchanging data for traveler information that makes them less usable for monitoring purposes.

## Authentication

At this moment there is no standard way specified how the authentication should be done. This leads to a wide variety of authentication methods.

At this moment the dashboard support feeds that are:

- Not authenticated
- Authenticated with a static apikey in the header
- [https://github.com/Stichting-CROW/dd-importer-v2/tree/master/feed/auth](Several) OAuth 2.0 implementations (they differ per operator)

If authentication is required we strongly recommend to require static apikeys because it's the easiest and least error prone option to implement.

## How to add a operator?

Adding a new operator consists of 2 steps:

1. Add at least one feed to the database.
2. Add operator to frontend

### Add feed to database

New data feeds should be added to the feeds table. Per operator you should define a system_id, if multiple feeds have the same system_id the data is combined when the data if fetched before its further processed.

- system_id: unique ID per operator
- feed_url: the https url to request data from
- feed_type: one of mds, full_gbfs (when referring to gbfs.json[https://github.com/MobilityData/gbfs/blob/master/gbfs.md#gbfsjson]), gbfs (when reffering to [free_bike_status.json]((https://github.com/MobilityData/gbfs/blob/v1.1/gbfs.md#free_bike_statusjson))) and tomp. 
- import_strategy: always clean for now
- authentication: specifies all authentication details as a JSON object.
- last_time_update: value to track when the feed is changed for the last time.
- default_vehicle_type: some data standards don't provide information about what vehicle_types every vehicle is, by setting op a default vehicle_type you can get correct data in most circumstances. Default vehicle_types can be found [here](https://github.com/Stichting-CROW/dd-importer-v2/blob/master/sql/main_model.sql#L185)
- request_headers, some times additonal HTTP headers are needed to request data. In this column all those headers can be added.
- is_active: it's possible to deactivate a feed without removing the record of the feed by setting this value to false.

This is an example how you can add a MDS /vehicle feed with default OAuth2 authentication.

```sql
INSERT INTO feeds (system_id, feed_url, feed_type, import_strategy, authentication, last_time_updated, default_vehicle_type, request_headers, is_active) 
VALUES (
    '<system_id>', 
    '<feed_url>', 
    'mds', 
    'clean', 
    '
    {
        "TokenURL":"<url_to_request_token>",
        "OAuth2Credentials":{
            "client_id":"<client_id>",
            "client_secret":"<client_secret>",
            "scope":"<scope>",
            "grant_type":"client_credentials"
        },
        "authentication_type":"oauth2"
    }
    ', 
    NOW(), 
    4, 
    '
    {
        "Accept": "application/vnd.mds.provider+json;version=1.2"
    }
    ',
    true
);
```
#### Other examples

##### Without authentication


##### With static api key



### Add operator to the frontend

1. One records should be added cPublicAanbieders list in [metadataAccessControlList.js](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-app/blob/6d57911285812660795a8fe8585f81a6e5a16649/src/poll-api/metadataAccessControlList.js#L4)
1. One records should be added to getPrettyProviderName, getProviderWebsiteUrl and getProviderColors in [providers.js](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-app/blob/6d57911285812660795a8fe8585f81a6e5a16649/src/helpers/providers.js#L35)

:::note
In the future we would like to add one Operator entity in the backend of the dashboard. One operator can have one or multiple feeds. For every operator at least a system_id, name and color should be specified. In that way adding new operators becomes more flexible. Also we would like to make it possible to add, delete and modify records in the feeds table by an api. If you would like to work on these improvements already, feel free to do so.
:::
