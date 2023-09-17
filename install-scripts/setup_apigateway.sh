
export $(grep -v '^#' config | xargs -d '\n')

# Setup global plugins

# set wildcard for CORS.
curl -X POST http://localhost:8001/plugins/ \
    --data "name=cors"  \
    --data "config.origins=*"

# Setup JWT
curl --request POST \
  --url http://localhost:8001/consumers \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"username":"fusionauth_authorized","custom_id":"fusionauth_authorized","tags":["general"]}'

curl -X POST http://localhost:8001/consumers/fusionauth_authorized/jwt \
  -F "rsa_public_key=@public-key.pem" \

curl --request POST \
  --url http://localhost:8001/consumers \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"username":"deny","custom_id":"deny","tags":["general"]}'



# Setup dashboard api
curl -i -s -X POST http://localhost:8001/services \
  --data name=dashboard-api \
  --data url='http://dashboard-api:8000'

curl -i -X POST http://localhost:8001/services/dashboard-api/routes \
  --data 'paths[]=/dashboard-api' \
  --data name=dashboard-api-route

curl -i -s -X POST http://localhost:8001/services \
  --data name=dashboard-api-public \
  --data url='http://dashboard-api:8000/public'

curl -i -X POST http://localhost:8001/services/dashboard-api-public/routes \
  --data 'paths[]=/dashboard-api/public' \
  --data name=dashboard-api-public-route

# 2 microhubs api
# admin + MDS
curl -i -s -X POST http://localhost:8001/services \
  --data name=microhubs-api \
  --data url='http://policy-api:80'

curl -i -X POST http://localhost:8001/services/microhubs-api/routes \
  --data "hosts[]=${MDS_URL}" \
  --data 'paths[]=/admin' \
  --data name=microhubs-admin \
  --data strip_path=false

curl -i -X POST http://localhost:8001/services/microhubs-api/routes \
  --data "hosts[]=${MDS_URL}" \
  --data 'paths[]=/' \
  --data name=mds-public

# 3 od api
curl -i -s -X POST http://localhost:8001/services \
  --data name=od-api \
  --data url='http://od-api:80'

curl -i -X POST http://localhost:8001/services/od-api/routes \
  --data "hosts[]=${API_PROXY_URL}" \
  --data 'paths[]=/od-api' \
  --data name=od-api-route

#4 admin api

curl -i -s -X POST http://localhost:8001/services \
  --data name=admin-api \
  --data url='http://admin-api:80'

curl -i -X POST http://localhost:8001/services/admin-api/routes \
  --data "hosts[]=${API_PROXY_URL}" \
  --data 'paths[]=/admin' \
  --data name=admin-api-route