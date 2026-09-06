# Day 9 Task 4 - Power BI Dashboard V2

Do not rebuild. Add only what changes a decision. V1 already has Direct Share %,
Commission %, a branch bar and a month line. Measures are in day9_dax_measures.md.

## Requirement status in V1

- Direct Share %: done (card + by-branch bar).
- Branch comparison: done (Top Branch bar). Add a month breakdown to show
  Karama's decline.
- Trend indicator: partial. Line chart only, no up/down signal, axis starts at 0
  so the trend looks flat.
- Leakage %: missing. V1 shows Commission % (16.33%) not Leakage (~18.9%).
- Month-over-month growth: missing.
- Net Sales per Order: done, it is the existing Average Order Value card.

## Steps

1. Add the Calendar table (needed for MoM). Modeling > New table:
   `Calendar = CALENDARAUTO()`. Mark as date table. Relate Calendar[Date] to
   Sales[Date].

2. Add measures Leakage %, Previous Month Net Sales, MoM Growth %, and
   `Net Sales ex-Deira = CALCULATE([Total Net Sales], Sales[Branch] <> "Deira")`.

3. Card row: replace the Total Gross Sales card with Leakage %. Gross is
   derivable from net and leakage; leakage is the KPI.

4. Month line: convert to a line and clustered column chart. Columns = Total Net
   Sales. Line = MoM Growth %. Set the Y axis start to 12000 so the trend is
   visible.

5. Add a KPI visual for the trend indicator. Value = Total Net Sales, Trend axis
   = Calendar[Month], Target = Previous Month Net Sales. Goes green or red versus
   last month and follows the slicers.

6. Branch comparison: add Calendar[Month] as Small multiples on the Top Branch
   bar, or add a matrix (rows = Branch, columns = Month, values = Total Net Sales
   and MoM Growth %, conditional format the growth column).

## Own visual

Line chart: Total Net Sales vs Net Sales ex-Deira, X axis = Calendar[Month].
Put it where Best Products sits and move Best Products to a second page.

Caption: "I added this because management needs to know whether the core business
is growing or whether the +5.9% is just the new Deira branch opening. The two
lines split apart: total rises, same-branch stays roughly flat."

## Design check

Every visual answers a stated question: growing or not, where money leaks, which
channel, which branch, up or down this month. If a reviewer cannot name the
decision a visual supports, remove it.

## V1 fix regardless

The month line's 0-based Y axis hides the trend. Fix it as in step 4 even if you
change nothing else.
