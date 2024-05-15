---
title: Offering a data feed for monitoring
description: This is how you offer a data feed for monitoring
---

This document is intended for providers that want to share their data with the [Dashboard Deelmobiliteit](https://dashboarddeelmobiliteit.nl/).

The Dashboard Deelmobiliteit is used by municipalities to monitor and control shared mobility within their area. It shows how long vehicles are parked in public space, how shared mobility is used and where shared mobility is available. Providers can benefit from the Dashboard Deelmobiliteit as they get less data requests from the different individual municipalitites. Also providers can use the Dashboard Deelmobiliteit for their own analyses. If all parties agree, data can be shared for mobility research and scientific research.

Operators offer the `/vehicles`, `/vehicles/status` and `/trips` end point of the **MDS [Provider API](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/provider/README.md#mobility-data-specification-provider)**. See [Data specifications](#data-specifications) for additional details.

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


#### 2.0 (/vehicles + /vehicles/status)

From version 2.0 onwards the static and realtime data are seperated in two different endpoints ([/vehicles](https://github.com/openmobilityfoundation/mobility-data-specification/tree/dev/provider#vehicle-information) and [/vehicles/status](https://github.com/openmobilityfoundation/mobility-data-specification/tree/dev/provider#vehicle-status)). 

For the `/vehicles` endpoint should be implemented according to the specification see the [data model](https://github.com/openmobilityfoundation/mobility-data-specification/blob/dev/data-types.md#vehicles).

For the `/vehicles/status`endpoint we allow a simplified implementation by operators. The tables below describe the mandatory fields fields for the `/vehicles/status` endpoint.

The MDS standard describes that the status of all vehicles in [PROW](https://github.com/openmobilityfoundation/mobility-data-specification/blob/dev/modes/vehicle_states.md#mobility-data-specification-vehicle-states) should be communicated, for the dashboard it's allowed to no communicate vehicles that have a `on_trip` status (vehicles in this state are anyway not processed by the dashboard).  

##### Vehicle Status

| Field | Type | Required for dashboard | Comments |
| ----- | ---- | ----------------- | -------- |
| `device_id` | UUID | Yes | A unique device ID in UUID format, should match this device in Provider |
| `provider_id` | UUID | Yes | A UUID for the Provider, unique within MDS. See MDS [provider list](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/providers.csv). |
| `data_provider_id` | UUID | Optional | If different than `provider_id`, a UUID for the data solution provider managing the data feed in this endpoint. See MDS [provider list](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/providers.csv) which includes both service operators and data solution providers. |
| `last_event` | Event | Yes | Most recent [Event](#events) for this device based on `timestamp` |
| `last_telemetry` | Telemetry | Yes | Most recent [Telemetry](#telemetry) for this device based on `timestamp` |

###### Events

| Field | Type | Required for dashboard | Comments |
| ----- | ---- | ----------------- | -------- |
| `device_id` | UUID | Yes | A unique device ID in UUID format |
| `provider_id` | UUID | Yes | A UUID for the Provider, unique within MDS. See MDS [provider list](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/providers.csv). |
| `data_provider_id` | UUID | Optional | If different than `provider_id`, a UUID for the data solution provider managing the data feed in this endpoint. See MDS [provider list](https://github.com/openmobilityfoundation/mobility-data-specification/blob/main/providers.csv) which includes both service operators and data solution providers. |
| `event_id` | UUID | Optional | A unique event ID |
| `vehicle_state` | Enum | Yes | See [vehicle state][vehicle-states] table |
| `event_types` | Enum[] | Optional | Vehicle [event types][vehicle-events] for state change, with allowable values determined by `vehicle_state` |
| `timestamp` | [Timestamp][ts] | Optional | Date/time that event occurred at. See [Event Times][event-times] |
| `publication_time` | [Timestamp][ts] | Optional | Date/time that event became available through the status changes endpoint |
| `location` | [GPS][gps] | Optional | See also [Telemetry][telemetry]. |
| `event_geographies` | UUID[] | Optional | **[Beta feature](/general-information.md#beta-features):** *Yes (as of 2.0.0)*. Array of Geography UUIDs consisting of every Geography that contains the location of the status change. See [Geography Driven Events][geography-driven-events]. Required if `location` is not present. |
| `battery_percent`       | Integer          | Optional| Percent battery charge of vehicle, expressed between 0 and 100 |
| `fuel_percent`       | Integer          | Optional | Percent fuel in vehicle, expressed between 0 and 100 |
| `trip_ids` | UUID[] | Optional | Trip UUIDs (foreign key to /trips endpoint), required if `event_types` contains `trip_start`, `trip_end`, `trip_cancel`, `trip_enter_jurisdiction`, or `trip_leave_jurisdiction` |
| `associated_ticket` | String | Optional | Identifier for an associated ticket inside an Agency-maintained 311 or CRM system |


###### Telemetry

A standard point of vehicle telemetry. References to latitude and longitude imply coordinates encoded in the [WGS 84 (EPSG:4326)](https://en.wikipedia.org/wiki/World_Geodetic_System) standard GPS or GNSS projection expressed as [Decimal Degrees](https://en.wikipedia.org/wiki/Decimal_degrees).

| Field             | Type            | Required for dashboard      | Field Description |
| -----             | ----            | -----------------      | ----------------- |
| `device_id`       | UUID            | Yes               | A unique device ID in UUID format                     |
| `provider_id`     | UUID            | Yes              | A UUID for the Provider, unique within MDS. See MDS [provider list](/providers.csv). |
| `data_provider_id`| UUID            | Optional               | If different than `provider_id`, a UUID for the data solution provider managing the data feed in this endpoint. See MDS [provider list](/providers.csv) which includes both service operators and data solution providers. |
| `telemetry_id`    | UUID            | Optional               | ID used for uniquely-identifying a Telemetry entry |
| `timestamp`       | [Timestamp][ts] | Yes               | Date/time that event occurred. Based on GPS or GNSS clock            |
| `trip_ids`        | UUID[]          | Optional               | If telemetry occurred during a trip, the ID of the trip(s).  If not in a trip, `null`.
| `journey_id`      | UUID            | Optional              | If telemetry occurred during a trip and journeys are used for the mode, the ID of the journey.  If not in a trip, `null`.
| `stop_id`         | UUID            | Optional | Stop that the vehicle is currently located at. See [Stops][stops] |
| `location`        | [GPS][gps]      | Yes               | Telemetry position data |
| `location_type`   | Enum            | Optional      | If detectable and known, what type of location the device is on or in. One of `street`, `sidewalk`, `crosswalk`, `garage`, `bike_lane`.   |
| `battery_percent` | Integer         | Optional | Percent battery charge of vehicle, expressed between 0 and 100 |
| `fuel_percent`    | Integer         | Optional | Percent fuel in vehicle, expressed between 0 and 100 |
| `tipped_over`     | Boolean         | Optional      | If detectable and known, is the device tipped over or not? Default is 'false'. |

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
