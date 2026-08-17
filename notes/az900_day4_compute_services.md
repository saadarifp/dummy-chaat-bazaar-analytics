# AZ-900 — Day 4: Azure Compute Services

- **Virtual Machines (VMs)** — full servers you rent; you control OS, patching, software. Maximum control, maximum responsibility (IaaS).
- **VM Scale Sets** — groups of identical VMs that automatically add/remove instances with demand.
- **App Service** — managed hosting for web apps and APIs; you deploy code, Azure runs the servers (PaaS).
- **Azure Functions** — serverless: small pieces of code that run on a trigger (timer, file upload, HTTP call). Billed per execution; no servers to manage.
- **Containers** — apps packaged with all their dependencies so they run identically anywhere; lighter and faster to start than VMs because they share the host OS.
- **Kubernetes / AKS** — an orchestrator that runs and manages many containers: scheduling, scaling, restarting failed ones. AKS is Azure's managed version.
- **Azure Virtual Desktop** — full Windows desktops streamed from the cloud to any device.

## Key comparisons
1. **VM vs App Service** — VM: you manage the OS and everything on it, run anything. App Service: you only bring code; Azure manages OS/patching, but web workloads only.
2. **Azure Functions** — runs event-triggered code without any server management, billed only when it runs.
3. **Why containers** — consistency ("works on my machine" solved), fast startup, high density, easy scaling.
4. **Scaling** — adding capacity for demand: vertical = bigger machine, horizontal = more machines. Scale Sets/AKS do it automatically.

## Service-to-business-use table

| Business need | Azure service |
|---|---|
| Restaurant website | App Service |
| Scheduled sales report | Azure Functions |
| Legacy Windows application | Virtual Machine |
| Remote staff desktop | Azure Virtual Desktop |
| **Own #1:** Nightly job that pulls Talabat/Careem/Noon order files and loads them into the sales database | Azure Functions (timer trigger) |
| **Own #2:** Chaat Bazaar POS backend API packaged once and run identically across all branches, scaling up at dinner rush | Containers on AKS |

**"If one datacenter fails…"** — still the availability-zone answer from Day 3: run across zones and the surviving zones keep serving.
