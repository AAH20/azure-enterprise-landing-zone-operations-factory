# Azure Enterprise Landing Zone Operations Factory

> Microsoft Azure · AZ-104 · AZ-305 · Azure Landing Zones · Microsoft Entra ID · Azure Policy · Azure RBAC · Hub-and-Spoke · Private Link · Azure Monitor · Bicep · Terraform · FinOps

[![CI](https://github.com/AAH20/azure-enterprise-landing-zone-operations-factory/actions/workflows/ci.yml/badge.svg)](https://github.com/AAH20/azure-enterprise-landing-zone-operations-factory/actions/workflows/ci.yml)

An exam-aligned operations and architecture factory that turns Azure administration tasks into reusable landing-zone controls, decision records, failure exercises and cost-aware evidence.

**Evidence status:** locally implemented and structurally verified. Azure deployment is **blocked by tenant recovery** and is not claimed. Screenshots are accepted only after a successful `what-if`, deployment and independent verification.

## What this proves

| Capability | AZ-104 implementation evidence | AZ-305 design evidence |
|---|---|---|
| Identity | RBAC matrix and managed-identity pattern | least privilege and emergency-access ADR |
| Governance | management groups, policy initiative, tags, locks and budget | inheritance, exemptions and subscription-vending decisions |
| Networking | hub/spoke VNets, peering, NSGs, routes and Private DNS | hybrid connectivity and egress trade-offs |
| Platform | secure storage, Key Vault and optional Container Apps | PaaS/container/VM selection matrix |
| Operations | Log Analytics, diagnostics, alerts and recovery design | RPO/RTO, observability and regional-resilience decisions |
| FinOps | deployment profiles and budget guardrails | unit economics and workload placement |

## Deployment profiles

| Profile | Intended use | Billable components |
|---|---|---|
| `validate-only` | CI, study and architecture review | none deployed |
| `ephemeral-lab` | short-lived portal/CLI evidence | empty Log Analytics workspace and small LRS storage; optional services off |
| `architecture-only` | enterprise topology review | expensive services represented as decisions, not deployed |

Azure Firewall, Bastion, VPN Gateway, Application Gateway, AKS, databases, compute and alert delivery are deliberately absent or disabled in the default lab.

## Architecture

```text
Tenant root
└── mg-a2zsoc
    ├── mg-platform
    │   ├── connectivity
    │   ├── identity
    │   └── management
    ├── mg-landing-zones
    │   ├── production
    │   └── non-production
    └── mg-sandbox

Ephemeral workload resource group
├── hub VNet ── peering ── spoke VNet
│   ├── AzureFirewallSubnet (reserved; no firewall deployed)
│   ├── shared-services subnet
│   ├── workload subnet + NSG
│   └── private-endpoint subnet
├── Private DNS zone
├── OAuth-only StorageV2 + Private Endpoint
├── Key Vault with RBAC authorization
└── Log Analytics workspace with capped retention
```

## Validate locally

```bash
./scripts/validate.sh
```

## Safe Azure sequence

```bash
./scripts/preflight.sh
./scripts/what-if.sh
# Review the complete change set before explicitly running:
./scripts/deploy-ephemeral.sh
./scripts/verify.sh
./scripts/destroy.sh
```

Deployment scripts refuse to run unless the expected subscription is explicitly supplied. Destruction also requires the exact resource-group name and a confirmation value.

## Study path

1. [Identity and governance](docs/labs/01-identity-governance.md)
2. [Enterprise networking](docs/labs/02-networking.md)
3. [Compute and data decisions](docs/labs/03-compute-data.md)
4. [Monitoring and recovery](docs/labs/04-operations-recovery.md)
5. [Architecture review](docs/labs/05-architecture-review.md)

See the [exam objective map](docs/exam-objective-map.md), [cost model](docs/cost-model.md), [evidence contract](evidence/README.md) and [A2Z SOC engagement page](https://a2zsoc.com/consultation).

## Claims boundary

- Passing local tests proves template structure and configured safety invariants.
- `what-if` proves Azure accepted a proposed change set; it does not prove deployment.
- A deployment record proves resource creation; it does not prove workload behavior.
- Verification output plus timestamped screenshots support an operational claim.
- No certification is claimed before the relevant exam is passed.

## License

MIT
