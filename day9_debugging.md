# Day 9 Task 8 - Debugging Test

**What I broke:** changed one numeric value in the source CSV to text. Row
`CB-2000`'s `Net_Sales` went from `40.0` to `4O.0` - a capital letter O where a
zero should be. This is what a careless find-and-replace, or a hand edit in
Excel, actually produces.

Reproduce it: `python day9_debugging.py` (writes a broken copy, loads it, prints
the analysis below, deletes the copy).

---

## 1. Symptom

The load **succeeded**. 988 rows inserted, no error, no `NOT NULL` violation, no
failed constraint. But:

- `SUM(net_sales)` came out **41,038.95** instead of **41,074.95** - silently
  **AED 36.00 short**, exactly row `CB-2000`'s value.
- Every downstream total, KPI card and chart is understated by that amount, and
  nothing flags it.
- The only visible tell: the pandas dtype of `Net_Sales` after `read_csv` was
  `str`, not `float64`.

## 2. Root cause

`4O.0` is not a number. When pandas hits an unparseable value in a column, it
does not fail the row - it falls back to reading the **entire column** as text.

Then SQLite makes it worse. SQLite has **type affinity, not type enforcement**:
a `REAL NOT NULL` column will store the text string `"4O.0"` without complaint
(it is not NULL, so the constraint passes). `SUM()` then treats every
non-numeric value as **0**. So one unreadable cell removes one row's revenue
from every aggregate, with no error anywhere in the chain.

## 3. Fix

- Locate the bad cell: `pd.to_numeric(df['Net_Sales'], errors='coerce')` -> the
  one `NaN` is order `CB-2000`.
- Correct the **source** value (`4O.0` -> `40.0`) and reload.
- Do **not** paper over it by coercing to zero or dropping the row - that hides
  a data-entry mistake that could be one of many.

## 4. How I would prevent it in production

| Guard | What it does |
|---|---|
| `pd.to_numeric(col, errors='raise')` on every money column before load | Fails the pipeline loudly instead of letting text through |
| Assert dtypes after `read_csv` (`df['Net_Sales'].dtype == 'float64'`) | Catches the silent column-wide fallback at the door |
| Post-load SQL guard: `SELECT COUNT(*) FROM orders WHERE typeof(net_sales) NOT IN ('real','integer')` must be 0 | Catches text that SQLite's affinity let in - now built into `day9_build_database.py` |
| Reconcile loaded total vs raw-file total | `day9_reconciliation.py` would show the AED 36 gap |
| Run the validation checks in CI on every commit | No broken data reaches Power BI |

The guard was added to `day9_build_database.py` this session - on the broken file
the "numeric columns are numeric" check returns 1 and the build exits non-zero.
