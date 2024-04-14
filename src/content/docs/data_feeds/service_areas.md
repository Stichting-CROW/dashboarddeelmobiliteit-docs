---
title: Offering a data feed sharing service areas
description: This is how you offer a data feed with service areas
---

This document is intended for providers that want to share their servicea areas with the [Dashboard Deelmobiliteit](https://dashboarddeelmobiliteit.nl/).

The Dashboard Deelmobiliteit is used by municipalities to monitor shared mobility within their area. It shows how long vehicles are parked in public space, how shared mobility is used and where shared mobility is available. Providers can benefit from the Dashboard Deelmobiliteit as they get less data requests from the different individual municipalitites. Also providers can use the Dashboard Deelmobiliteit for their own analyses. If all parties agree, data can be shared for mobility research and scientific research.

Operators offer the [GBFS](https://gbfs.org/) [**`/geofencing_zones`**](https://gbfs.org/reference/#geofencing_zonesjson-added-in-v21) end point. An example of an implementation by CHECK can be seen [here](https://api.ridecheck.app/gbfs/v3/rotterdam/geofencing_zones.json).

In the Dashboard Deelmobiliteit the [Service areas](https://dashboarddeelmobiliteit.nl/map/servicegebieden) page shows all service areas of all providers that offer this `geofencing_zones` API end point.
