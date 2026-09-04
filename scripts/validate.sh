#!/usr/bin/env bash
set -euo pipefail
az bicep build --file infra/main.bicep --stdout >/dev/null
az bicep build --file infra/subscription/governance.bicep --stdout >/dev/null
python3 -m unittest discover -s tests -v
