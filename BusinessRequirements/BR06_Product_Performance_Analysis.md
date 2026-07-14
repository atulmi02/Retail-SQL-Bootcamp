# BR# 06 - Product Performance Analysis

This report provides comprehensive analysis of product performance by identifying best-performing product based on gross sales and measuring each product contribution to it's product category.

---

## Business Objective
- Which Product generated highest gross sales?
- How many completed orders were received for each product?
- What percentage of category sales does each product contribute?
- What is Average Order Value (AOV) for each product?
- Rank products within each category based on sales.
  
---

## Grain of Report

**One row represents the total completed sales for 2025 of single product with it's contribution to it's product cateogry.**

---

## Tables Required 

### FactSales

| Column      | Purpose               |
| ----------- | --------------------- |
| DateKey     | Join with DimDate     |
| ProductKey  | Join with  Dimproduct |
| OrderNumber | get Total Orders      |
| SalesAmount | get Total Sales       |
| SalesStatus | get completed sales   |

### DimDate

| Column       | Purpose          |
| ------------ | ---------------- |
| DateKey      | Join key         |
| CalendarYear | Filter Year 2025 |

### DimProduct

| Column      | Purpose              |
| ----------- | -------------------- |
| ProductKey  | Join Key             |
| ProductId   | get unique productID |
| ProductName | get product name     |
| Category    | get category         |

---

## Table Relationship

```
FactSales
    |   |
    |   | DateKey
    |   DimDate
    |
    | ProductKey
    DimProduct  
```

---

## KPIs

- Gross Sales
- Total Orders
- Average Order Value = Gross sales / Total Orders
- Product Sales  to category pct = (Product gross sales / Category Total Sales) * 100
- Product Rank on Gross Sales in it's category
- Category total sales
  
## SQL Concepts

- CTE's
- Window functions
- Sum()
- Count()
- CAST()
- NULLIF()
  
## Query Design

### CTE 1- ProductSales

Purpose
- Filter completed sales for year 2025
- Calculate Total Order per Product
- Calculate Total Sales per Product

### CTE 2- ProductCategoryTotalSales

Purpose
- 
- Calculate category Total sales


### CTE 3- ProductPerformance

Purpose
- Calculate average order value
- Calculate Product contribution to category
- Calculate Product Rank on gross sales in it's category

### Final Select

Final Report
- ProductId | ProductName | Category | Total Orders | Gross Sales | Avg Order Value | Category Total Sales  | Product contribution pct | Product Rank
- Sort report on Category,Product rank and gross sales DESC

---

## Expected Output

ProductId | ProductName | Category | Total Orders | Gross Sales | Avg Order Value | Category Total Sales  | Product contribution pct | Product Rank

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

### Product Sales Contribution %

```
Gross Sales/Category Sales * 100
```
