#!/bin/bash
aws configure set default.region ap-southeast-2
export CROWDSTRIKE_API_KEY=$(aws ssm get-parameter --with-decryption  --name "/codebuild/soe-build/crowdstrike_api_key" | jq -r '.Parameter.Value')
export CROWDSTRIKE_CLIENT_ID=$(aws ssm get-parameter --with-decryption  --name "/codebuild/soe-build/crowdstrike_client_id" | jq -r '.Parameter.Value')
TOKEN=$(curl -X POST "https://api.crowdstrike.com/oauth2/token" -H "accept: application/json" -H "Content-Type: application/x-www-form-urlencoded" -d "client_id=${CROWDSTRIKE_CLIENT_ID}&client_secret=${CROWDSTRIKE_API_KEY}" | | jq -r '.access_token')
curl -X GET 'https://api.crowdstrike.com/sensors/entities/download-installer/v1?id=b54bf3bb2ab6da9fcc9121fadbaaaxxxxxxxxxxxxxxxxxxxx1681baa3033f134' -H "Authorization: Bearer ${TOKEN}" -o ubuntu-falcon-sensor.deb
dpkg -i ubuntu-falcon-sensor.deb
/opt/CrowdStrike/falconctl -d -f --aid && /opt/CrowdStrike/falconctl -s --cid=XX30B757D8104150B22XX6DF80F8E2C0-XX
systemctl start falcon-sensor
rm ubuntu-falcon-sensor.deb
