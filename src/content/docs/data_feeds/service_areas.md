---
title: Offering a data feed sharing service areas
description: This is how you offer a data feed with service areas
---

This page is intended for providers that want to share their servicea areas with the [Dashboard Deelmobiliteit](https://dashboarddeelmobiliteit.nl/).

# GBFS 3.0

Depending on how an operator offers their vehicles, the operator must provide either a **GBFS `geofencing_zones.json`** feed or a **`station_information.json`** feed.

- **`geofencing_zones.json`** must be supplied by operators working with a _free-floating model_ where vehicles may be dropped off within a designated area.
- Operators using a _station-based model_, in which all drop-off points are exchanged as locations, must provide this information through **`station_information.json`**.
- A combination of both feeds is also possible but there should not be an overlap (so if a zone is in geofencing_zones.json it shouldn't be in station_information.json).

---

## geofencing_zones.json

To communicate service areas for free-floating systems, an operator must provide a GBFS feed with at least a **`geofencing_zones.json`** feed.

It is recommended to create a separate feature for each polygon rather than placing all polygons into a multipolygon.

In addition to the standard requirements, the following **global_rules** are defined in the NL profile. These rules ensure that if no areas are mapped out, vehicles cannot be parked anywhere, but can drive everywhere. This allows municipalities to easily compare microhubs and restricted areas with what an operator actually shows in their app.

```json
"global_rules": [
  {
    "ride_end_allowed": false,
    "ride_start_allowed": false,
    "ride_through_allowed": true
  }
]
```

Operators offer the [GBFS 3.0](https://gbfs.org/) [**`/geofencing_zones`**](https://gbfs.org/documentation/reference/#geofencing_zonesjson) endpoint. An example of an implementation by CHECK can be seen [here](https://api.ridecheck.app/gbfs/v3/rotterdam/geofencing_zones.json).

In the Dashboard Deelmobiliteit the [Service areas](https://dashboarddeelmobiliteit.nl/map/servicegebieden) page shows all service areas of all providers that offer this `geofencing_zones` API end point.

### field specifications

| Field Name                                       | Type                 | Notes                                                                                                                                                  |
| ------------------------------------------------ | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `geofencing_zones[].type`                        | String               | Must be filled with `FeatureCollection` (part of GeoJSON)                                                                                              |
| `geofencing_zones[].features`                    | Array<Object>        | List of GeoJSON features                                                                                                                               |
| `geofencing_zones[].features[].type`             | String               | Must be filled with `"Feature"`                                                                                                                        |
| `geofencing_zones[].features[].geometry`         | GeoJSON MultiPolygon | Describes the geographic area; the recommendation is to create different features rather than placing all polygons in a multipolygon                   |
| `geofencing_zones[].features[].properties`       | Object               |                                                                                                                                                        |
| `geofencing_zones[].features[].properties.rules` | Array<Rule>          | Can override global rules if needed; should be used when different geofences exist for various modalities offered by the operator                      |
| `global_rules`                                   | Array<Rule>          | In the NL profile, these values must always be provided like this: "ride_end_allowed": false "ride_start_allowed": false, "ride_through_allowed": true |

## station_information.json

A simplified version of **`station_information.json 3.0`**(https://gbfs.org/documentation/reference/#geofencing_zonesjson) must be provided if an operator defines their service area using stations.

At present, this feed must at least include the following fields:

| Name         | Type                    | Description                                                                                                                                                                                                       |
| ------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `station_id` | String                  | ID of a station                                                                                                                                                                                                   |
| `name`       | Array<Localized String> | The public name of the station, for display on maps, digital signage, and other text-based applications. Names **MUST** indicate the station’s location, using a cross street or a locally recognizable landmark. |
| `lat`        | Latitude                | WGS84 latitude of a station                                                                                                                                                                                       |
| `lon`        | Longitude               | WGS84 longitude of a station                                                                                                                                                                                      |

---

## Manifest

If an operator wishes to provide a different GBFS feed for each municipality where they operate, all these feeds must be supplied via: manifest.json → gbfs.json → geofencing_zones.json

Consumers of GBFS feeds only need to configure a single URL. If there are changes in the municipalities where an operator is active, no configuration adjustments are required.

---

## Service Area by Modality

In some municipalities, restricted areas differ per modality.

**Example:**  
In Groningen, shared bicycles are allowed in more places than shared scooters.

If an operator offers multiple modalities, the applicable service area per modality must be indicated via **rules**. To support this, there must always be at least a **`gbfs.json`** that includes a reference to **`vehicle_type.json`**.

The operator may choose to: fully implement **`vehicle_type.json`**, or only distinguish between modalities.

---

## Authentication

Data about operators’ service areas must be made available **without authentication**.
