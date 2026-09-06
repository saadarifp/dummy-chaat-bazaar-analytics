# Day 9 Task 5 - DAX Challenge

Order table assumed named Sales. Measures 2 and 3 need a date table: add
`Calendar = CALENDARAUTO()`, mark it as a date table, relate Calendar[Date] to
Sales[Date].

Base measures the five build on:

```
Total Net Sales   = SUM(Sales[Net_Sales])
Total Gross Sales = SUM(Sales[Gross_Sales])
Total Orders      = DISTINCTCOUNT(Sales[Order_ID])
```

## 1. Leakage %

```
Leakage % = DIVIDE([Total Gross Sales] - [Total Net Sales], [Total Gross Sales])
```

Of every dirham spent, how much never reaches us, lost to discounts and platform
commission combined. Runs about 18 to 20% here.

## 2. Previous Month Net Sales

```
Previous Month Net Sales =
CALCULATE([Total Net Sales], DATEADD('Calendar'[Date], -1, MONTH))
```

The same net sales figure for the month before the one on screen. Showing August
returns July. Only useful as the thing this month is compared against.

## 3. Month-over-Month Growth %

```
MoM Growth % =
DIVIDE([Total Net Sales] - [Previous Month Net Sales], [Previous Month Net Sales])
```

Did we grow or shrink versus last month, and by how much. About -1% Jun to Jul,
then +7% Jul to Aug, which is why the growth story rests on one month.

## 4. Direct Share %

```
Direct Share % =
DIVIDE(
    CALCULATE([Total Net Sales], KEEPFILTERS(Sales[Aggregator] = "Direct")),
    [Total Net Sales]
)
```

What portion of sales comes from customers ordering us directly, not through
Talabat, Careem or Noon. Direct pays no commission, so this moves when the cost
problem is being fixed. Rose from ~27% to ~36% of net. Swap Total Net Sales for
Total Orders on both lines to measure it by order count instead.

## 5. Net Sales per Order

```
Net Sales per Order = DIVIDE([Total Net Sales], [Total Orders])
```

Average value kept from one order. Tells you whether more orders means more
money. Karama's August: order count hit a record while this dropped from 48 to
40.

## Why measures, not calculated columns

Each is a ratio of two sums. Computing it per row and averaging would weight a
5 dirham order the same as a 200 dirham order and give the wrong answer. A
measure divides the totals after the filter context is applied, so it stays
correct at every level of every visual.
