# BR #20 - Executive Summary Report

## Business Requirement

The Executive Management team requires a single consolidated report that provides a high level overview of business performance across sales, customers, products, region, promotion, employees, returns and growth trends.

The report should summarize the most important KPIs in one place to support strategic decision-making and serve as the primary dataset as an Executive PowerBi Dashboard.

## Business Objectives

The report answer question such as:

**Sales Performance**
- What are Total Sales?
- How many completed orders were processed?
- What is the Average Order Value?

**Customer Performance**
- How many active customers made purchases?
- What is the Average Revenue per customer?

**Product Performance**
- Which product generated highest revenue?
- Which category contributed the most sales?

**Regional Performance**
- Which region perform the best?
- Which region perform the worst?

**Promotion Performance**
- How much revenue come from promotion sales?

**Sales Trend**
- Is Sales Growing or Declining?
- What is the latest MoM Growth?
- What is the latest YoY Growth?
- What is the forecast baseline?

## Grain of Report

**One row represents one calendar year with executive level KPIs**

For current dataset has 3 rows one for each year.

## KPIs

**Sales KPIs**
- Gross Sales - FactSales
- Total Orders - FactSales
- Total Quantity Sold - FactSales
- Average Order Value - GrossSales/Orders

**Customer KPIs**
- Active Customers - FactSales
- Revenue per Customer - GrossSales / ActiveCustomers

**Product KPIs**
- Top Product - FactSales + DimProduct
- Top Product Sales
- Top Category - FactSales + DimProduct
- Top Category Sales

**Region KPIs**
- Top Region - FactSales + DimRegion
- Top Region Sales

**Promotion KPIs**
- Promotion Revenue - FactSales
- Promotion Sales%

**Trend KPIs**
- Latest MoM Growth%
- Latest YoY Growth%
- Forecast Baseline

## Tables Required

**FactTables**
- FactSales


**Dimension Tables**
- DimDate
- DimCustomer
- DimProduct
- DimRegion
- DimPromotion

## Query Design

### CTE 1 - SalesSummary
    - GrossSales
    - Orders
    - Quantity
    - AvgOrderValue

### CTE 2 - CustomerSummary
    - Active Customers
    - Revenue Per Customers

### CTE 3 - PromotionSummary
    - PromotionRevenue

### CTE 4 - ExecutiveMetrics
    - Combine all summaries into one dataset

### OUTPUT
| Year | Total Sales | Total Orders | TotalQtySold | Avg Order Value | Active Customer | Avg Revenue per Customer | Product Name | Product Highest Gross Sales | Category Name | Category Highest Gross Sales |Region Name | Region Highest Gross Sales | Promotion Highest Gross Sales | MoM Growth % | YoY Growth %