# Day 9 Task 7 - CEO Decision

CEO wants to drop Talabat next month to cut commission.

## Answer: NOT ENOUGH DATA

## What the data says
- Talabat is ~37% of orders and the most expensive channel (25% commission).
- Direct share already rose 21% to 31% of orders in three months, so some customers will switch channel on their own.

## What the data does not say
- Whether Talabat orders are incremental or would come back as Direct.
- First-time vs repeat customers. There are no customer IDs.
- True profit. No food or labour cost in the data.

## Biggest risk: we lose customers, not just a channel
Talabat is a discovery channel. A large share of aggregator orders come from people browsing the app for food who then find Chaat Bazaar. Remove the storefront and:
- Customers who specifically want Chaat Bazaar open another app and order anyway. We keep them.
- Customers who just want chaat pick a different chaat place still on Talabat. We lose them and they do not migrate to us.
- First-time discovery traffic stops entirely.

Moving to a cheaper platform may recover the loyal customers. It does nothing for the browsers who never search us by name. Nothing in the data says the better commission terms make up for that loss. Short term it probably does not.

## Experiment first
Turn Talabat off at one branch for 6-8 weeks. Keep a matched branch live as control. Push Direct at the test branch.

## Success KPI
Test-branch net sales stays within 5% of baseline while leakage % falls.
