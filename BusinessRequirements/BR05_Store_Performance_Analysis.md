# BR #05 - Store Performance Analysis

This report provides a comprehensive analysis of store performance metrics by identifying the best-performing stores based on sales with showing its contribution to company total sales.

## Business Requirement

The sales director wants to evaluate "Store performance for the year 2025".

The report should identify the best performing store based on sales while also showing each store contribution to the company total sales.

---

## Business Objective

- Which store generated highest sales?
- How many completed orders did each store received?
- What is Average order value received for each store?
- What percent of company sales come from each store?
- Rank store based on total sales?

---

## Grain 

**One row represents the store's sales performance for 2025 with it's contribution to company total sales**

---

## Tables Required

### FactSales

| Column      | Purpose                |
| ----------- | ---------------------- |
| DateKey     | Join with DimDate      |
| OrderNumber | Calculate Total Orders |
| SalesAmount | Calculate Gross sales  |
| SalesStatus | Filter completed sales |
| StoreKey    | Join with DimStore     |

### DimDate

| Column       | Purpose          |
| ------------ | ---------------- |
| DateKey      | Join Key         |
| CalendarYear | Filter Year 2025 |

### DimStore

| Column    | Purpose              |
| --------- | -------------------- |
| StoreKey  | Join Key             |
| StoreId   | Aggregation on Store |
| StoreName | Display store name   |
| City      | Display city name    |
| State     | Display state name   |

---

## Table Relationships

```
FactSales
    |   |
    |   | DateKey
    |   DimDate
    |
    | StoreKey
    DimStore  
```

---

## KPIs

- Gross Sales
- Total Orders
- Average Order 
- Sales Contribution %
- Store Rank on Gross Sales
- Company total sales
- 

---

## SQL Concepts Used

- CTEs
- Window Functions
- Aggregate Functions

---

## Query Design

### CTE 1 - StoreGrossSales

Purpose

- Aggregate completed sales for each store in 2025.
- Calculate :
  - Gross Sales
  - Total Orders
  

---

### CTE 2 - Company Total Sales

Purpose 

Using Fact Sales get company Gross Sales.

---

### CTE 3 - Store Performance

Purpose

Using Store gross Sales and Company Gross sales to calculate :
- Store Sales with contribution percentage
- Store's rank on Store Gross Sales  
- Average Order Value
  
### Fianl SELECT

- StoreId | StoreName | City | State | TotalOrders | TotalSales | Average Order Value | Company Total Sales | Sales Contribution % | Store Rank
- Display user-friendly columns
- Sort the report on Store Rank and Gross sales Descending

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

### Sales Contribution %

```
Gross Sales/Company Sales * 100
```

## Expected Output

| Store Name | Gross Sales | Total Orders | Average Order Value | PctSaleToCompany |

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

## Performance Considerations

Recommended indexes

### FactSales

```
(DateKey,SalesStatus,StroeKey)
INCLUDE
(
    SalesAmount,
    OrderNumber
)
```

### DimDate

(
    CalendarYear,
    DateKey
)

### DimStore

Create NONCLUSTERED INDEX IX_DimStore_Store
ON DimStore
(
    StoreKey
)
INCLUDE
(
    StoreId,
    StoreName,
    City,
    State
)