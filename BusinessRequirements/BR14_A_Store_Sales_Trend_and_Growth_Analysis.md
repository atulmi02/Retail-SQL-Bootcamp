# BR #14 - Store Sales Trend & Growth Analysis

## Business Requirement

The Operation Director wants to monitor the monthly sales performance of every store during the calendar year 2025.

The report should compare each store's monthly sales with the previous month, measure month-over-month growth, calculate cumulative sales, and identify stores with consistent growth or decline.

## Business Objective

- Which Store generated highest monthly sales?
- How did each month store perform compared tot previous month?
- Which stores are growing consistently i.e last 3 months or all 12 month store reported positive growth?
- Which stores are declining i.e last 3 month or all 12 month store reported negative growth?
- What is the cumulative sales of each store throughout the year?
- Which store should receive operational attention? 
     Needs business stakeholder rule to validate Like :
      - MOM Growth < -20%
      - OR Monthly Rank > 40
      - OR Running Sales below company average
      - OR Gross Sales below monthly average

## Grain of Report

**One row represents the store performance of single store for a single month in the calendar year 2025 including it's gross sales, total orders, average order value, previous month sales, sales difference, month over month growth, running sales.**

## Tables Required

FactSales
- Datekey
- StoreKey
- OrderNumber
- SalesAmount
- SalesStatus

DimDate
- DateKey
- CalendarYear
- CalendarMonth
- MonthName

DimStore
- StoreKey
- StoreId
- StoreName
- City
- State

## KPIs

- GrossSales
- TotalOrders
- AverageOrderValue = GrossSales / TotalOrders
- PrevMonthSales
- SalesDifference = GrossSales - PrevMonthSales
- MOM Growth% = SalesDifference / PrevMonthSales * 100
- Running Total Sales

## SQL Concepts
- CTE's
- LAG()
- SUM()
- COUNT()
- CAST()

## Query Design

### CTE 1- StoreMonthlySales
Calculate:
- GrossSales
- TotalOrders

### CTE 2- StorePerformance
Calculate:
- PrevMonthSales
- RunningTotalSales
- AverageOrderValue

### CTE 3 - StoreMonthlyGrowth
Calculate:
- SalesDifference
- MOMgrowth%
  
### Final Output

- Order By StoreName,Month 

StoreId | StoreName | MonthName | TotalOrders | AOV | GrossSales | PrevMonthSales | SalesDifference | MOMGrowth | RunningSales 

## Production Consideration

- Filter early
- Aggregate before window functions
- Use NULLIF
- Use ROUND only in final SELECT
- Sort by MonthNumber
- Avoid unnecessary joins