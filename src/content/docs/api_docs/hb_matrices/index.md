---
title: HB Matrices
description: API's for getting HB matrices
---

The Dashboard Deelmobiliteit aggregates rental data to a HB matrix grid. The frontend UI for this can be seen at [/map/rentals](https://dashboarddeelmobiliteit.nl/map/rentals) (select the HB data layer).

![Screenshot of "Select layer" modal](https://files.dashboarddeelmobiliteit.nl/techical_docs/HB_matrices/hb_matrices_select_layer.png)

## Types of aggregations

You can see a HB matrix in two different ways:
1. Using the municipality zones (stadsdelen)
2. Using a <a href="https://h3geo.org/docs" target="_blank">H3 grid</a> (level 7 or 8)

## Settings

You can set:
- Period (from and to date)
- Weekday (1 or multiple options)
- Time windows (6 predefined time windows)
- Vehicle type
- Want to see the origins or destinations?

Based on these settings the HB grid appears on your map. Values are only shown if there're at least 4(?) rentals in that area.

## API end points

### `/od-api/[origins|destinations]/[h3|geometry]`

Use one of the following API end points:
- https://api.deelfietsdashboard.nl/od-api/origins/h3
- https://api.deelfietsdashboard.nl/od-api/origins/geometry
- https://api.deelfietsdashboard.nl/od-api/destinations/h3
- https://api.deelfietsdashboard.nl/od-api/destinations/geometry

together with query params:
- h3_resolution=7 or h3_resolution=8
- start_date=yyyy-mm-dd
- end_date=yyyy-mm-dd
- time_periods=2-6
- days_of_week=fr%2Csa%2Csu
- origin_cells or destination_cells=87196bb51ffffff
- origin_stat_refs or destination_stat_refs=cbs%3AWK059901

#### cURL examples

##### HB matrices for H3 grid areas

``` bash
curl --location 'https://api.deelfietsdashboard.nl/od-api/destinations/h3?h3_resolution=7&end_date=2023-02-06&start_date=2023-01-05&time_periods=2-6&days_of_week=fr%2Csa%2Csu&origin_cells=87196bb51ffffff' \
--header 'authorization: Bearer TOKEN'
```
##### HB matrices for municipality zones

```bash
curl --location 'https://api.deelfietsdashboard.nl/od-api/origins/geometry?end_date=2022-02-06&start_date=2022-01-05&destination_stat_refs=cbs%3AWK059901' \
--header 'authorization: Bearer TOKEN'
```

_Everything's the same as for H3 grid HB matrices, apart from:_

- _We use the endpoint `/origins/geometry` instead of `/origins/h3`_
- _Key `destination_stat_refs` is used instead of `destination_cells`_

## Source code

The OD matrix aggregator code can be found at [github.com/Stichting-CROW/dashboarddeelmobiliteit-od-matrix-aggregator](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-od-matrix-aggregator)

The OD API can be found at [github.com/Stichting-CROW/dashboarddeelmobiliteit-od-api](https://github.com/Stichting-CROW/dashboarddeelmobiliteit-od-api)

Both software packages are licensed under the open source license: **Mozilla Public License 2.0**
