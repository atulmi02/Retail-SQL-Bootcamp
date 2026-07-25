# BR #12 - Monthly Sales Trend Analysis

## Business Requirement

The Sales Director wants to understand how sales are changing over time.

The report should compare each month's sales against the previous month and identify growth or decline during the calendar year 2025

## Business Objective

- What are monthly completed sales?
- Which month generate highest Sales?
- How many completed orders where received each month?
- What was Average Order Value (AOV) for each month?
- How much did sales grow or decline compared to previous month?
- What was the Month-over-Month (MOM) growth %?
- What is cumulative running sales for the year?
  
## Grain of Report

**One row represents the total completed sales performance of single calendar month for the calendar year 2025 including gross sales,total order, previous month sales, average order value, month on month sales growth % and its running total sales.**

## Tables Required

FactSales
- SalesKey
- DateKey
- OrderNumber
- SalesAmount
- SalesStatus

DimDate
- DateKey
- CalendarYear
- FullDate
- MonthNumber
- MonthName

## KPIs

- GrossSales
- TotalOrders
- Average Order Value = GrossSales / TotalOrders
- PrevMonthSales
- Sales Difference = CurrentMonth - PrevMonthSales
- MOM Growth% = Sales Difference / PrevMonthSales * 100
- Running Total Sales

## SQL Concepts
- CTEs
- Lag()
- Sum()
- Count()


## Query Design

### CTE 1- MonthlySales
Calculate:
- GrossSales
- TotalOrders

### CTE 2- MonthlyPerformance
Calculate:
- PrevMonthSales
- RunningTotalSales
- AverageOrderValue

### CTE 3- MonthlyGrowth
Calculate:
- MOMgrowth%


### Fianl Output
- Order By monthNumber

MonthName | TotalOrders | AOV | GrossSales | PrevMonthSales | SalesDifference | MOMGrowth | RunningSales

## Production Consideration

- Filter early
- Aggregate before window functions
- Use NULLIF
- Use ROUND only in final SELECT
- Sort by MonthNumber
- Avoid unnecessary joins