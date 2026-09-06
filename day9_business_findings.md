# Day 9 Business Findings - "Sales increased, but is the improvement healthy?"

Data: 988 orders, one line per order, June to August 2026, five branches, four
channels. Figures from chaat_bazaar_day9.db via day9_sql_investigation.sql.

Headline: net sales 13,473 (Jun), 13,340 (Jul), 14,262 (Aug). Jun to Aug +5.9%.

Verdict: the quality of the growth is good. The size of it is mostly one new
branch, the biggest branch is shrinking, and it rests on one month. Findings 3
and 4 challenge the "we are growing" reading.

## Finding 1 - Growth was earned cheaper, not discounted

Evidence. Commission as % of gross: 17.43, 15.68, 15.87. Discount as % of gross:
2.89, 2.54, 2.39. Orders discounted: 31.5%, 29.2%, 27.8%. Net margin: 79.7%,
81.8%, 81.7%. Total leakage fell from 20.3% to 18.3% of gross.

Interpretation. Bought growth shows rising discounts and falling margin. This
shows the opposite. The extra revenue came at a better cost ratio than June's.

Alternative. The blend can improve with no branch improving, just from adding
Deira (a high-Direct new branch) to the average.

Next step. Rerun this per branch. If the established four also improved, it is
real. If only the company blend moved, it is a mix artefact.

## Finding 2 - Mechanism: customers moved to Direct

Evidence. Direct share of orders: 21.1%, 32.1%, 31.2%. Direct share of net:
27.4%, 36.3%, 36.1%. Direct share Jun vs Aug by branch: Deira 34.8 to 45.2,
Karama 26.0 to 38.5, Muweilah 17.3 to 29.5, JVC 11.7 to 21.7, Barsha 16.0 to
13.5.

Interpretation. Direct pays zero commission, so this shift explains most of the
margin gain. It is structural, not promotional, so it does not reverse when a
campaign ends.

Alternative. A jump this fast can be a tagging change (staff logging phone and
walk-in orders as Direct) rather than real migration. Revenue would be unchanged.

Next step. Reconcile Direct order counts against POS tickets and aggregator
invoices for the same weeks.

## Finding 3 - CHALLENGE: strip out the new branch and growth nearly disappears

Evidence. Net excluding Deira: 11,786, 10,897, 11,968. That is +1.5% Jun to Aug,
and the established branches were down 7.5% in July before recovering. Company
total: +5.9%.

Interpretation. "Sales increased" mostly means "we opened a branch". Same-branch
growth is roughly flat. The core business is holding, not accelerating.

Alternative. Deira is permanent and its revenue recurs, so excluding it
understates the run-rate. Two months is also a short window.

Next step. Report total growth and same-branch growth separately, like retail
comps. Judge the core on the second one. Add September.

## Finding 4 - CHALLENGE: the biggest branch is shrinking and trading ticket size for order count

Evidence. Branch growth Jun to Aug: Karama -4.5%, JVC +0.7%, Barsha +1.2%,
Muweilah +12.4%, Deira +36.0%. Karama is ~31% of company revenue, the only large
branch, and the only one falling. Karama by month - orders: 96, 76, 104. AOV:
45.85, 48.14, 40.40. Items per order: 3.72, 3.78, 3.45. Mains net: 1,585, 1,570,
1,271.

Interpretation. August looks like a recovery on order count but it is
lower-quality volume: smaller baskets, lower value, less Mains. If Deira's
opening surge normalises while Karama drifts down, the company trend turns
negative.

Alternative. July's 76 orders may be the anomaly, making August a return to
normal. AOV on ~100 orders a month is noisy.

Next step. Pull Karama daily data and delivery ratings for August. Check for a
competitor promo, a menu change, or a price change.

## Finding 5 - "Growth" is one month, and the tailwind is fading

Evidence. Month-over-month net: -1.0% Jun to Jul, +6.9% Jul to Aug. Two of three
points are flat to down. Deira itself fell 2,443 to 2,294 Jul to Aug and its
Direct share dropped 63.6% to 45.2% as the opening promo wore off.

Interpretation. One good month is not a trend, and the branch carrying it is past
its peak. Base case for September is flat.

Alternative. August can genuinely be a stronger month (weather, schools). A soft
July mid-summer is common.

Next step. Get 2025 monthly figures for a year-over-year view. Do not annualise
off this window.

## Finding 6 - Revenue is concentrated on two days a week

Evidence. Average daily net: 591 on Fri/Sat (26 days) vs 390 on weekdays (66
days). A 52% uplift. Two days carry ~38% of weekly revenue.

Interpretation. Weekday capacity is underused. One disrupted weekend hits the
week hard.

Alternative. Weekend skew may be built into how this synthetic dataset was
generated.

Next step. Confirm on real POS, per branch. If it holds, move promotions to
Sunday to Thursday and check weekend staffing is not capping sales.

## One number to watch

Same-branch (ex-Deira) net sales, month over month. Total sales look healthy
while Deira ramps. The core's health is the like-for-like number, and it is flat
with the biggest branch declining.

## What this data cannot tell us

No costs. Net sales here is revenue after discount and commission, not profit. A
branch growing net sales could still be losing money. Three months with a new
branch inside the window is too short to call a trend. Rerun on real POS data
with more history.
