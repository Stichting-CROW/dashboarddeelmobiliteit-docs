---
title: Offering a data feed for monitoring
description: This is how you offer a data feed for monitoring
---

This document is intended for providers that want to share their data with the [Dashboard Deelmobiliteit](https://dashboarddeelmobiliteit.nl/).

The Dashboard Deelmobiliteit is used by municipalities to monitor shared mobility within their area. It shows how long vehicles are parked in public space, how shared mobility is used and where shared mobility is available. Providers can benefit from the Dashboard Deelmobiliteit as they get less data requests from the different individual municipalitites. Also providers can use the Dashboard Deelmobiliteit for their own analyses. If all parties agree, data can be shared for mobility research and scientific research.

Operators offer the `/vehicles` and `/trips` end point of the **MDS [Provider API](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#mobility-data-specification-provider)**. See [Data specifications](#data-specifications) for additional details.

The Dashboard Deelmobiliteit applies the guidelines the [CDS-M](https://www.cds-m.nl/) framework.

## Introduction

The CROW-Fietsberaad Dashboard Deelmobiliteit uses [MDS](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#mobility-data-specification-provider) >= 1.2.0 to collect information on shared mobility to present to regulatory agencies, usually municipalities. This data is provided by operators.

## Data specifications

### General

Parked vehicles that are present in the public space (i.e., PROW) MUST be present in the supplied data.

That includes reserved and disabled vehicles or vehicles with empty batteries, etc. that take up place in the public space.

Inversely, vehicles removed from the public space MUST NOT be returned.

Data provided in a feed or endpoint MUST be updated at least every 30 seconds.
The update frequency MAY be higher.

### MDS /vehicles

The provider must offer the [`/vehicles`][1] endpoint, part of the MDS (>= 1.2.0) Provider API.

CROW Dashboard uses this endpoint to get a current snapshot of all vehicles in public space, at any moment.

NOTE: In the _Vehicle types_ section we help you set the right vehicle type for every vehicle in this feed.

[1]: https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#vehicles

### MDS /trips

The provider can offer [`/trips`][mds-trips] endpoint, part of the MDS Provider API.

CROW Dashboard Deelmobiliteit uses this endpoint to get the exact historical rentals.

NOTE: For the [`route`][mds-trips-routes] property only the start and end of a rental are required. 

[mds-trips]: https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#trips
[mds-trips-routes]: https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#routes

### MDS authorization

The providers shall provide [authorization][mds-auth] for API endpoints via a token based auth system.

[mds-auth]: https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/auth.md#authorization

## Vehicle types

This section helps you in choosing the right vehicle type.

First, we show the different types of vehicle types that are supported in the Dashboard Deelmobiliteit.

After that, we show exactly how to implement this in your MDS (and GBFS, deprecated) data feed.

### Supported vehicle types

| English                     | Dutch                       |
| --------------------------- | --------------------------- |
| Bicycle                     | Gewone fiets                |
| Bicycle with pedal assist   | Elektrische fiets |
| Moped <= 25 km/h            | Snorfiets (blauw kenteken)  |
| Moped                       | Bromfiets (geel kenteken)   |
| Scooter                     | Elektrisch step             |
| Human powered cargo bike    | Bakfiets              |
| Electric cargo bike         | Elektrisch bakfiets          |
| Shared combustion car       | Deelauto met verbrandingsmotor |
| Shared electric car         | Elektrisch deelauto          | 

### How to offer vehicle type in MDS?

Please share vehicle type information in your MDS feed:

- In [`/vehicles`](https://github.com/openmobilityfoundation/mobility-data-specification/tree/dev/provider#vehicles), add properties:
  - `vehicle_type`
  - [`propulsion_types`](https://github.com/openmobilityfoundation/mobility-data-specification/blob/dev/general-information.md#propulsion-types) (add only 1 propulsion type in this array)
  - `max_permitted_speed` (optional though required if you offer a moped)
  - `wheel_count`         (optional)

From [MDS 2.0.0](https://github.com/NABSA/gbfs/pull/370#issuecomment-918223268) the newest vehicle types like 'cargo_bicycle' and 'scooter_standing' are supported as well. We will start using the 2.0.0 standard from now and adapt later on if the spec changes.

MDS [uses](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/general-information.md#vehicle-types) the same vehicle types as GBFS.

In the table below you'll find all the combinations possible.

| vehicle type                | vehicle_type       | propulsion_type | max_permitted_speed
| ---------------             | ----------------- | --------------- | ----------- 
| Bicycle                     | bicycle           | human           | -
| Bicycle with pedal assist   | bicycle           | electric_assist | 25
| Moped <= 25 km/h            | moped             | electric        | 25
| Moped                       | moped             | electric        | 45
| Scooter                     | scooter_standing  | electric        | 25
| Human powered cargo bike    | cargo_bicycle     | human           | -
| Electric cargo bike         | cargo_bicycle     | electric_assist | 25
| Shared combustion car       | car               | combustion      | -
| Shared electric car         | car               | electric        | -

If you have questions on implementing a specific vehicle type, send an email to [info@dashboarddeelmobiliteit.nl](mailto:info@dashboarddeelmobiliteit.nl).
