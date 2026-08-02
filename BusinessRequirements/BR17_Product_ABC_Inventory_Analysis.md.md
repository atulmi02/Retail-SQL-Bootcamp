# BR #17 Product ABC Inventoy Analysis

## Business Requirement

The Invetory Manager wants to identify which product contribute most to total revenue so that inventory planning, purchasing and stock management can be prioritized.

The report should classify products using ABC analysis based on cumulative sales contribution.

## Business Objective

- Which products generate the most revenue?
- What percentage does each product contribute?
- Which products belong to Class A, B and C?
- Which products should receive the highest inventory priority?
- Which low value products can be reviewed or discontinued?
- Which categories contain the highest number of A products?

## Grain of Report

**One row of report reperesent the annual sales performance of single product for the calendar year 2025 including its gross sales, contribution to total company sales, cumulative contribution, product group and ABC classification.**

## KPIs

- Gross Sales
- Total Company Sales 
- Total Orders
- Average Order Value = GrossSales / TotalOrders
- Total Sales Contribution % = GrossSales / TotalCompanySales * 100
- Cumulative Contribution = SUM(Total Sales Contribution %)
- Product Group (Top 20%)
- Product Rank
- ABC Classification

## Tables Required

Fact Sales
- DateKey
- OrderNumber
- SalesAmount
- SalesStatus
- ProductKey

DimDate
- DateKey
- CalendarYear

DimProduct
- ProductKey
- ProductId
- ProductName
- Category

## Output 
ProductId | ProductName | TotalOrders | AOV | GrossSales | Product Rank | Total Sales Contribution % | Cumulative Contribution % |Product Group (Top 20%) | ABC Classification

## Query Design

### CTE 1- ProductAnnualSales
  - GrossSales
  - TotalOrder

### CTE 2- CompanyTotalSales
  - TotalCompanySales
  
### CTE 3- ProductMetrics
  - AverageOrderValue
  - TotalSalesContribution %
  - Cumulative Contribution %
  - Product Group
  - Product Rank
  - ABC Classification