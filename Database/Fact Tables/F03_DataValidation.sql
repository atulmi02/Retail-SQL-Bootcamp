/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 12_DataValidation.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

-- =====================================================
-- 1. Row Counts
-- =====================================================

SELECT 'DimDate' AS TableName, COUNT(*) AS TotalRows FROM DimDate
UNION ALL
SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL
SELECT 'DimStore', COUNT(*) FROM DimStore
UNION ALL
SELECT 'DimEmployee', COUNT(*) FROM DimEmployee
UNION ALL
SELECT 'DimPromotion', COUNT(*) FROM DimPromotion
UNION ALL
SELECT 'DimSupplier', COUNT(*) FROM DimSupplier
UNION ALL
SELECT 'StageSales', COUNT(*) FROM StageSales
UNION ALL
SELECT 'FactSales', COUNT(*) FROM FactSales;

-- =====================================================
-- 2. Duplicate Order Numbers
-- =====================================================

SELECT
OrderNumber,
COUNT(*) AS DuplicateCount
FROM FactSales
GROUP BY OrderNumber
HAVING COUNT(*) > 1;

-- Expected : 0 rows

-- =====================================================
-- 3. NULL Check
-- =====================================================

SELECT
SUM(DateKey IS NULL) DateKeyNulls,
SUM(CustomerKey IS NULL) CustomerNulls,
SUM(ProductKey IS NULL) ProductNulls,
SUM(StoreKey IS NULL) StoreNulls,
SUM(EmployeeKey IS NULL) EmployeeNulls,
SUM(PromotionKey IS NULL) PromotionNulls
FROM FactSales;

-- Expected : All 0

-- =====================================================
-- 4. Foreign Key Validation
-- =====================================================

SELECT COUNT(*) InvalidDateKeys
FROM FactSales f
LEFT JOIN DimDate d
ON f.DateKey=d.DateKey
WHERE d.DateKey IS NULL;

SELECT COUNT(*) InvalidCustomers
FROM FactSales f
LEFT JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey
WHERE c.CustomerKey IS NULL;

SELECT COUNT(*) InvalidProducts
FROM FactSales f
LEFT JOIN DimProduct p
ON f.ProductKey=p.ProductKey
WHERE p.ProductKey IS NULL;

SELECT COUNT(*) InvalidStores
FROM FactSales f
LEFT JOIN DimStore s
ON f.StoreKey=s.StoreKey
WHERE s.StoreKey IS NULL;

SELECT COUNT(*) InvalidEmployees
FROM FactSales f
LEFT JOIN DimEmployee e
ON f.EmployeeKey=e.EmployeeKey
WHERE e.EmployeeKey IS NULL;

SELECT COUNT(*) InvalidPromotions
FROM FactSales f
LEFT JOIN DimPromotion p
ON f.PromotionKey=p.PromotionKey
WHERE p.PromotionKey IS NULL;

-- Expected : All 0

-- =====================================================
-- 5. Employee belongs to Store
-- =====================================================

SELECT COUNT(*) InvalidAssignments
FROM FactSales f
JOIN DimEmployee e
ON f.EmployeeKey=e.EmployeeKey
WHERE f.StoreKey<>e.StoreKey;

-- Expected : 0

-- =====================================================
-- 6. Sales Status Distribution
-- =====================================================

SELECT
SalesStatus,
COUNT(*) TotalRows,
ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM FactSales),2) Percentage
FROM FactSales
GROUP BY SalesStatus;

-- Expected:
-- Completed ~85%
-- Returned ~10%
-- Cancelled ~5%

-- =====================================================
-- 7. Quantity Distribution
-- =====================================================

SELECT
SalesQuantity,
COUNT(*) TotalRows
FROM FactSales
GROUP BY SalesQuantity
ORDER BY SalesQuantity;

-- =====================================================
-- 8. Financial Summary
-- =====================================================

SELECT

ROUND(SUM(SalesAmount),2) TotalSales,

ROUND(SUM(CostAmount),2) TotalCost,

ROUND(SUM(ProfitAmount),2) TotalProfit,

ROUND(AVG(SalesAmount),2) AvgSale,

ROUND(AVG(ProfitAmount),2) AvgProfit

FROM FactSales;

-- =====================================================
-- 9. Negative Profit Check
-- =====================================================

SELECT COUNT(*) NegativeProfitRows
FROM FactSales
WHERE ProfitAmount<0;

-- =====================================================
-- 10. Date Range
-- =====================================================

SELECT

MIN(d.FullDate) FirstSale,

MAX(d.FullDate) LastSale

FROM FactSales f
JOIN DimDate d
ON f.DateKey=d.DateKey;

-- Expected:
-- 2023-01-01
-- 2025-12-31

-- =====================================================
-- 11. Top 10 Products
-- =====================================================

SELECT
p.ProductName,
SUM(f.SalesQuantity) UnitsSold,
ROUND(SUM(f.SalesAmount),2) Revenue
FROM FactSales f
JOIN DimProduct p
ON f.ProductKey=p.ProductKey
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 10;

-- =====================================================
-- 12. Top 10 Customers
-- =====================================================

SELECT
c.CustomerName,
ROUND(SUM(f.SalesAmount),2) Revenue
FROM FactSales f
JOIN DimCustomer c
ON f.CustomerKey=c.CustomerKey
GROUP BY c.CustomerName
ORDER BY Revenue DESC
LIMIT 10;

-- =====================================================
-- 13. Top Stores
-- =====================================================

SELECT
s.StoreName,
ROUND(SUM(f.SalesAmount),2) Revenue
FROM FactSales f
JOIN DimStore s
ON f.StoreKey=s.StoreKey
GROUP BY s.StoreName
ORDER BY Revenue DESC;