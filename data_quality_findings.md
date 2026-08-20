# Data Quality Findings

Method: 11 SQL checks in day4_data_validation.sql. Each check returns rows only when it fails. Result: 10 of 11 pass on the current data. One real issue was found and fixed (Finding 1).

## Finding 1. Wrong column types after CSV import (FOUND, FIXED)
Problem: importing the CSV without creating the table first stored every column as TEXT. Numeric comparisons then ran as string comparisons. MAX(Net_Sales) returned 99.0 instead of 126.0 and the CASE WHEN classification labelled AED 9.00 as High Value and AED 126.00 as Low Value.
Why it matters: every query runs without error and returns confident, wrong numbers. Management would receive false rankings and false classifications with no visible warning.
Fix: rebuild_db.sql now creates all tables with proper types before importing. Check V11 permanently tests that Net_Sales is stored as numeric.

## Finding 2. Duplicate rows from repeated imports (FOUND EARLIER, PREVENTED)
Problem: running .import twice appended the same 35 rows again. Total net sales doubled to 2773.50.
Why it matters: silently inflated totals. This is one of the most common real world data bugs.
Fix: rebuild_db.sql drops and recreates tables so imports never append. Checks V1 and V10 detect duplicate Order_IDs and duplicate full rows.

## Checks that pass (no issues in current data)
Duplicate Order_ID: none. Missing Order_ID: none. Missing Branch: none. Negative Gross Sales: none. Negative Net Sales: none. Net Sales above Gross Sales: none. Commission above Gross Sales: none. Invalid branch references: none. Impossible quantities: none. Duplicate full records: none.
Why these matter anyway: this is dummy data generated with the rules enforced, so passing is expected. On real POS or aggregator exports these are exactly the checks that fail. Keeping them in the repo means every future dataset gets the same audit before anyone sees a number from it.

## Conclusion
The dataset can be trusted for analysis. Trust was earned by checking, not assumed.
