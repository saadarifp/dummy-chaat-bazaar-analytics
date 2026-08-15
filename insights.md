# Chaat Bazaar Sales Analysis

*Based on the July 2026 dummy dataset (35 orders). Structure and method are what matter here; numbers will be replaced with real data later.*

## Insight 1 — Two branches carry the business
Karama (AED 617) and Muweilah (AED 463) together generate 78% of total net sales, and both sit above the average branch performance. Barsha is the clear laggard at AED 93 net — a quarter of what JVC produces on fewer orders — and its average ticket (AED 18.66) is nearly a third of Karama's (AED 51.45), meaning the gap is order *value*, not just order volume.

## Insight 2 — Talabat is the most expensive sales channel
Talabat took AED 188.90 in commission on AED 788 gross — an effective rate of 24%, versus ~20% for Careem and Noon and 0% for Direct. Talabat is also the highest-volume channel (11 of 35 orders), so it costs the most in both rate and absolute dirhams. Every order shifted from Talabat to Direct keeps roughly one dirham in four that currently goes to commission.

## Insight 3 — Revenue is concentrated in high-ticket Mains, while Chaat sells often but earns little
Mains generate AED 719 net (52% of the total), led by Paneer Tikka alone at AED 386 — the top item by both revenue *and* quantity. Meanwhile, the classic chaat items (Pani Puri, Bhel Puri, Dahi Puri, Sev Puri) occupy four of the bottom five revenue slots despite being the brand's namesake. Low-value orders (under AED 30) are also the largest order segment (16 of 35), suggesting many small chaat-only baskets.

## Recommendation
Focus on lifting basket size at the weak points rather than cutting anything yet: bundle low-ticket chaat items with high-margin Mains or beverages (e.g. a Pani Puri + Paneer Tikka combo), push Direct ordering to reduce the 24% Talabat commission drag, and investigate Barsha specifically — its problem is small tickets, so test whether combos or minimum-order delivery incentives move its average up before considering bigger changes. Re-run this exact analysis on real data before acting; with 35 dummy rows these are patterns to test, not conclusions.
