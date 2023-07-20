---
title: Microhubs
description: API's for microhubs
---

The Dashboard has the functionality to draw microhubs, no-parking areas and zones solely with a monitoring purpose.

All microhubs and related data are offered using public MDS end points. This way you can query a list of all microhubs per municipality, and get information on what's both the occupancy and the capacity of each microhub.

## /stops

Get hubs with their capacity:

https://mds.dashboarddeelmobiliteit.nl/stops?municipality=GM0363

If `num_places_available` > 0, vehicles can be offered/parked in this hub.

## /policies

Gives areas in which it's forbidden to park / offer vehicles:

https://mds.dashboarddeelmobiliteit.nl/policies?municipality=GM0363

## /geographies

The exact geolocation of the hubs, capacity and prohibition areas:

https://mds.dashboarddeelmobiliteit.nl/geographies/51729d78-b8dd-11ed-b1e6-fa4fb8e2990b

## More information

For full API documentation, see the _Dashboard Deelmobiliteit MDS API_ docs:

- https://mds.dashboarddeelmobiliteit.nl/redoc
- https://mds.dashboarddeelmobiliteit.nl/docs

Both give the same information but have a different design. Choose the one you like.
