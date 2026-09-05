# Day 9 Business Findings - "Sales increased, but is the improvement healthy?"

Dataset: 988 orders, one line per order, June to August 2026, five branches,
four channels (Talabat, Careem, Noon, Direct). All figures from
`chaat_bazaar_day9.db` via `day9_sql_investigation.sql`.

**The headline management is reacting to:** company net sales went
13,473 (Jun) -> 13,340 (Jul) -> 14,262 (Aug), so **+5.9% June to August**.

**Short answer:** the *quality* of the growth is good - it was earned at a lower
cost, not bought with discounts. But the *size* of it is largely one new branch
opening, the biggest branch is going backwards, and it rests on a single month.
Findings 3 and 4 challenge the "we are growing" reading.

---

## Finding 1 - The growth was earned more cheaply, not discounted into existence

**Evidence.** As net sales rose, the cost of earning them fell every month:

| Month | Commission % of gross | Discount % of gross | % of orders discounted | Net margin |
|---|---|---|---|---|
| Jun | 17.43 | 2.89 | 31.5 | 79.68 |
| Jul | 15.68 | 2.54 | 29.2 | 81.78 |
| Aug | 15.87 | 2.39 | 27.8 | 81.74 |

Total leakage (discount + commission) fell from 20.3% of gross to 18.3%.

**Business interpretation.** This is the healthy signature. A business buying
growth shows *rising* discount depth and a *falling* margin. This one shows the
opposite: fewer orders discounted, smaller average discount (AED 4.75 -> 4.22),
and two margin points gained. The extra AED 790 of August net came with a better
cost ratio than June's revenue had.

**Alternative explanation.** The blended margin can improve without any branch
improving, purely from mix: Deira opened as a very high-Direct branch, so adding
its orders lifts the company average while every established branch stays flat.
Finding 2 partly rules this out, but it is the thing to check.

**Recommended next step.** Rerun this table *per branch*. If the established four
also show falling commission %, the improvement is real behaviour change. If only
the company blend moved, it is an accounting artefact of the new opening.

---

## Finding 2 - The mechanism behind Finding 1: customers moved to Direct

**Evidence.** Direct's share of orders went 21.1% -> 32.1% -> 31.2%; its share of
net sales went 27.4% -> 36.1%. Four of five branches drove Direct share up
between June and August:

| Branch | Direct share Jun | Direct share Aug |
|---|---|---|
| Deira | 34.8 | 45.2 |
| Karama | 26.0 | 38.5 |
| Muweilah | 17.3 | 29.5 |
| JVC | 11.7 | 21.7 |
| Barsha | 16.0 | 13.5 |

**Business interpretation.** Direct orders pay zero commission, so this single
shift explains most of the margin gain in Finding 1. It is the healthiest kind of
improvement because it is structural, not promotional - it does not reverse when
a campaign ends.

**Alternative explanation.** A channel-share jump this large in two months can
also be a *tagging* change - staff logging phone or walk-in orders as "Direct"
that were previously recorded under an aggregator - rather than real customer
migration. The revenue would be unchanged; only the channel label moved.

**Recommended next step.** Reconcile Direct order counts against actual POS
tickets and against the aggregators' own invoices for the same weeks. If Direct
counts match real receipts, the migration is genuine.

---

## Finding 3 - CHALLENGE: strip out the new branch and the growth nearly disappears

**Evidence.**

| Month | Company net | Net excluding Deira | Deira net |
|---|---|---|---|
| Jun | 13,473 | 11,786 | 1,687 |
| Jul | 13,340 | 10,897 | 2,443 |
| Aug | 14,262 | 11,968 | 2,294 |

Company June -> August: **+5.9%**. Excluding Deira: 11,786 -> 11,968 = **+1.5%**
over two months, and the four established branches were *down* 7.5% in July before
recovering.

**Business interpretation.** "Sales increased" is true but mostly means "we opened
a branch". Same-branch (like-for-like) growth is roughly flat. That is a very
different message for planning: the core business is holding, not accelerating,
and a second new opening - not organic demand - would be what moves the total
again.

**Alternative explanation.** Deira is a permanent part of the company now; its
revenue recurs every month, so excluding it understates the true run-rate. Also,
two months is a short window and the established branches' July dip may be
seasonal noise rather than weakness.

**Recommended next step.** Report two numbers from now on, the way retail does:
total growth and same-branch growth. Judge the health of the core on the second
one. Add September before drawing a trend.

---

## Finding 4 - CHALLENGE: the biggest branch is shrinking and trading ticket size for order count

**Evidence.** Branch growth June -> August: Karama **-4.5%**, JVC +0.7%,
Barsha +1.2%, Muweilah +12.4%, Deira +36.0%. Karama is about 31% of company
revenue - the only large branch, and the only one falling. Inside Karama:

| Month | Orders | Net | AOV | Items/order | Mains net |
|---|---|---|---|---|---|
| Jun | 96 | 4,402 | 45.85 | 3.72 | 1,585 |
| Jul | 76 | 3,658 | 48.14 | 3.78 | 1,570 |
| Aug | 104 | 4,202 | 40.40 | 3.45 | 1,271 |

**Business interpretation.** August looks like a recovery on order count (104, a
record) but it is lower-quality volume: value per order dropped 16%, baskets got
smaller, and the high-ticket Mains category fell from AED 1,570 to AED 1,271.
Karama is being kept busy with more, cheaper orders. If Deira's opening surge
normalises while Karama keeps drifting down, the company trend turns negative.

**Alternative explanation.** July's 76 orders may be the anomaly (a genuinely
weak month), making August a return to normal rather than a decline; AOV on
~100 orders/month is noisy and one quiet week of Mains can move it. The -4.5%
could be June being unusually strong.

**Recommended next step.** Pull Karama's *daily* data and its delivery-platform
rating for August. Check whether a nearby competitor ran a promotion, whether a
Mains item went off the menu, or whether a price change landed. This is the
branch to investigate by hand this month.

---

## Finding 5 - "Growth" is really one month, and the tailwind is already fading

**Evidence.** Month-over-month net: June -> July **-1.0%**, July -> August
**+6.9%**. Two of the three data points are flat-to-down; the entire positive
story is August. Meanwhile Deira, the branch carrying the growth, already turned
down: net 2,443 -> 2,294 July to August (-6%), and its Direct share fell from
63.6% to 45.2% as the opening promotion wore off.

**Business interpretation.** One good month is not a trend. The narrative
"sales are improving" is being built on a single month's rise, at the same time
the one branch responsible for it is past its peak. The base case for September
is flat, not continued growth.

**Alternative explanation.** August genuinely can be a stronger month (weather
driving delivery, schools returning, more dine-in), and a single soft month in
mid-summer (July) is common in food service. The pattern may repeat favourably.

**Recommended next step.** Get 2025 monthly figures for a year-over-year view -
that separates real growth from seasonality far better than three consecutive
months can. Do not annualise off this window.

---

## Finding 6 - Supporting: revenue is concentrated on two days a week

**Evidence.** Average daily net sales: AED 591 on Friday/Saturday (26 days) vs
AED 390 on weekdays (66 days) - a **52% uplift**. Roughly 38% of weekly revenue
comes from two days.

**Business interpretation.** Not about the health of the growth directly, but it
tells you where any growth has to come from and where the risk sits. Weekday
capacity is underused; a single disrupted weekend (staffing, an outage, weather)
hits the week hard.

**Alternative explanation.** Weekend skew can be baked into how this synthetic
dataset was generated, and in real data it may vary by branch or be driven by a
handful of large orders rather than broad demand.

**Recommended next step.** Confirm on real POS data and per branch. If it holds,
move promotions to Sunday-Thursday to fill quiet days and check weekend staffing
is not capping sales.

---

## The one number to watch

**Same-branch (ex-Deira) net sales, month over month.** Total company sales will
look healthy for as long as Deira ramps; the core business's health is the
like-for-like number, and right now it is flat with the biggest branch declining.

## What this data cannot tell us

No costs - ingredients, rent, wages, packaging - so "net sales" is revenue after
discount and commission, not profit. A branch growing net sales could still be
losing money. And three months with a brand-new branch inside the window is too
short and too disrupted to call a trend with confidence; the method here is what
matters, the conclusions must be rerun on real POS data with more history.
