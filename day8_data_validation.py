"""Day 8 data validation. Run BEFORE loading restaurant_sales_750.csv into Power BI.
Every check prints PASS or FAIL with a count. A dashboard on bad data is a beautiful mistake."""
import pandas as pd

VALID_BRANCHES = {'Karama','Muweilah','JVC','Barsha','Deira'}
VALID_AGGREGATORS = {'Talabat','Careem','Noon','Direct'}

df = pd.read_csv('restaurant_sales_750.csv')
results = {}

results['total_rows'] = (len(df), len(df) >= 750)
results['duplicate_order_ids'] = ((d := df['Order_ID'].duplicated().sum()), d == 0)
results['missing_values'] = ((m := int(df.isna().sum().sum())), m == 0)
neg = int(((df[['Quantity','Gross_Sales','Discount','Commission','Net_Sales']] < 0).sum()).sum())
results['negative_values'] = (neg, neg == 0)
ng = int((df['Net_Sales'] > df['Gross_Sales']).sum())
results['net_greater_than_gross'] = (ng, ng == 0)
iq = int(((df['Quantity'] <= 0) | (df['Quantity'] > 20)).sum())
results['invalid_quantities'] = (iq, iq == 0)
ub = int((~df['Branch'].isin(VALID_BRANCHES)).sum())
results['unknown_branches'] = (ub, ub == 0)
ua = int((~df['Aggregator'].isin(VALID_AGGREGATORS)).sum())
results['unknown_aggregators'] = (ua, ua == 0)
gap = (df['Gross_Sales'] - df['Discount'] - df['Commission'] - df['Net_Sales']).abs()
ri = int((gap > 0.01).sum())
results['identity_gross_minus_disc_minus_comm_equals_net'] = (ri, ri == 0)
results['dates_parse_and_span_3_months'] = (
    (months := pd.to_datetime(df['Date']).dt.to_period('M').nunique()), months >= 3)

print(f"{'CHECK':52s} {'VALUE':>8s}  RESULT")
all_pass = True
for name, (value, ok) in results.items():
    print(f"{name:52s} {value:8d}  {'PASS' if ok else 'FAIL'}")
    all_pass &= ok
print('\nDATASET ' + ('READY FOR POWER BI' if all_pass else 'NOT READY: fix failures first'))
