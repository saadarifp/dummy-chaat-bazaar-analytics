# Day 6 CEO Analysis

Brief: sales look okay, CEO suspects money is being lost somewhere. Findings below, each with evidence, query, interpretation, recommendation, confidence

## Finding 1: 23.9% of gross revenue leaks before it becomes net
Evidence: Gross 1822.00, Discounts 112.40, Commission 322.85, Net 1386.75. Leakage 435.25, which is 23.89% of gross
Query: SELECT SUM(Gross_Sales), SUM(Discount), SUM(Commission), SUM(Net_Sales), (SUM(Discount)+SUM(Commission))*100.0/SUM(Gross_Sales) FROM orders
Interpretation: for every AED 100 sold, AED 24 never reaches the business, and commission is 74% of that leak
Recommendation: treat commission as the single biggest controllable cost line, target channel mix before menu or pricing changes
Confidence: HIGH. Pure arithmetic on the dataset itself, verified against the accounting identity check that already passes

## Finding 2: commission concentrates in Talabat
Evidence: Talabat 188.90 of 322.85 total commission, 59%, at the highest contracted rate 25%
Query: JOIN orders to aggregators, GROUP BY aggregator, SUM commission alongside Commission_Rate
Interpretation: the largest channel is also the most expensive one, so growth on current mix grows the leak proportionally
Recommendation: push Direct ordering to Talabat heavy customers, measure shift monthly
Confidence: HIGH. Rates verified against the contract table by validation check V6, totals reconcile to the company total

## Finding 3: ten orders take a double hit of discount plus commission
Evidence: 10 delivery orders carry both a discount and a commission, together giving up 82.50 discount and 156.63 commission, so 239.13 leaks from those orders alone, 55% of all leakage
Query: SELECT aggregator, COUNT(*), SUM(Discount), SUM(Commission) FROM orders JOIN aggregators WHERE Discount>0 AND Commission>0 GROUP BY aggregator
Interpretation: discounting an order that already pays 20 to 25% commission stacks two costs on the same sale, Careem orders do this most
Recommendation: review whether aggregator promotions are set by us or by the platform, restrict own discounts to Direct orders where no commission applies
Confidence: MEDIUM. The pattern is real in the data, but with 10 orders the concentration could shift a lot with more data, and the data cannot show who funded each discount

## Finding 4: Barsha sells the wrong mix, not just less
Evidence: Barsha has zero Mains orders, only Chaat and Beverages, average order 18.66 vs company 39.62, its best item ranks are low ticket products
Query: window functions ranking products per branch, plus category totals filtered to Barsha
Interpretation: the branch underperforms because nothing high ticket sells there, which is a mix problem before it is a demand problem
Recommendation: investigate whether Mains are stocked, promoted and visible at Barsha, then test combos
Confidence: MEDIUM. The mix gap is clearly present, but 5 orders is far too few to prove customer preference, absence in 5 orders can be chance

## Finding 5: where the business actually loses money
Evidence: the available data is insufficient
Query: none possible
Interpretation: the dataset contains no costs, no rent, wages, ingredients or packaging, so no query can locate losses, only revenue leakage. The CEO's question as asked cannot be answered from this data
Recommendation: add cost columns per order or per branch per month before the next analysis cycle, until then every profitability claim is a guess
Confidence: HIGH confidence in the statement itself, this is a data gap, not an analytical result

## What deserves management attention, in order
Commission structure and channel mix first, discount policy on aggregator orders second, Barsha product mix third, and a data collection fix for costs above all of it
