# BR #18B - Association Rule Mining (Market Basket Analysis)

## Business Requirement

The Merchandising team wants to identify true product association using association rule metrics insted of relying only on purchase frequency.

The report should measure the strength of relationships between products using Support, Confidence, and Lift.

## Business Objective

- Whcih product pairs have the storngest association?
- Which products should be bundeled together?
- Which products should be recommended together?
- Which products should be placed near each other?
- Which product pair have the highest confidence?
- Which associations are genuine and which are only popular because products sell frquently?
- Which bundles can increase cross-selling revenue?

## Grain of Report

**One row represents unique product pair A->B purchased together in completed together during the calendar year 2025 including its association metrics such as Support, Confidence, Lift**

## KPIs

- Orders containing Product A
- Orders containing Product B
- Orders containing both
- Total Completed Orders
- Support %
- Confidence %
- Lift
- Product Association Rank

## Tables Required

FactSales
- DateKey
- ProductKey
- OrderNumber
- SalesStatus

DimDate
- DateKey
- CalendarYear

DimProduct
- ProductKey
- ProductId
- ProductName
- Category

## Output

Product A | Product B | Orders(A) | Orders(B) | Orders(A&B) | Support % | Confidence % | Lift | Rank

## Query Design

### CTE 1 - OrderProducts
    - OrderNumber
    - ProductKey
  
### CTE 2 - ProductPairs
    - OrderNumber
    - Product A
    - Product B

### CTE 3 - ProductPairFrequency
    - Product A
    - Product B
    - OrderTogether

### CTE 4 - IndividualProductFrequency
Count how many orders each individual product appears in
    - ProductKey
    - OrdersContainingProduct

### CTE 5 - TotalOrders

### CTE 6 - AssociationMetrics
    - Orders A
    - Orders B
    - Orders A&B
    - Support
    - Confidence
    - Lift

## Business Formula

1. Support = Orders(A∩B) / Total Orders
2. ​Confidence A -> B​ = Orders(A∩B) / Orders A
3. Lift = ​Confidence A -> B / Support (B)
   OR
   Lift = Orders(A∩B) * Total Orders / Orders A * Orders B

## Query Design

OrderProducts
        │
        ▼
ProductPairs
        │
        ▼
ProductPairFrequency
        │
        ├──────────────┐
        ▼              ▼
Association      IndividualProductFrequency
        │              │
        └──────┬───────┘
               ▼
        AssociationMetrics
               ▼
          FinalMetrics