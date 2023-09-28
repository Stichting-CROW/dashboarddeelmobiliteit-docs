#!/bin/bash

if grep -q "FUSIONAUTH_APP_ID" .env
then
    echo "FUSIONAUTH_APP_ID variable already set in .env"
else
    cat config_gateway >> .env
fi
export $(grep -v '^#' .env | xargs -d '\n')
export $(grep -v '^#' config | xargs -d '\n')

# Add first user to DB.
psql dashboarddeelmobiliteit -h '127.0.0.1' -U postgres \
  -c "INSERT INTO user_account (user_id, privileges, organisation_id) VALUES ('$FIRST_USER',  '{}', 1) ON CONFLICT DO NOTHING;"

# Setup global plugins

# set wildcard for CORS.
curl -X POST http://localhost:8001/plugins/ \
    --data "name=cors"  \
    --data "config.origins=*"

curl --request POST \
  --url http://localhost:8001/consumers \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"username":"fusionauth_authorized","custom_id":"fusionauth_authorized","tags":["general"]}'

curl -X POST http://localhost:8001/consumers/fusionauth_authorized/jwt \
  -F "algorithm=RS256" \
  -F "rsa_public_key=@./public-key.pem" \
  -F "key=${JWT_ISSUER}"

curl --request POST \
  --url http://localhost:8001/consumers \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"username":"anonymous_consumer","custom_id":"anonymous_consumer","tags":["general"]}'

 curl -sX POST localhost:8001/consumers/anonymous_consumer/plugins/ \
   -H "Content-Type: application/json" \
   --data '{"name": "request-termination", "config": { "status_code": 401, "content_type": "application/json; charset=utf-8", "body": "{\"error\": \"Authentication required\"}"} }'

# Setup dashboard api
curl -s -X POST http://localhost:8001/services \
  --data name=dashboard-api \
  --data url='http://dashboard-api:8000'

curl -s -X POST http://localhost:8001/services/dashboard-api/routes \
  --data 'paths[]=/dashboard-api' \
  --data name=dashboard-api-route

curl -s -X POST http://localhost:8001/services \
  --data name=dashboard-api-public \
  --data url='http://dashboard-api:8000/public'

curl -X POST http://localhost:8001/services/dashboard-api-public/routes \
  --data 'paths[]=/dashboard-api/public' \
  --data name=dashboard-api-public-route 
  
curl -X POST http://localhost:8001/routes/dashboard-api-route/plugins \
  --data "name=jwt" \
  --data "config.anonymous=anonymous_consumer"

curl -X POST http://localhost:8001/route/dashboard-api-route/plugins \
    --data "name=key-auth"  \
    --data "config.key_names=apikey" \
    --data "config.anonymous=anonymous_consumer"

# 2 microhubs api
# admin + MDS
curl -s -X POST http://localhost:8001/services \
  --data name=microhubs-api \
  --data url='http://policy-api:80'

curl -X POST http://localhost:8001/services/microhubs-api/routes \
  --data "hosts[]=${MDS_URL}" \
  --data 'paths[]=/admin' \
  --data name=microhubs-admin \
  --data strip_path=false

curl -X POST http://localhost:8001/services/microhubs-api/routes \
  --data "hosts[]=${MDS_URL}" \
  --data 'paths[]=/' \
  --data name=mds-public

# 3 od api
curl -s -X POST http://localhost:8001/services \
  --data name=od-api \
  --data url='http://od-api:80'

curl -X POST http://localhost:8001/services/od-api/routes \
  --data "hosts[]=${API_PROXY_URL}" \
  --data 'paths[]=/od-api' \
  --data name=od-api-route


curl -X POST http://localhost:8001/routes/od-api-route/plugins \
    --data "name=jwt"

#4 admin api

curl -s -X POST http://localhost:8001/services \
  --data name=admin-api \
  --data url='http://admin-api:80'

curl -X POST http://localhost:8001/services/admin-api/routes \
  --data "hosts[]=${API_PROXY_URL}" \
  --data 'paths[]=/admin' \
  --data name=admin-api-route


# Restart everything with changed environment variables.
./run.sh
