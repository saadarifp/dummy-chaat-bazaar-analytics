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

`restaurant_sales_750.csv` — the larger dataset used from Day 8 on: 988 orders (one line per order), June–August 2026, five branches (Karama, Muweilah, JVC, Barsha, and Deira which opened mid-window), four channels (Talabat, Careem, Noon, Direct). Day 9 loads it into `chaat_bazaar_day9.db` as a star model via `day9_build_database.py` (the `.db` is a build artifact and git-ignored — run the script to rebuild).

## Progress log

- **Day 2** — AZ-900 cloud concepts studied; 15 SQL exercises + 7-query mini challenge completed (all verified against the dataset in SQLite); first dummy dataset created and committed.
- **Day 3** — AZ-900 Azure architecture (regions, availability zones, resource hierarchy); full sales analysis in `day3_analysis.sql`: aggregation, GROUP BY/HAVING, branch & aggregator & product analysis, CASE WHEN order classification, CTE for above-average branches, RANK() window functions. Findings written up in `insights.md`.
- **Day 4** — Dataset normalized into `branches` / `orders` / `products` / `aggregators` tables (with a zero-order branch for LEFT JOIN practice); 15 JOIN queries + 9 data-quality checks in `day4_joins_and_validation.sql` (all checks pass); AZ-900 compute services notes added. Files reorganized per review: `day4_joins.sql`, `day4_data_validation.sql`, `data_quality_findings.md`, `rebuild_db.sql` (typed schema with primary and foreign keys). Day 3 type bug found and corrected.
- **Day 5** — Subqueries and CTEs: 10 queries in `day5_subqueries_cte.sql` incl. percent contribution and cumulative top 50% revenue; business analysis for management in `day5_business_analysis.md`; sanity checks in `day5_validation.md`; AZ-900 storage notes added.
- **Day 6** — Window functions chosen per problem in `day6_window_functions.sql` (RANK, PARTITION BY, cumulative SUM OVER, LAG, AVG OVER); open-ended CEO analysis with confidence levels in `day6_ceo_analysis.md`; Entra ID / RBAC access model in `day6_access_control.md`.
- **Day 7** — Pandas data cleaning of a deliberately messy file (`data/chaat_bazaar_sales_messy.csv`) in `day7_data_cleaning.ipynb`; management summary in `day7_management_summary.md`.
- **Day 8** — Larger 988-order dataset (`restaurant_sales_750.csv`, June–August 2026, five branches incl. new Deira, four channels); pre-load validation in `day8_data_validation.py`; open-ended business findings in `day8_business_findings.md`; first Power BI dashboard (`dummy_chaat_bazaar_dashboard.pbix`) with build guide and DAX measures.
- **Day 9** — End-to-end Python → SQL → Power BI → decision. `day9_build_database.py` loads the 988 rows into a SQLite star model (`orders` / `branches` / `products` / `channels`) and proves the load (row count, no duplicate/orphan keys, money identity, column types). `day9_sql_investigation.sql` + `day9_business_findings.md` answer one open question ("sales rose — is it healthy?") with six findings, two of which challenge the headline: strip out the new branch and like-for-like growth is ~+1.5%, and the biggest branch (Karama) is shrinking while trading ticket size for order count. `day9_reconciliation.py`/`.md` re-derive three findings in Pandas and reconcile to the cent. `day9_dax_measures.md` (Leakage %, Previous Month Net Sales, MoM Growth %, Direct Share %, Net Sales per Order, each in plain English), `day9_powerbi_v2.md` (dashboard additions only), `day9_ceo_decision.md` (remove Talabat? — NOT ENOUGH DATA, with the experiment to run), and `day9_debugging.py`/`.md` (a text value in a numeric column silently understates every total; guard added to the build script).
