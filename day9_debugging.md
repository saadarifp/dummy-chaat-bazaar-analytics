# Day 9 Task 8 - Debugging Test

What I broke: changed one numeric value in the source CSV to text. Row CB-2000's
Net_Sales went from 40.0 to 4O.0 (capital letter O instead of a zero). This is
what a bad find-and-replace or a hand edit in Excel produces.

Reproduce: `python day9_debugging.py` (writes a broken copy, loads it, prints the
analysis, deletes the copy).

## 1. Symptom

The load succeeded. 988 rows inserted, no error, no NOT NULL violation, no failed
constraint. But:

- SUM(net_sales) came out 41,038.95 instead of 41,074.95. Silently AED 36.00
  short, exactly row CB-2000's value.
- Every downstream total, KPI and chart is understated by that amount.
- Only tell: the pandas dtype of Net_Sales after read_csv was str, not float64.

## 2. Root cause

4O.0 is not a number. When pandas hits an unparseable value in a column, it does
not fail the row, it reads the whole column as text.

SQLite makes it worse. It has type affinity, not enforcement: a REAL NOT NULL
column stores the text string without complaint (it is not NULL). SUM() then
treats every non-numeric value as 0. One unreadable cell removes one row's
revenue from every aggregate, with no error.

## 3. Fix

Locate it: pd.to_numeric(df['Net_Sales'], errors='coerce') gives one NaN, order
CB-2000. Correct the source value (4O.0 to 40.0) and reload. Do not coerce to
zero or drop the row, that hides a data-entry error.

## 4. Prevention

- pd.to_numeric(col, errors='raise') on every money column before load. Fail,
  don't warn.
- Assert dtypes after read_csv: Net_Sales must be float64.
- Post-load SQL guard: SELECT COUNT(*) FROM orders WHERE typeof(net_sales) NOT IN
  ('real','integer') must be 0. Now built into day9_build_database.py; on the
  broken file it returns 1 and the build exits non-zero.
- Reconcile the loaded total against the raw-file total (day9_reconciliation.py).
- Run the validation checks in CI on every commit.
