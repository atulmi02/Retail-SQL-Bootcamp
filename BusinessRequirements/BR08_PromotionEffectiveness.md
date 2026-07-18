# BR #08 - Promotion Effective Analysis

The Marketing Director wants to evaluate the effectiveness of promotional campaigns for calendar year 2025.

The report should identify the best-performing promotions based on sales and show how much each promotion contributed to company's total promotional sales.

---

## Business Objectives

- Which promotion generated the highest sales?
- How many completed orders were generated under each promotion?
- What was Average Order Value for each promotion?
- What percentage of total promotional sales did each promotion contribute?
- Rank promotion based on Gross Sales.
- Which promotions were the most effective in driving sales?

---

## Grain of Report

One row represent gross sales performance of single promotion for year 2025 including its contribution to company total sales.

## Table Required

Fact Sales

- Datekey
- OrderNumber
- SalesAmount
- PromotionKey
- SalesStatus

DimDate

- DateKey
- CalendarYear

DimPromotion

- PromotionKey
- PromotionId
- PromotionName
- PromotionType

## KPIs

- Gross Sales
- Total Orders
- Average Order Value = Gross sales / Total Orders
- Promotion Sales  to Company Sales pct = (Promotion gross sales / Company Total Sales) * 100
  
## SQL Concepts

- CTE's
- Window functions
- Sum()
- Count()
- CAST()
- NULLIF()

## Query Design

### CTE 1- PromotionSales

Purpose
- Filter completed sales for year 2025
- Calculate Total Order per Promotion
- Calculate Total Sales per Promotion

### CTE 2- CompanyTotalSales

Purpose

- Calculate  Company Total sales


### CTE 3- PromotionPerformance

Purpose
- Calculate average order value
- Calculate Promotion contribution to company total sales
- Calculate Promotion Rank on gross sales 

### Final Select

Final Report
- PromotionID | PromotionName | Promotion Type | Total Orders | Gross Sales | Avg Order Value |  Total Sales  | Promotion contribution pct | Promotion Rank
- Sort report on Promotion rank and gross sales DESC

---

## Expected Output

Promotion | PromotionName | Promotion Type | Total Orders | Gross Sales | Avg Order Value |  Total Sales  | Promotion contribution pct | Promotion Rank

## Production Considerations

- Filter data as early as possible.
- Aggregate before applying window functions.
- Use NULLIF() to prevent divide-by-zero errors.
- Round only presentation values.
- Keep window functions in the same CTE whenever possible.
- Avoid unnecessary joins.
- Ensure indexes support filtering and grouping columns.

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

### Average Order Value

```
GrossSales/TotalOrders
```

### Promotion Sales Contribution %

```
Promotion Gross Sales/Company Sales * 100
```

