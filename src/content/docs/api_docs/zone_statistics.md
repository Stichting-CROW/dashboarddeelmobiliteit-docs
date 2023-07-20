---
title: Zone statistics
description: API's for zone statistics
---

The Dashboard has the functionality to draw microhubs, no-parking areas and zones solely with a monitoring purpose.

For all of these zones the Dashboard tracks statistics about the number of vehicles in the zone and the number of trips starting or ending in a zone with a 5 minute interval.

The Zone Statistics API has three API end points available:

- `https://mds.dashboarddeelmobiliteit.nl/public/zones?{encoded_params}`
- `https://api.deelfietsdashboard.nl/dashboard-api/stats_v2/availability_stats?{params}`
- `https://api.deelfietsdashboard.nl/dashboard-api/stats_v2/rental_stats?{params}`

## All zones

Gets all zones for you available.

Example request:

```
https://mds.dashboarddeelmobiliteit.nl/public/zones
```

Replace `xxxx` with your API key

Available parameters:

- `municipality=GM0599`
- `geography_types=['no_parking', 'stop', 'monitoring']`

Example request:

```
https://mds.dashboarddeelmobiliteit.nl/public/zones?gm_code=GM0599
```

## Parked vehicles

Gets parked vehicles data in an aggregated way.

Example request:

```
https://api.deelfietsdashboard.nl/dashboard-api/stats_v2/availability_stats?aggregation_level=hour&group_by=operator&aggregation_function=MAX&zone_ids=53017&start_time=2023-07-11T00:00:00Z&end_time=2023-07-13T00:00:00Z&apikey=xxxx
```

Available parameters:

- apikey
- aggregation_level
- group_by
- aggregation_function
- zone_ids
- start_time
- end_time

Example response:

```
{
    "availability_stats": {
        "aggregation_level": "1 hour",
        "values": [
            {
                "check": 1,
                "time": "2023-07-11T08:00:00Z"
            },
            {
                "check": 1,
                "time": "2023-07-11T09:00:00Z"
            },
            {
                "check": 1,
                "time": "2023-07-11T10:00:00Z"
            },
            {
                "baqme": 1,
                "check": 1,
                "time": "2023-07-11T14:00:00Z"
            },
            // ...
        ]
    }
}
```

## Rentals

Gets rental data in an aggregated way.

Example request:

```
https://api.deelfietsdashboard.nl/dashboard-api/stats_v2/rental_stats?aggregation_level=day&group_by=operator&aggregation_function=MAX&zone_ids=53017&start_time=2023-07-11T00:00:00Z&end_time=2023-07-13T00:00:00Z&apikey=xxxx
```

Available parameters:

- apikey
- aggregation_level
- group_by
- aggregation_function
- zone_ids
- start_time
- end_time

Example response:

```
{
    "rental_stats": {
        "values": [
            {
                "baqme": {
                    "bicycle": {
                        "rentals_ended": 1,
                        "rentals_started": 1
                    },
                    "car": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "cargo_bicycle": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "moped": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "other": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    }
                },
                "check": {
                    "bicycle": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "car": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "cargo_bicycle": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    },
                    "moped": {
                        "rentals_ended": 2,
                        "rentals_started": 2
                    },
                    "other": {
                        "rentals_ended": 0,
                        "rentals_started": 0
                    }
                },
                "time": "2023-07-11T00:00:00Z"
            }
        ]
    }
}
```
