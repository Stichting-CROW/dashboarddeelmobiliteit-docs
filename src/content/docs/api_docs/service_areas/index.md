---
title: Service areas
description: API's for service areas
---

With the GBFS API end point `/geofencing_zones` providers can share their service areas.

The Dashboard Deelmobiliteit has created a way to request the service areas of multiple providers at the same time, for any given time periode.

## /service_area

Get service_areas

https://mds.dashboarddeelmobiliteit.nl/public/service_area?municipalities=MUNICIPALITY_CODE&operators=OPERATOR_NAME

Required parameters:
- MUNICIPALITY_CODE: CBS-code for this municipality, in example `GM0599`
- OPERATOR_NAME: Operator name as known in the Dashboard Deelmobiliteit, in example `check`

## /service_area/history

Get the history of service area changes

https://mds.dashboarddeelmobiliteit.nl//public/service_area/history?municipalities=MUNICIPALITY_CODE&operators=OPERATOR_NAME&start_date=START_DATE&end_date=END_DATE

Required parameters:
- MUNICIPALITY_CODE: CBS-code for this municipality, in example `GM0599`
- OPERATOR_NAME: Operator name as known in the Dashboard Deelmobiliteit, in example `check`
- START_DATE: Start date like `2024-01-01`
- END_DATE: End date like `2024-12-31`

## /service_area/delta/:id

Get the changes of this service area version compared to the previous service area that was known.

https://mds.dashboarddeelmobiliteit.nl/public/service_area/delta/:id

Required parameters:
- :id: Service area ID from `/service_area/history` API end point

## /service_area/available_operators

Get operators with service Area

https://mds.dashboarddeelmobiliteit.nl/public/service_area/available_operators

## More information

For full API documentation, see the _Dashboard Deelmobiliteit MDS API_ docs:

- https://mds.dashboarddeelmobiliteit.nl/redoc
- https://mds.dashboarddeelmobiliteit.nl/docs

Both give the same information but have a different design. Choose the one you like.
