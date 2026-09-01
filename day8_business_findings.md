# Day 8 Business Findings

Management asked what to actually worry about. Four findings from the 988-order, June to August dataset. Each ends with how the conclusion could be wrong, because a finding that cannot be challenged is not analysis

## Finding 1: Commission is 86% of all revenue leakage
Evidence: Gross 50,670. Discounts 1,321. Commission 8,274. Net 41,075. Total leakage 18.9% of gross, and commission is 86.2% of that leak
Why it matters: this is the largest controllable cost visible in the data, roughly AED 8,300 per quarter leaving through delivery platforms
Recommended action: make commission % of gross a standing monthly KPI and set a target to move it down through channel mix
What could make this wrong: commission buys volume. If aggregator orders are incremental orders we would never have received directly, cutting them cuts revenue, not just cost. The data cannot show which Talabat customers would have ordered anyway

## Finding 2: The branches that can least afford commission pay the most of it
Evidence: commission as % of gross by branch: Barsha 18.9, JVC 18.2, Muweilah 17.7, Karama 15.0, Deira 12.0. Direct order share: Deira 48.5%, Karama 34.1%, Barsha 14.2%
Why it matters: the weakest branch (Barsha) hands over the largest share of every dirham, while the newest branch (Deira) proves a high-Direct model works. Channel mix, not just sales volume, separates strong branches from weak ones
Recommended action: replicate whatever drives Deira's Direct share (pickup habits, phone orders, loyalty) at Barsha and JVC first
What could make this wrong: Deira's Direct share may come from location factors that cannot be copied, such as walk-in foot traffic or parking. Correlation between Direct share and branch health is not proof one causes the other

## Finding 3: Karama, our biggest branch, is the only one shrinking
Evidence: June to August net sales growth by branch: Deira +36.0%, Muweilah +12.4%, Barsha +1.2%, JVC +0.7%, Karama -4.5%. Company grew +5.9% overall
Why it matters: company growth is masking decline in the branch that contributes 30% of revenue. If Karama continues down while Deira's opening surge normalises, the company trend flips negative
Recommended action: investigate Karama specifically this month: local competition, staffing, menu availability, delivery ratings
What could make this wrong: three monthly points make a very short trend, June may simply have been an unusually strong month for Karama, and Deira's +36% is partly an opening ramp that inflates the company comparison. One more month of data would confirm or kill this finding

## Finding 4: Weekends carry the business disproportionately
Evidence: average daily net sales AED 591 on Fri-Sat vs AED 390 on weekdays, a 51.7% uplift, meaning 2 days generate roughly 38% of weekly revenue
Why it matters: staffing, stock and promotions are presumably flat across the week while demand is not. Weekday capacity is underused and weekend capacity may be constrained
Recommended action: shift promotions to Sunday-Thursday to fill quiet days, and verify weekend staffing is not capping sales
What could make this wrong: the uplift is built into how this synthetic dataset was generated, and in real data the pattern could differ by branch or be driven by a few large orders. Validate on real POS data and check per-branch before acting

## The one number to watch
Direct order share, company-wide, monthly. Every point of Direct share moves roughly AED 100+ per month from platform commission back into the business, and it is the single lever connecting findings 1, 2 and 3
