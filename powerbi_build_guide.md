# Dashboard Build Guide (one page, 30-second test)

1. Get data > Text/CSV > restaurant_sales_750.csv > Transform Data. In Power Query confirm types: Date as Date, Quantity whole number, the four money columns decimal. Close & Apply
2. Modeling > New measure: enter the 5 measures plus Direct Share % from day8_dax_measures.md
3. Top row: five Card visuals: Total Net Sales, Total Gross Sales, Total Commission (SUM of Commission), Total Orders, Average Order Value
4. Left middle: bar chart, Branch on axis, Total Net Sales on values, sorted descending. Answers best branch at a glance
5. Right middle: line chart, Date on axis (month level), Total Net Sales on values. Add Branch to legend only if it stays readable. Answers improving or declining
6. Left bottom: bar chart, Product on axis, Total Net Sales, filter to Top 5 by Total Net Sales (visual-level filter, Top N). Answers what drives revenue
7. Right bottom: clustered column, Aggregator on axis, values Total Net Sales and Commission % (or a table with Aggregator, Net, Commission, Commission %). Answers which channel costs most
8. Slicers along the left edge: Branch, Month (from Date), Aggregator
9. Formatting: one background, consistent currency format, titles as plain questions (Which branch leads?), no more than these 9 visuals
Save as chaat_bazaar_dashboard.pbix, keep local
