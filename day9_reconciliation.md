# Day 9 Task 3 - SQL <-> Pandas Reconciliation

Three findings from `day9_business_findings.md` were recomputed independently in
Pandas, straight from `restaurant_sales_750.csv`, and compared to the SQL output
of `chaat_bazaar_day9.db`. Script: `day9_reconciliation.py`.

**Result: PASS - all three reconcile to the cent.**

| # | Finding | Metric checked | SQL | Pandas | Match |
|---|---|---|---|---|---|
| 1 | Growth earned more cheaply | Commission % of gross, by month | 17.43 / 15.68 / 15.87 | 17.43 / 15.68 / 15.87 | yes |
| 1 | | Discount % of gross, by month | 2.89 / 2.54 / 2.39 | 2.89 / 2.54 / 2.39 | yes |
| 1 | | Net margin %, by month | 79.68 / 81.78 / 81.74 | 79.68 / 81.78 / 81.74 | yes |
| 3 | Growth is mostly the new branch | Company net, by month | 13,472.73 / 13,340.03 / 14,262.19 | same | yes |
| 3 | | Net excluding Deira, by month | 11,785.71 / 10,896.84 / 11,968.25 | same | yes |
| 4 | Biggest branch trading value for volume | Karama orders / month | 96 / 76 / 104 | 96 / 76 / 104 | yes |
| 4 | | Karama AOV / month | 45.85 / 48.14 / 40.40 | same | yes |
| 4 | | Karama items per order | 3.72 / 3.78 / 3.45 | same | yes |

## Why an exact match is the right expectation here

Both paths start from the same 988 CSV rows. The SQL path first pushes them
through the normalised model: text keys (`Branch`, `Product`, `Aggregator`) are
replaced with integer ids, the fact table is rebuilt by joining three dimension
tables, and a view joins everything back. Any bug in that pipeline - a join that
fans out and duplicates rows, a mismatched key that drops rows, an id collision -
would show up as a number that no longer matches the flat-file Pandas result.

So the reconciliation is really a test of the model build, not of arithmetic. It
passing means the star schema in `chaat_bazaar_day9.db` is a faithful
representation of the CSV: 988 rows in, 988 rows out, every branch / product /
channel mapped to exactly one id and back.

## What was actually checked, not just eyeballed

`day9_reconciliation.py` builds each result as a DataFrame from each source,
rounds both to 2 decimals, and asserts `sql_df.equals(pd_df)`. The script exits
non-zero if any of the three fail, so it can run in CI.

## One thing that had to be handled (not a mismatch)

Pandas 3.0 changed `groupby.apply` to raise unless you pass
`include_groups=False`; the grouping column is no longer silently included in the
applied function. This is a library API change, not a data problem - once the
argument was added, the Finding 3 numbers matched SQL exactly. Worth noting
because "the code errored" and "the numbers disagree" are different failures and
only the second one is a reconciliation problem.

## If they had disagreed - the checklist I would have worked through

1. Row count first: `SELECT COUNT(*) FROM orders` vs `len(df)`. A join fan-out
   or a dropped key changes this immediately.
2. Filter definitions: does "weekend" mean the same days on both sides?
   (SQLite `strftime('%w')` is 0=Sun..6=Sat; pandas `dt.dayofweek` is
   0=Mon..6=Sun - an easy off-by-one.)
3. Type coercion: money columns read as REAL in SQLite vs float64 in pandas;
   dates as TEXT `YYYY-MM-DD` vs datetime. Substring month key vs `dt.strftime`.
4. Null handling: `SUM` skips NULLs in SQL, `.sum()` skips NaN in pandas - same
   here, but `AVG` vs `.mean()` over a column with NULLs can diverge.
5. Rounding: round once at the end on both sides, never mid-calculation.

None of these bit this time, but they are the usual suspects.
