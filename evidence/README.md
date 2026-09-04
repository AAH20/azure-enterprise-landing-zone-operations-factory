# Evidence contract

Azure deployment is currently **blocked by tenant recovery**. No cloud screenshots are committed yet.

For each run, create a dated folder containing:

- `manifest.md`: subscription alias, region, profile, commit and timestamps
- `01-what-if.png`: complete proposed-change summary
- `02-deployment.png`: successful deployment state and correlation ID
- `03-resource-inventory.png`: named resource types and region
- `04-network-topology.png`: hub, spoke, peering and private endpoint
- `05-policy-budget.png`: policy compliance and budget
- `06-verification-cli.png`: redacted verification output
- `07-cost.png`: actual cost window after billing data settles
- `08-cleanup.png`: deletion or retained-resource decision

## Labels

Use only: `planned`, `implemented`, `locally-verified`, `what-if-verified`, `deployed`, `operationally-verified`, `blocked`, `destroyed`.

Screenshots must exclude email addresses, tokens, billing identifiers and unrelated resources. A screenshot supports a claim; it never replaces machine-readable verification.
