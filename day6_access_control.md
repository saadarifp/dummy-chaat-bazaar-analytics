# Day 6 Access Control Model

Principle applied: least privilege with RBAC roles in Microsoft Entra ID, scoped to the resource groups from the Day 3 hierarchy

## Access model

Owner: Owner role at the management group. Full control everywhere, MFA enforced, the only identity that can change access itself
Accountant: Reader on production sales data plus Contributor on the finance storage only. Sees all branches, edits nothing operational
Area Manager: Reader across all branch data in CB-Production. Can compare branches, cannot modify systems
Branch Manager: Reader scoped to own branch data only, row level filter on Branch_ID. No visibility into other branches
Cashier: no Azure access at all. Interacts with the POS application, the application writes to the database with its own service identity
Data Analyst: Contributor on CB-Analytics resource group, Reader on production data copies. Builds reports, never touches live POS systems
Franchise Partner: Reader on a filtered dataset covering their franchise branch only, delivered through a shared report, no direct database access

Conditional Access on top: MFA for every role, block sign ins from outside UAE for finance and owner accounts, cashier app access limited to branch network

## Why not administrator for everyone

One compromised password becomes full company compromise, any mistake can delete production, the accountant does not need the power to shut down the POS, and audits cannot distinguish who changed what when everyone can change everything. Least privilege limits blast radius of both attacks and accidents, and RBAC makes access match job function instead of trust
