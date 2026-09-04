# ADR 0002: Private PaaS access

**Status:** accepted.

Use Microsoft Entra authorization, disable public blob access and shared keys, and connect blob storage through Private Link and Private DNS. Key Vault uses Azure RBAC and denies public-network access. This improves the production posture but requires private DNS and a connected administration path for real data-plane operations.
