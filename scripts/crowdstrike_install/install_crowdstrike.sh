#!/bin/bash
CROWDSTRIKE_API_KEY=$(aws ssm get-parameter --with-decryption  --name "/crowdstrike/client_secret" | jq -r '.Parameter.Value')
CROWDSTRIKE_CLIENT_ID=$(aws ssm get-parameter --with-decryption  --name "/crowdstrike/client_id" | jq -r '.Parameter.Value')
TOKEN=
INSTALL_HASH=

get_cs__jwt_token () {
    TOKEN=$(curl -X POST "https://api.crowdstrike.com/oauth2/token" \
    -H "accept: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=${CROWDSTRIKE_CLIENT_ID}&client_secret=${CROWDSTRIKE_CLIENT_SECRET}" | jq -r .access_token)
}

get_latest_sensor_hash () {
    response=$(curl -X GET "https://api.crowdstrike.com/sensors/combined/installers/v1?filter=os:%27Ubuntu%27" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json")
    INSTALL_HASH=$(echo ${response} | jq -r '[.resources[] | select(.os_version == "16/18/20/22")][0].sha256')
}

install_crowdstrike_sensor () {
    curl -X GET "https://api.crowdstrike.com/sensors/entities/download-installer/v1?id=${INSTALL_HASH}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -o ubuntu-falcon-sensor.deb
    apt-get install -f -y ./ubuntu-falcon-sensor.deb 
    /opt/CrowdStrike/falconctl -s --cid=4E30B757D8104150B222E6DF80F8E2C0-48 && /opt/CrowdStrike/falconctl -d -f --aid
    systemctl start falcon-sensor
    rm ubuntu-falcon-sensor.deb
}

get_cs__jwt_token
get_latest_sensor_hash
install_crowdstrike_sensor
