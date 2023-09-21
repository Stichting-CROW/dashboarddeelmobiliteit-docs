---
title: Parkeertelling
description: An API for getting amount of vehicles grouped per modality, for a specific area and date/time
---

With the Parkeertelling API you can get the amount of parked vehicles per modality, for a specific area and date/time.

The input for this API is:
- A **date/time (UTC)**, e.g. `2023-10-24T00:00:00Z`
- An area as **GeoJSON**, e.g. `{"type": "Polygon", "coordinates": [[[1.882351, 50.649545], [7.023702, 49.333254], [8.108420, 53.729841], [2.235547, 53.721598]]]}`

You'll get back the an array with the amount of parked vehicles in that area, grouped per modality. In example you get back this data:

| Modaliteit | Aantal voertuigen in gebied |
| ---------- | --------------------------- |
| bicycle | 7462 |
| cargo_bicycle | 1013 |
| moped | 10426 |
| scooter | 1 |
| other | 306 |

It's possible to use an user interface as well, for downloading a parkeertelling, if you've the Super Admin role for the Dashboard Deelmobiliteit. Find the 'export parkeertelling' funcionality at https://dashboarddeelmobiliteit.nl/export

Below you see an example of how to use the API end point `/parkeertelling`.

## /parkeertelling

Gets amount of parked vehicles for area and datetime, grouped per modality.

Example request:

``` bash
curl -XPOST -H "Content-type: application/json" -d '{"timestamp": "2023-09-19T00:00:00Z", "geojson": {"type": "Polygon", "coordinates": [[[1.882351, 50.649545], [7.023702, 49.333254], [8.108420, 53.729841], [2.235547, 53.721598]]]}}' 'https://api.deelfietsdashboard.nl/dashboard-api/parkeertelling?apikey=xxxx'
```

Replace `xxxx` with your API key

Example response:

``` javascript
[["bicycle",7420],["cargo_bicycle",973],["moped",10471],["scooter",1],[null,274]]
```

