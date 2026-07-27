# BR #13 - Product Sales Trend & Growth Analysis

## Business Requirement

The Product Director wants to understand how each product is performing over time.

The report should compare monthly sales of every product and identify products with consistent growth or decline throughout the calendar year 2025.

--- 

## Business Objective

- Which products generated the highest monthly sales?
- How did each product perform compared to previous month?
- What was month-over-month growth for each product?
- Which product are consistently growing?
- Whcih products are declining?
- What is the running sales of each product during the year?

## Grain of Report

**One row represents the sales performance of single product for a single month in the  calendar year 2025 including it's gross sales,total orders,average order value, previous month sales, sales difference, month over month growth, running sales**

## Tables Required

FactSales
- DateKey
- ProductKey
- OrderNumber
- SalesAmount
- SalesStatus

DimDate
- DateKey
- CalendarYear
- CalendarMonth
- MonthName

DimProduct
- ProductKey
- ProductId
- ProductName

## KPIs

- GrossSales
- TotalOrders
- AverageOrderValue = GrossSales / TotalOrders
- PrevMonthSales
- SalesDifference = GrossSales - PrevMonthSales
- MOM Growth% = SalesDifference / PrevMonthSales * 100
- Running Total Sales
  
## SQL Concepts
- CTEs
- LAG()
- SUM()
- COUNT()
- CAST()

## Query Design

### CTE 1- ProductMonthlySales
Calculate:
- GrossSales
- TotalOrders

### CTE 2- ProductPerformance
Calculate:
- PrevMonthSales
- RunningTotalSales
- AverageOrderValue

### CTE 3 - ProductMonthlyGrowth
Calculate:
- MOMgrowth%
  
### Final Output

- Order By ProductName,Month 

ProductId | ProductName | MonthName | TotalOrders | AOV | GrossSales | PrevMonthSales | SalesDifference | MOMGrowth | RunningSales 

## Production Consideration

- Filter early
- Aggregate before window functions
- Use NULLIF
- Use ROUND only in final SELECT
- Sort by MonthNumber
- Avoid unnecessary joins