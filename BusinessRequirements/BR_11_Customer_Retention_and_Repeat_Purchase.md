# BR #11 - Customer Retention And Repeat Purchase Analysis

## Business Requirement

The Sales Director wants to evaluate customer retention and repeat purchase behaviour for calendar year 2025.

The report should identify repeat customers, measure customer purchasing patterns, and understand customer retention.

## Business Objective

- Which customer purchased only once?
- Which customer are repeat customers?
- What was the first purchase date of each customer?
- What was the last purchase date of each customer?
- How many completed order did each customer placed?
- What was average number of days between purchases?
- How many active days did each customer remain?
- What is the customer retention status?

# Grain of Report

**One row represent the purchase behaviour of single customer for calendar year 2025 identifying the first purchase, last purchase, total orders,average days between purchases, active days and retention status.**

## Tables Required

FactSales
- CustomerKey
- DateKey
- OrderNumber
- SalesStatus
  
DimCustomer
- CustomerKey
- CustomerId
- CustomerName

DimDate
- DateKey
- CalendarYear
- FullDate
  
## KPIs
- Average days between purchase
- Retention Status
- Total Orders 
- Active Days

## SQL Concepts
- CTE's
- Multiple Window functions Lag()
- Sum()
- Count()

## Query Design

### CTE 1- CustomerPurchase
Calculate:
- CustomerKey
- Purchase Date
- OrderNumber
- PrevPurchaseDate

### CTE 2- CustomerPurchaseGap
- purchaseGapDays

### CTE 3- CustomerAvgGapDays

- First Purchase
- Last Purchase
- Total Orders
- AverageGapDays
- ActiveDays

### CTE 4- Customer Retention

- Group customer on their purchase category

###  Final Select

### Output
Customer | First Purchase | Last Purchase | Total Orders | Avg Gap(days) | Active Days | Customer Type