# BR #21 - Executive Dashboard Dataset

## PowerBi Friendly Dashboard
Power BI dashboards need a dataset with many rows so users can:

- Filter by Year
- Filter by Month
- Filter by Region
- Filter by Category
- Filter by Product
- Filter by Promotion
- Drill down

Power BI visuals will support

From one SQL dataset, you can build:

- KPI Cards (Sales, Orders, Customers)
- Line Chart (Monthly Sales)
- Sales by Region
- Sales by Category
- Top Products
- Promotion Impact
- Customer Trend
- Matrix Reports
- Drill-through Pages
- Tooltips
- Year-over-Year Analysis

We'll focus on:

- Dashboard dataset design
- Choosing the right grain
- Star schema-friendly output
- Pre-calculated KPIs vs DAX measures
- SQL shaping for Power BI performance
- Minimizing transformations in Power Query

## Grain of Report
**One row represents data for one month, one region, one product**

This grain will provide report to:
- Year
- Quarter
- Month
- Region
- Category
- Product
- Promotion

## Dataset Columns

**Date**
- CalendarYear
- CalendarQuarter
- CalendarMonth
- MonthName

**Region**
- Region

**Product**
- ProductId
- ProductName
- Category

**Measures**
- GrossSales
- Orders
- QuantitySold
- ActiveCustomers
- PromotionSales

**Analytics**
- AverageOrderValue
- RevenuePerCustomer
- MoMGrowth
- YoYGrowth
- ForecastBaseline
  
## Tables

FactSales
DimDate
DimProduct
DimStore

## Query Design

### CTE 1 - BaseSales
returns:
- Year
- Month
- Region
- Product
- Customer
- Promotion
- SalesAmount
- SalesQuantity
- OrderNumber

### CTE 2- Dashboard Summary
Year * Month * Region * Product
Calculate :
- GrossSales
- TotalOrders
- TotalQuantitySold
- ActiveCustomers
- PromotionSale
  
### CTE 3- Dashboard Metrics
Calculate:
- AverageOrderValue
- RevenuePerCustomer

### CTE 4- Dashboard Trend
Window function:
- MoMGrowth
- YoYGrowth
- ForecastBaseline
- PrevMonthSales
- PrevYearSales

