# AZ-900 — Day 2: Cloud Concepts

## What is cloud computing?
The delivery of computing services — servers, storage, databases, networking, software, analytics — over the internet ("the cloud"), paying only for what you use instead of owning and maintaining physical infrastructure.

## Shared responsibility model
Security and management duties are split between the cloud provider and the customer. The provider always secures the physical datacenter, network, and hosts. The customer always owns their data, accounts, and access management. Everything in between (OS, applications, network controls) shifts depending on the service model: IaaS gives the customer the most responsibility, SaaS the least.

## Cloud deployment models
- **Public cloud** — services run on the provider's shared infrastructure, available to anyone (e.g. Azure, AWS). No capital expense, near-unlimited scale, but less control.
- **Private cloud** — cloud-style infrastructure used exclusively by one organization, on-premises or hosted. Maximum control, maximum cost and maintenance burden.
- **Hybrid cloud** — combines both, letting workloads move between them. Common when regulations require some data to stay on-premises.

## Consumption-based model
Pay-as-you-go: you're billed for actual resource usage (compute seconds, GB stored, requests served), not for capacity you provisioned. No upfront cost, no wasted idle capacity, easy to stop paying.

## CapEx vs OpEx
- **CapEx (Capital Expenditure)** — large upfront spending on physical assets (buying servers, building a datacenter). Value depreciates over time.
- **OpEx (Operational Expenditure)** — ongoing spending on services as you use them (a monthly Azure bill). Cloud shifts IT spending from CapEx to OpEx.
- Restaurant analogy: buying a tandoor oven outright is CapEx; the monthly Talabat commission is OpEx.

## Serverless computing
You write and deploy code without provisioning or managing any servers at all. The platform (e.g. Azure Functions) automatically runs, scales, and bills per execution. Servers still exist — you just never see them.

## High availability
The ability of a system to stay operational and accessible for a very high percentage of time (measured in "nines" — 99.9% uptime ≈ under 9 hours of downtime per year), achieved through redundancy and failover.

## Scalability
The ability to adjust resources to meet demand.
- **Vertical scaling (scale up)** — a bigger machine (more CPU/RAM).
- **Horizontal scaling (scale out)** — more machines working together.
Elasticity is scalability done automatically in response to demand.

## Reliability
The ability of a system to recover from failures and continue functioning — closely tied to resiliency, achieved through decentralized design across regions and availability zones.

---

## The three service models

| Model | Meaning | Customer manages | Generic example | Chaat Bazaar example |
|---|---|---|---|---|
| IaaS | Infrastructure as a Service | Most: OS, runtime, apps, data | Azure VM | Renting an Azure VM to host a custom multi-branch sales database — you install and patch everything on it yourself |
| PaaS | Platform as a Service | Mainly applications and data | Azure App Service | Building a branch sales dashboard on Azure App Service — you write the app; Azure handles servers, OS, and patching |
| SaaS | Software as a Service | Mostly configuration and use | Microsoft 365 | The Talabat partner portal or the POS system — you log in and use it; no servers, no code, no infrastructure |

**Pizza analogy** (works for chaat too): IaaS is renting a kitchen — bring your own ingredients and cook. PaaS is a meal kit — ingredients supplied, you cook. SaaS is ordering delivery — everything done for you.
