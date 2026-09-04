#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_SUBSCRIPTION_ID:?Set AZURE_SUBSCRIPTION_ID explicitly}"
: "${AZURE_RESOURCE_GROUP:=rg-enterprise-lz-ops-lab}"
./scripts/preflight.sh
az group show --name "$AZURE_RESOURCE_GROUP" --query '{name:name,location:location,state:properties.provisioningState,tags:tags}' -o json
az resource list --resource-group "$AZURE_RESOURCE_GROUP" --query '[].{name:name,type:type,location:location}' -o table
az deployment group show --resource-group "$AZURE_RESOURCE_GROUP" --name lz-ephemeral --query '{state:properties.provisioningState,timestamp:properties.timestamp,correlationId:properties.correlationId}' -o json
