---
title: Available Vehicles API
description: Open API for getting all available shared vehicles in The Netherlands
---

With the Available Vehicles API you get the locations and metadata of all shared vehicles in The Netherlands.

This is an open API. You don't need an API key to use it.

## Get all /vehicles

**Get all unrented vehicles in public space.**

### Example request

```
https://api.datadeelmobiliteit.nl/vehicles
```

### Available parameters

None at the moment

### Example response

``` json
{
  "last_updated": "2025-03-14T13:26:23Z",
  "ttl": 30,
  "data": {
    "vehicles": [
      {
        "system_id": "moveyou",
        "vehicle_id": "moveyou:3d0e23d5d35f",
        "lat": 52.107947,
        "lon": 5.189377,
        "is_reserved": false,
        "is_disabled": false,
        "form_factor": "bicycle",
        "propulsion_type": "human"
      },
      {
        "system_id": "baqme",
        "vehicle_id": "baqme:743035ed8b67",
        "lat": 52.344463,
        "lon": 4.896417,
        "is_reserved": false,
        "is_disabled": false,
        "form_factor": "cargo_bicycle",
        "propulsion_type": "electric_assist"
      },
      {
        "system_id": "felyx",
        "vehicle_id": "felyx:a1fcc1567ded",
        "lat": 53.22147,
        "lon": 6.54251,
        "is_reserved": false,
        "is_disabled": true,
        "form_factor": "moped",
        "propulsion_type": "electric"
      },
    ]
  }
}
```

### Additional information

The vehicle ID is randomly generated every time a rental is ended, and therefor is not equal to the ID used by the operator's software.

For the available form factors and propulsion types, see: [How to offer vehicle type in MDS?](/data_feeds/for_monitoring/#how-to-offer-vehicle-type-in-mds)

Het attribuut `is_reserved` is `true` als de fiets is gereserveerd voor een gebruiker.

Het attribuut `is_disabled` is `true` als de fiets niet beschikbaar is voor gebruik, bijvoorbeeld als het voertuig is gekenmerkt als defect.

### Python script: Get vehicles in Zwolle

We want to offer the best possible performance, therefor there're no filtering operations available in the API itself. Any user of this API can filter the data themselves however they'd like (for example: filter by operator, modality or geographic location).

Here is a working example script written in Python, that shows you how to filter by municipality/area: https://gist.github.com/sven4all/2b69fc2dc08e624171235e21ce360aab

## More information

Do you have any questions on how to use the API, feel free to contact info@dashboarddeelmobiliteit.nl