# AZ-900 — Day 3: Azure Architecture

## Physical infrastructure

- **Datacenters** — physical buildings full of servers, with independent power, cooling, and networking. You never interact with a datacenter directly; you deploy to regions.
- **Regions** — a geographical area (e.g. *UAE North* in Dubai, *UAE Central* in Abu Dhabi) containing one or more datacenters networked together with low latency. You pick a region when creating most resources.
- **Availability Zones** — physically separate datacenters *within* one region, each with independent power, cooling, and networking, connected by fast private fiber. Minimum three per zone-enabled region.
- **Region pairs** — each region is paired with another in the same geography at least 300 miles away (where possible). Azure replicates some services across the pair and staggers platform updates so both are never updated simultaneously. Protects against region-wide disasters.

**Key exam question — "If one Azure datacenter fails, how can Availability Zones help?"**
If your application runs across multiple Availability Zones, a failure in one datacenter (power cut, fire, flooding) only takes down the instances in that zone. The instances in the other zones — separate buildings with separate power and cooling — keep serving traffic, so the application stays available. Zones protect against *datacenter* failure; region pairs protect against *region-wide* failure.

## Management infrastructure

- **Resources** — the individual things you create: a VM, a database, a storage account, a function app.
- **Resource groups** — logical containers for resources that share a lifecycle. Deleting a resource group deletes everything in it. A resource lives in exactly one resource group.
- **Subscriptions** — the billing and access boundary. Every resource group belongs to one subscription; each subscription produces its own bill and can have its own policies and spending limits.
- **Management groups** — containers for organizing multiple subscriptions, so governance policies and access can be applied once and inherited downward.
- **Azure Resource Manager (ARM)** — the deployment and management layer that every request goes through, whether it comes from the portal, CLI, PowerShell, or an API. One consistent front door for creating, updating, and deleting resources.

## The hierarchy

```
Management Group
      │
      ▼
 Subscription
      │
      ▼
Resource Group
      │
      ▼
  Resources
```

Policies and access flow downward: something applied at the management group level is inherited by every subscription, resource group, and resource beneath it.

## Hypothetical Chaat Bazaar setup

```
Chaat Bazaar Management Group
│
├── Subscription: CB-Production
│   ├── RG: cb-prod-pos            → POS backend VM, order database
│   └── RG: cb-prod-web            → App Service (ordering site), CDN
│
├── Subscription: CB-Testing
│   └── RG: cb-test-sandbox        → test VMs, test database (deleted/rebuilt freely)
│
├── Subscription: CB-Analytics
│   └── RG: cb-analytics           → SQL database (sales data), Power BI workspace,
│                                    storage account for CSV uploads
│
└── Subscription: CB-Backups
    └── RG: cb-backups             → geo-redundant storage, Recovery Services vault
```

Why split it this way: each subscription gets its own bill (management sees exactly what analytics costs vs production), its own access rules (the analyst can touch CB-Analytics but not production POS systems), and testing can be torn down without any risk to production. Region choice: *UAE North* primary, with backups replicated to the *UAE Central* region pair.
