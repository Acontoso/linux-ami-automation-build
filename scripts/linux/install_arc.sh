#!/bin/bash

# <--- Change the following environment variables according to your Azure service principal name --->

echo "Exporting environment variables"
export subscriptionId=$(aws ssm get-parameter --with-decryption  --name "/arc/subscription" | jq -r '.Parameter.Value')
export appId=$(aws ssm get-parameter --with-decryption  --name "/arc/client_id" | jq -r '.Parameter.Value')
export password=$(aws ssm get-parameter --with-decryption  --name "/arc/client_secret" | jq -r '.Parameter.Value')
export tenantId=$(aws ssm get-parameter --with-decryption  --name "/arc/tenant_id" | jq -r '.Parameter.Value')
export resourceGroup=$(aws ssm get-parameter --with-decryption  --name "/arc/resource_group" | jq -r '.Parameter.Value')
export location=$(aws ssm get-parameter --with-decryption  --name "/arc/region" | jq -r '.Parameter.Value')

sudo apt-get update
wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh
bash ~/install_linux_azcmagent.sh
sudo azcmagent connect \
  --service-principal-id "${appId}" \
  --service-principal-secret "${password}" \
  --resource-group "${resourceGroup}" \
  --tenant-id "${tenantId}" \
  --location "${location}" \
  --subscription-id "${subscriptionId}" \
  --correlation-id "d009f5dd-dba8-4ac7-bac9-b54ef3a6671a"
