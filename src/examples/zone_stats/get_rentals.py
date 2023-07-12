import requests
from urllib.parse import urlencode
import os
import sys
from datetime import datetime, timedelta
import csv

# gm_code is the municipality code that is used as an identifier by the CBS (Centraal bureau voor de statistiek)
# A list with all gm_codes can be found here https://www.cbs.nl/-/media/cbs/onze-diensten/methoden/classificaties/overig/gemeenten-alfabetisch-2022.xlsx
# In this example we use the gm_code of the municipality of Rotterdam.
gm_code = sys.argv[1]

apikey = os.getenv("DD_APIKEY")
if not apikey:
    apikey  = input("Enter apikey: ")


# geography_types, do you want stats for no_parking zones, microhubs(=stops) or monitoring zones?
# geography_types = ['no_parking', 'stop', 'monitoring']
geography_types = ['stop']
# one of '5m', '15m', 'hour', 'day', 'week' or 'month'
aggregation_level = 'day'
end_date = datetime.now().replace(hour=2,minute=0,second=0,microsecond=0, tzinfo=None)
start_date = end_date - timedelta(days = 2)


# 1. Get all zones within one municipality, this is a public endpoint so no apikey is needed.
params = [('municipality', gm_code)] + list(map(lambda geography_type: ('geography_types', geography_type), geography_types))
encoded_params = urlencode(params)
url = f'https://mds.dashboarddeelmobiliteit.nl/public/zones?{encoded_params}'
r = requests.get(url)
zones = r.json()

def get_rental_stats(aggregation_level, zone_id, start_time, end_time):
    url = f'https://api.deelfietsdashboard.nl/dashboard-api/stats_v2/rental_stats?aggregation_level={aggregation_level}&group_by=operator&aggregation_function=MAX&zone_ids={zone_id}&start_time={start_time.isoformat()}&end_time={end_time.isoformat()}'
    r = requests.get(url, headers={'apikey': apikey})
    return r.json()

def sumarize_result(data, zone_id, name):
    values = []
    for value in data["rental_stats"]["values"]:
        sum_rentals_started = 0
        sum_rentals_ended = 0
        for operator in value.values():
            if type(operator) is str:
                break
            for rental_stat in operator.values():
                if type(rental_stat) is dict:
                    sum_rentals_started += rental_stat["rentals_started"]
                    sum_rentals_ended += rental_stat["rentals_ended"]
        date_stamp = datetime.fromisoformat(value["time"]).strftime("%Y-%m-%d")
        values.append((date_stamp, zone_id, name, sum_rentals_started, sum_rentals_ended))
    return values


# 2. Get stats for zones.
sheet = []
for zone in zones:
    data = get_rental_stats(aggregation_level, zone["zone_id"], start_date, end_date)
    result = sumarize_result(data, zone["zone_id"], zone["name"])
    sheet.extend(result)

# 3. Convert data into .csv and store
with open('export.csv', 'w') as f:
    # create the csv writer
    writer = csv.writer(f)
    writer.writerow(('datum', 'zone_id', 'naam hub', 'aantal gestarte verhuringen', 'aantal geëindigde verhuringen'))
    for row in sheet:
        writer.writerow(row)
