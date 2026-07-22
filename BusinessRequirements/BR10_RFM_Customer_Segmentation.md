# BR #10 - RFM Customer Segmentation

## Business Objective

The Marketing Director wants to segment customers based on their purchasing behaviour to identify:
- Best Customers
- Loyal Customers
- Potential Loyalists 
- At-Risk Customers
- Lost Customers

This report should classify every customer using RFM analysis.

### What is RFM?

R- Recency
    - How recently did the customer purchase?
    - Day's since last purchase.
    - "Lower is Better"
F- Frequency
    - How often did customer purchase?
    - Count(Distinct OrderNumber)
    - "Higher is Better"
M- Monetary
    - How much money did the customer spend?
    - Sum(SalesAmount)
    - "Higher is better"

---

## Grain of Report

**One row of report represent the Purchasing behaviour of single customer for calendar year 2025, Recency, Frequency, Monetary value, RFM scores and customer segment.**

## Business Requirement

- Which customers purchased most recently?
- Which customers purchase most frequently?
- Which customers generated the highest revenue?
- Which customers are Champions?
- Which customers are Loyal?
- Which customers are At Risk?
- Which customers are Lost?
- Which customers should receive marketing campaigns?

## Tables Required

FactSales
- CustomerKey
- DateKey
- OrderNumber
- SalesAmount
- SalesStatus

DimDate
- DateKey
- CalendarYear
- FullDate

DimCustomer
- CustomerKey
- CustomerId
- CustomerName
- Email
- Phone


## KPI's
- Recency
- Frequency
- Monetary
- R Score
- F Score
- M Score
- RFM Score
- CustomerSegment

## SQL Concepts
- CTE's
- Multiple Window functions
- Sum()
- Count()
- CAST()
- NULLIF()
- NTILE()
- CASE
- Customer Segmentation
- Business Classification Logic

## Query Design

### CTE 1- CustomerRFM
Calculate :
- Last Purchase Date
- Frequency
- Monetary

### CTE 2- CustomerMetrics
Calculate :
- Recency
- Frequency
- Monetary

### CTE 3- RFM Scores
Assign:
- R Score
- F Score
- M Score
Using NTILE(5)

### CTE 4- CustomerSegment

- Generate RFM Score
- Customer Segmentation using CASE

### Final Output

- Customer | Recency | Frequency | Monetary | R | F | M | RFM_Score | Segment
- Sort by Customer Segment, RFM Score DESC, Monetary DESC

## Business Formula

### Recency

```
Reference Date - Last Purchase Date
```

### Frequency

```
COUNT(DISTINCT OrderNumber)
```

### Monetary

```
SUM(salesAmount)
```

### RFM Score

```
CONCAT(R_Score, F_Score, M_Score)
```

### Customer Segemtation

| RFM Score         |   Segment         |
|-------------------|-------------------|
| 555               | Champions         |
| High R + High F   | Loyal Customer    |
| High R + Medium F | Potetial Loyalist |
| Low R + High M    | At Risk           |
| Low R + Low F     | Lost Customer      |