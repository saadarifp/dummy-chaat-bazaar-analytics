# Dummy Chaat Bazaar Sales Analytics

*All data in this repo is synthetic/dummy data — no real business figures.*

A portfolio project analyzing sales data for Chaat Bazaar, a multi-branch UAE restaurant business. Built while working through a data analytics learning path (AZ-900, SQL, Excel/Power BI).

## Repository structure

```
/data     — datasets (currently dummy data; real anonymized data later)
/sql      — SQL practice exercises and analysis queries
/notes    — study notes (AZ-900 cloud concepts, SQL reference)
```

## Current dataset

`data/chaat_bazaar_sales_dummy.csv` — 35 dummy sales transactions (July 2026) across 4 branches (JVC, Muweilah, Karama, Barsha) and 4 order channels (Talabat, Careem, Noon, Direct).

Columns: Order_Date, Branch, Order_ID, Order_Type, Aggregator, Item_Name, Category, Quantity, Gross_Sales, Discount, Commission, Net_Sales.

Data is internally consistent: `Net_Sales = Gross_Sales − Discount − Commission`, with commission rates varying by aggregator (Talabat 25%, Careem 22%, Noon 20%, Direct 0%).

Normalized tables (Day 4): `data/branches.csv`, `data/orders.csv`, `data/products.csv`, `data/aggregators.csv`.

## Progress log

- **Day 2** — AZ-900 cloud concepts studied; 15 SQL exercises + 7-query mini challenge completed (all verified against the dataset in SQLite); first dummy dataset created and committed.
- **Day 3** — AZ-900 Azure architecture (regions, availability zones, resource hierarchy); full sales analysis in `day3_analysis.sql`: aggregation, GROUP BY/HAVING, branch & aggregator & product analysis, CASE WHEN order classification, CTE for above-average branches, RANK() window functions. Findings written up in `insights.md`.
- **Day 4** — Dataset normalized into `branches` / `orders` / `products` / `aggregators` tables (with a zero-order branch for LEFT JOIN practice); 15 JOIN queries + 9 data-quality checks in `day4_joins_and_validation.sql` (all checks pass); AZ-900 compute services notes added. Files reorganized per review: `day4_joins.sql`, `day4_data_validation.sql`, `data_quality_findings.md`, `rebuild_db.sql` (typed schema with primary and foreign keys). Day 3 type bug found and corrected.
- **Day 5** — Subqueries and CTEs: 10 queries in `day5_subqueries_cte.sql` incl. percent contribution and cumulative top 50% revenue; business analysis for management in `day5_business_analysis.md`; sanity checks in `day5_validation.md`; AZ-900 storage notes added.
