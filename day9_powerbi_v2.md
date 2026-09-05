# Day 9 Task 4 - Power BI Dashboard V2

Do **not** rebuild. Open `dummy_chaat_bazaar_dashboard.pbix` and add only what
improves a decision. Everything below sits on the existing model plus one new
`Calendar` table (`CALENDARAUTO()`, marked as a date table, related to
`Sales[Date]`). All measures are in `day9_dax_measures.md`.

## What to add (5 required + 1 own)

| # | Element | Visual | Why it changes a decision |
|---|---|---|---|
| 1 | **Month-over-month growth** | Line/column combo: `Calendar[Month]` axis, `Total Net Sales` as columns, `MoM Growth %` as a line on a secondary axis | Shows the "growth" is one month (+7% Aug) sitting on a flat/down June-July, not a trend |
| 2 | **Leakage %** | Card, plus a line by month | One number for "how much of gross we lose to discount + commission"; the line shows it falling 20% -> 18% |
| 3 | **Direct Share %** | Card + line by month, and a bar by branch | The lever behind the margin gain; by branch it shows Barsha stuck at ~14% while others climb |
| 4 | **Branch comparison** | Matrix: rows = `Branch`, columns = `Calendar[Month]`, values = `Total Net Sales` and `MoM Growth %`, with conditional-format data bars / colour | Puts Karama's decline and Deira's ramp side by side in one view |
| 5 | **Trend indicator** | KPI visual: Indicator = `Total Net Sales`, Trend axis = `Calendar[Month]`, Target = `Previous Month Net Sales` | Red/green at a glance: is this month above or below last month, per whatever branch/channel is sliced |

Keep the V1 visuals that already earn their place (net sales by branch, top
products, channel cost table). Delete any V1 visual that does not answer a
question - the design rule.

## My own visual

**Same-branch net sales vs total net sales, by month.** A line chart with two
lines on `Calendar[Month]`: `Total Net Sales`, and a `Net Sales ex-Deira` measure
(`CALCULATE([Total Net Sales], Sales[Branch] <> "Deira")`).

> I added this because management needs to know **whether the core business is
> actually growing, or whether the whole +5.9% is just the new Deira branch
> opening.** The two lines diverge: total rises, same-branch is nearly flat.

## Design check

Every visual here answers a stated question (growing or not, where the money
leaks, which channel, which branch, up or down this month). If a reviewer cannot
say what decision a visual supports, it comes off the page.
