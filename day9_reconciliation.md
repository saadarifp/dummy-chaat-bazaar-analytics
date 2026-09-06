# Day 9 Task 3 - SQL vs Pandas Reconciliation

Three findings recomputed in Pandas from restaurant_sales_750.csv and compared to
SQL output from chaat_bazaar_day9.db. Script: day9_reconciliation.py.

Result: PASS. All three reconcile to the cent.

| Finding | Metric | SQL | Pandas |
|---|---|---|---|
| 1 | Commission % of gross, by month | 17.43 / 15.68 / 15.87 | same |
| 1 | Discount % of gross, by month | 2.89 / 2.54 / 2.39 | same |
| 1 | Net margin %, by month | 79.68 / 81.78 / 81.74 | same |
| 3 | Company net, by month | 13,472.73 / 13,340.03 / 14,262.19 | same |
| 3 | Net excluding Deira, by month | 11,785.71 / 10,896.84 / 11,968.25 | same |
| 4 | Karama orders per month | 96 / 76 / 104 | same |
| 4 | Karama AOV per month | 45.85 / 48.14 / 40.40 | same |
| 4 | Karama items per order | 3.72 / 3.78 / 3.45 | same |

## Why an exact match is expected

Both paths start from the same 988 CSV rows. The SQL path first pushes them
through the normalised model: text keys swapped for integer ids, fact table
rebuilt by joining three dimension tables. A bad join (fan-out, dropped key, id
collision) would show up as a number that no longer matches the flat-file Pandas
result.

So this reconciliation tests the model build, not the arithmetic. Passing means
the star schema is a faithful copy of the CSV: 988 rows in, 988 out, every key
mapped and mapped back.

## What the script checks

It builds each result as a DataFrame from each source, rounds both to 2 decimals,
and asserts sql_df.equals(pd_df). Exits non-zero if any of the three fail.

## One thing that had to be handled

Pandas 3.0 changed groupby.apply to raise unless you pass include_groups=False.
That is a library API change, not a data problem. Once the argument was added the
numbers matched. "The code errored" and "the numbers disagree" are different
failures; only the second is a reconciliation problem.

## Checklist if they had disagreed

1. Row count first: SELECT COUNT(*) vs len(df).
2. Filter definitions: does "weekend" mean the same days? SQLite strftime('%w')
   is 0=Sun..6=Sat; pandas dayofweek is 0=Mon..6=Sun.
3. Type coercion: REAL vs float64, TEXT dates vs datetime.
4. Null handling: SUM and .sum() both skip nulls; AVG vs .mean() over nulls can
   diverge.
5. Rounding: round once at the end on both sides.
