# Day 8 DAX Measures

The five asked for, written to type into Power BI (Modeling > New measure), table assumed named Sales

Total Net Sales = SUM(Sales[Net_Sales])
Total Gross Sales = SUM(Sales[Gross_Sales])
Total Orders = DISTINCTCOUNT(Sales[Order_ID])
Average Order Value = DIVIDE([Total Net Sales], [Total Orders])
Commission % = DIVIDE(SUM(Sales[Commission]), [Total Gross Sales])

Understanding, in one line each: SUM adds the column over whatever filter context the visual applies. DISTINCTCOUNT counts unique orders so a future line-item dataset would not overcount. DIVIDE handles divide-by-zero safely, unlike the slash operator. Measures recalculate per slicer selection, which is the whole point

## The measure management did not ask for

Direct Share % = DIVIDE(CALCULATE([Total Orders], Sales[Aggregator] = "Direct"), [Total Orders])

Why: commission is our biggest leak and Direct orders pay none. This one number tracks the fix, not the problem. Branches above 30% Direct pay 12 to 15% of gross in commission, branches below 20% pay 18 to 19%. If management moves one metric each month, this is the one

## Measure vs calculated column, for the live check
A calculated column computes once per row at refresh and is stored in the table, a measure computes at query time over the current filter context and stores nothing. Row-level facts belong in columns, aggregations belong in measures. Commission % as a column would be wrong: averaging row-level percentages ignores order size, the measure divides the sums instead
