# ADR 0001: Hub-and-spoke network

**Status:** accepted for the study implementation.

## Decision

Use a hub-and-spoke topology with reserved centralized-security subnets and bidirectional peering. Do not deploy Azure Firewall or VPN Gateway in the default profile.

## Consequences

The topology demonstrates segmentation and shared-services boundaries at minimal cost. Production requires route-table, DNS-proxy, egress inspection, DDoS and hybrid-connectivity decisions. Reserved subnets are architectural evidence, not proof that a firewall exists.
