#!/usr/bin/env bash
set -euo pipefail

: "${AZURE_SUBSCRIPTION_ID:?Set AZURE_SUBSCRIPTION_ID explicitly}"
az account show --query '{subscription:id,tenant:tenantId,user:user.name,state:state}' -o table
actual="$(az account show --query id -o tsv)"
if [[ "$actual" != "$AZURE_SUBSCRIPTION_ID" ]]; then
  echo "Refusing: active subscription does not match AZURE_SUBSCRIPTION_ID" >&2
  exit 1
fi
az provider show --namespace Microsoft.Network --query registrationState -o tsv
az provider show --namespace Microsoft.Storage --query registrationState -o tsv
az provider show --namespace Microsoft.OperationalInsights --query registrationState -o tsv
