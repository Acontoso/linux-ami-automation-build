#!/bin/bash
QUALYS_SERVICE_ACCOUNT=$(aws ssm get-parameter --with-decryption  --name "/qualys/qualys_service_account" | jq -r '.Parameter.Value')
QUALYS_PASSWORD=$(aws ssm get-parameter --with-decryption  --name "//qualys/qualys_password" | jq -r '.Parameter.Value')
ACTIVATION_ID=$(aws ssm get-parameter --with-decryption  --name "/qualys/activation_id" | jq -r '.Parameter.Value')
CUSTOMER_ID=$(aws ssm get-parameter --with-decryption  --name "/qualys/customer_id" | jq -r '.Parameter.Value')

DISTRO=$(lsb_release -si)

if [[ "${DISTRO}" == "Ubuntu" ]]; then
    FILE_VERSION="ubuntu"
else
    FILE_VERSION="general"
fi

curl -u ${QUALYS_SERVICE_ACCOUNT}:${QUALYS_PASSWORD} -X POST -H "Content-Type: text/xml" \ 
-H "X-Requested-With: curl" --data-binary @qualys-payload-${FILE_VERSION}.xml \
"https://qualysapi.qualys.com/qps/rest/1.0/download/ca/downloadbinary/" --remote-name QualysCloudAgent.deb

echo "Agent successfully downloaded"
sudo dpkg --install ./QualysCloudAgent.deb

sudo /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh \
ActivationId=${ACTIVATION_ID} CustomerId=${CUSTOMER_ID}
echo "Agent successfully installed, removing installer"
rm QualysCloudAgent.deb
