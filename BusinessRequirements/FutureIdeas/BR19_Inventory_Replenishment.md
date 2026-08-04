# BR 19# - Inventory Replenishment Analysis

## Business Requirement

The Inventory Management teams wants to proactively monitor inventory levels and identify products that require replenishment before stockouts occur.

The report should estimate inventory availability, predict stock depletion, and prioritize products for replenishment based on current stock levels and sales velocity.

## Business Objective

- Which products should be reordered?
- Which products will stock out soon?
- Which products are overstocked?
- Whcih products have the highest inventory risk?
- Which products require immediate replenishment?
- Which products have slow-moving inventory?
- What is the estimate stock out date for each product?

## Grain of Report

One row represents one product with its current inventory position, sales velocity, replenishment metrics, and recommended inventory action.

## KPIs

### Inventory
- Current Stock
- Reorder Level
- Safety Stock
- Reorder Quantity

### Sales
- Total Unit Sold
- Average Daily Sales

### Predictive

- Days of stock remaining
- Estimated Stockout Date

### Decision

- Stock Status
- Reorder Priority
  
## Tables Required

FactSales
- ProductKey
- SalesStatus
- Quantity
- DateKey

FactInventory
- ProductKey
- StockOnHand
- ReorderLevel
- SafetyCheck

DimProduct
- ProductKey
- ProductId
- ProductName
- Category

DimDate
- DateKey
- fullDate

## Output

ProuctName | Category | CurrentStock | Units Sold | AvgDailySales | DaysRemaining | ReorderLevel | Safety check | Recommended Reorder qty | Estimated Stockout Date | Stock Status | Priority

## Business Formula

1. Average Daily Sales = Units sold / Number of Days
2. Days of Stock Remaining => 
        Days Remaining = Current Stock / Avg Daily Sales
3. Recommended Reorder Qty. => 
        ReorderQty = ( Reorder Level + Safety Stock ) - Current Stock 
        ( if negative then return 0)
4. Estimated stockout date = Today + Day Remaining

## Business Rules

**Stock Status**

| Condition                       | Status      |
|---------------------------------|-------------|
| Current stock < =  Safety Stock | Critical    |
| Current stock < = Reorder Level | Reorder     |
| Days Remaining < 7              | Low Stock   |
| Otherwise                       | Healthy     |

**Reorder Priority**

| Condition     | Priority    |
|---------------|-------------|
| Critical      | High        |                  
| Reorder       | Medium      |
| Low Stock     | Low         |
| Healthy       | None        |

## Query Design

### CTE 1 - ProductSales

Calculate sales for each product:
- ProductKey
- UnitsSold
- SalesDays

### CTE 2 - InventoryPosition

Calculate:
    Bring inventory information 
  - ProductKey
  - CurrentStock
  - ReorderLevel
  - SafetyStock

### CTE 3 - Inventory Metrics

Calculate:
- AverageDailySales
- DaysRemaining
- RecommendedReorderQty

### CTE 4 - Inventory Status

Determine:
- EstimatedStockOutDate
- StockStatus
- ReorderPriority
