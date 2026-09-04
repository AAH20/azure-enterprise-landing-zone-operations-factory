# Cost model and unit economics

## Default ephemeral profile

| Component | Cost driver | Guardrail |
|---|---|---|
| VNets, NSGs, peering | configuration; peering data transfer may be billed | no workload traffic |
| Standard LRS storage | capacity and transactions | empty account; seven-day soft-delete window |
| Private Endpoint | hourly endpoint and processed data | one endpoint; destroy after evidence capture |
| Private DNS | hosted zone and queries | one zone, no workload queries |
| Key Vault | operations and advanced features | no secrets or transactions |
| Log Analytics | ingestion and retention | empty workspace, 30-day retention |
| Policy/budget | no workload compute | USD 15 monthly guardrail |

Prices vary by region, agreement and date. Obtain a current Azure Pricing Calculator estimate before deployment and record actual Cost Management data after billing settles.

## Decision formula

`monthly platform cost = fixed service hours + data processed + storage retained + operations + support + engineering toil`

For each architecture alternative, document cost per protected workload, cost per GB observed, recovery cost per incident and engineering hours avoided. Do not present estimates as invoices.
