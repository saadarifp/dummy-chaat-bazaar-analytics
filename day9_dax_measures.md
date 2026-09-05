# Day 9 Task 5 - DAX Challenge

Table with the order rows is assumed named **`Sales`**. Time-intelligence
measures (2 and 3) need a dedicated date table: add one with
`Calendar = CALENDARAUTO()`, mark it as a date table (Table tools > Mark as date
table), and relate `Calendar[Date]` to `Sales[Date]`.

Three base measures the five below build on:

```
Total Net Sales   = SUM(Sales[Net_Sales])
Total Gross Sales = SUM(Sales[Gross_Sales])
Total Orders      = DISTINCTCOUNT(Sales[Order_ID])
```

---

## 1. Leakage %

```
Leakage % =
DIVIDE(
    [Total Gross Sales] - [Total Net Sales],
    [Total Gross Sales]
)
```

**Plain English:** Of every dirham a customer spends, how much never reaches us -
lost to discounts and to platform commission combined. Gross is what was rung up,
net is what we keep; this is the gap between them as a percentage. In this
dataset it runs about 18-20%.

---

## 2. Previous Month Net Sales

```
Previous Month Net Sales =
CALCULATE(
    [Total Net Sales],
    DATEADD('Calendar'[Date], -1, MONTH)
)
```

**Plain English:** The same net-sales figure, but for the month before whichever
month you are looking at. If a visual is showing August, this returns July. It is
only useful as the thing this month gets compared against.

---

## 3. Month-over-Month Growth %

```
MoM Growth % =
DIVIDE(
    [Total Net Sales] - [Previous Month Net Sales],
    [Previous Month Net Sales]
)
```

**Plain English:** Did we grow or shrink versus last month, and by how much.
Positive means this month beat the previous one; negative means it fell. For this
data it is roughly -1% June to July, then +7% July to August - which is why the
"sales are up" story really rests on one month.

---

## 4. Direct Share %

```
Direct Share % =
DIVIDE(
    CALCULATE([Total Net Sales], KEEPFILTERS(Sales[Aggregator] = "Direct")),
    [Total Net Sales]
)
```

**Plain English:** What portion of our sales comes from customers ordering us
directly, rather than through Talabat, Careem or Noon. Direct orders pay no
commission, so this is the number that moves when the cost problem is being
fixed. It rose from about 27% to 36% of net sales across the three months.
(Swap `[Total Net Sales]` for `[Total Orders]` on both lines to measure it by
order count instead of by value.)

---

## 5. Net Sales per Order

```
Net Sales per Order =
DIVIDE([Total Net Sales], [Total Orders])
```

**Plain English:** The average value we keep from a single order. It tells you
whether more orders actually means more money: if order count goes up but this
goes down, the branch is just getting more small orders. Karama shows exactly
that in August - order count hit a record while this dropped from AED 48 to
AED 40.

---

### Why these are measures, not calculated columns

Each one is a ratio of two sums. If you computed "Leakage %" per row and then
averaged the rows, a AED 5 order and a AED 200 order would count equally and the
answer would be wrong. A measure divides the totals *after* the filter context
(branch, month, channel) is applied, so it stays correct at every level of every
visual.
