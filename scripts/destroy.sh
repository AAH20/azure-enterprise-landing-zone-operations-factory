#!/usr/bin/env bash
set -euo pipefail
: "${AZURE_SUBSCRIPTION_ID:?Set AZURE_SUBSCRIPTION_ID explicitly}"
: "${AZURE_RESOURCE_GROUP:?Set the exact AZURE_RESOURCE_GROUP}"
: "${CONFIRM_DESTROY:?Set CONFIRM_DESTROY to the exact resource-group name}"
./scripts/preflight.sh
if [[ "$CONFIRM_DESTROY" != "$AZURE_RESOURCE_GROUP" ]]; then
  echo "Refusing: confirmation does not match resource-group name" >&2
  exit 1
fi
az group delete --name "$AZURE_RESOURCE_GROUP" --yes --no-wait
