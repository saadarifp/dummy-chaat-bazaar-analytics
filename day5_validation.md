# Day 5 Validation

Checked before submitting. All queries run on chaat_bazaar.db rebuilt from rebuild_db.sql.

1. Total branch sales = company sales. Branch totals 617.40 + 463.45 + 212.62 + 93.28 = 1386.75. Company total from orders = 1386.75. PASS.
2. Aggregator sales = company sales. 566.70 + 342.11 + 328.10 + 149.84 = 1386.75. PASS.
3. Order count = 35. COUNT(*) returns 35, matches the 35 data rows in the CSV. PASS.
4. Percent contributions total 100. 44.52 + 33.42 + 15.33 + 6.73 = 100.00. PASS.
5. Ranking makes logical sense. Rank order Karama, Muweilah, JVC, Barsha matches the sorted totals, and the top ranked branch also holds the highest average order value, consistent with earlier days. PASS.
6. No NULL or duplicate problem affecting results. Reran day4_data_validation.sql: duplicate Order_ID none, missing values none, duplicate full rows none, Net_Sales stored as real. PASS.

Additional check: top 50 percent revenue query. The three returned products sum to 704.29, which is 50.79 percent of 1386.75. The two products before the cutoff sum to 40.94 percent, below half, so the third product is correctly the one that crosses the 50 percent line. PASS.
