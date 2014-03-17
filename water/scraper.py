import requests
import json
from bs4 import BeautifulSoup

CDEC_DOMAIN_STUB = 'http://cdec.water.ca.gov'
QUERY_STRING = '&d=16-Mar-2014+12:57&span=300years'

r = requests.get('http://cdec.water.ca.gov/misc/monthly_res.html')
# Change parser to deal with broken HTML
soup = BeautifulSoup(r.text, 'html.parser')

stations = []
for link in soup.find_all('a'):
    href = link.get('href')
    if '/cgi-progs/queryMonthly?' in href:
        station_id = href.split('?')[1]
        url = CDEC_DOMAIN_STUB+href+QUERY_STRING
        stations.append({
            'station_id': station_id,
            'url': url
        })

# Collect all monthly data for each station
data = {'dates': []}
for station in stations:
    station_id = station['station_id']
    print "Collecting data for {}...".format(station_id)

    r = requests.get(station['url'])
    soup = BeautifulSoup(r.text, 'html.parser')    

    rows = soup.find_all('tr')
    # Yields all table rows which are not header rows
    rows = rows[2:]

    station_data = []
    for row in rows:
        row_data = [child.string for child in row.children]
        date, storage = row_data[0], row_data[2].strip()
        station_data.append({
            'date': date,
            'storage': storage
        })
        
        # Oldest data is for ALM, since 10/1900 - use its dates as date range
        if station_id == 'ALM':
            data['dates'].append(date)

    data[station_id] = station_data

# Write data as JSON
f = open('monthly-reservoir-storage.json', 'wb')
f.write(json.dumps(data, indent=2))
f.close()
