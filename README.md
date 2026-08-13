# Chaat Bazaar Sales Analytics

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

## Progress log

- **Day 2** — AZ-900 cloud concepts studied; 15 SQL exercises + 7-query mini challenge completed (all verified against the dataset in SQLite); first dummy dataset created and committed.
