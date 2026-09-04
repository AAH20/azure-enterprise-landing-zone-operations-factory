#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_SUBSCRIPTION_ID:?Set AZURE_SUBSCRIPTION_ID explicitly}"
: "${AZURE_LOCATION:=eastus}"
: "${AZURE_RESOURCE_GROUP:=rg-enterprise-lz-ops-lab}"
./scripts/preflight.sh
az deployment sub what-if --location "$AZURE_LOCATION" --name lz-governance-preview --template-file infra/subscription/governance.bicep --parameters location="$AZURE_LOCATION" resourceGroupName="$AZURE_RESOURCE_GROUP" monthlyBudgetUsd=15
az deployment group what-if --resource-group "$AZURE_RESOURCE_GROUP" --template-file infra/main.bicep --parameters infra/profiles/ephemeral-lab.bicepparam
