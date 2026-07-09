# BR #4 - Monthly Sales Trend Analysis

## Business Requirement

The Sales Director wants to analyze monthly sales performance for the year 2025 to identify sales trends, monitor business growth, and compare monthly performance.

The report should provide one row for each month and include key performance indicators that help management understand how sales are progressing throughout the year.

---

## Business Objective

- Analyze monthly sales performance.
- Identify the highest and lowest performing months.
- Track cumulative sales throughout the year.
- Measure month-over-month (MoM) sales growth.
- Rank months based on sales performance.

---

## Grain

**One row represents one month in the year 2025 with aggregated sales metrics and analytical calculations.**

---

## Tables Required

### FactSales

| Column      | Purpose                |
| ----------- | ---------------------- |
| DateKey     | Join with DimDate      |
| OrderNumber | Calculate Total Orders |
| SalesAmount | Calculate Gross Sales  |
| SalesStatus | Filter completed sales |

### DimDate

| Column       | Purpose                 |
| ------------ | ----------------------- |
| DateKey      | Join Key                |
| CalendarYear | Filter Year 2025        |
| MonthNumber  | Chronological ordering  |
| MonthName    | Display month in report |

---

## Table Relationships

```
FactSales
    |
    | DateKey
    |
DimDate
```

---

## KPIs

- Gross Sales
- Total Orders
- Running Sales
- Previous Month Sales
- Month-over-Month Growth %
- Monthly Sales Rank

---

## SQL Concepts Used

- Common Table Expressions (CTEs)
- GROUP BY
- SUM()
- COUNT(DISTINCT)
- Window Functions
- SUM() OVER()
- LAG()
- RANK()
- CAST()
- NULLIF()
- ROUND()

---

## Query Design

### CTE 1 - MonthlySales

Purpose

- Aggregate completed sales for each month in 2025.
- Calculate:
  - Gross Sales
  - Total Orders

---

### CTE 2 - MonthlyPerformance

Purpose

Using the monthly aggregated data calculate:

- Running Total Sales
- Previous Month Sales
- Monthly Sales Rank

---

### Final SELECT

Calculate

- Average formatting
- Month-over-Month Growth %
- Display user-friendly columns
- Sort the report

---

## Business Formula

### Gross Sales

```
SUM(SalesAmount)
```

### Total Orders

```
COUNT(DISTINCT OrderNumber)
```

### Running Sales

```
SUM(GrossSales)
OVER(
ORDER BY MonthNumber
)
```

### Previous Month Sales

```
LAG(GrossSales)
OVER(
ORDER BY MonthNumber
)
```

### Month-over-Month Growth

```
(
Current Month Sales
-
Previous Month Sales
)
/
Previous Month Sales
*
100
```

### Monthly Rank

```
RANK()
OVER(
ORDER BY GrossSales DESC
)
```

---

## Expected Output

| Month | Gross Sales | Total Orders | Running Sales | Previous Month Sales | MoM Growth % | Sales Rank |
| ----- | ----------: | -----------: | ------------: | -------------------: | -----------: | ---------: |

---

## Performance Considerations

Recommended indexes

### FactSales

```
(DateKey, SalesStatus)
INCLUDE
(
SalesAmount,
OrderNumber
)
```

### DimDate

```
(CalendarYear, DateKey)
```

---

## Production Considerations

- Filter data as early as possible.
- Aggregate before applying window functions.
- Use NULLIF() to prevent divide-by-zero errors.
- Round only presentation values.
- Keep window functions in the same CTE whenever possible.
- Avoid unnecessary joins.
- Ensure indexes support filtering and grouping columns.

---

## Learning Outcome

After completing this Business Requirement, you will understand:

- Time-series analysis
- Running totals
- Previous period comparison
- Window functions
- Analytical reporting
- Query optimization basics