/*
===============================================================================
Business Requirement : BR #06 - Product Performance Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of product performance by identifying best-performing products based on gross sales and measuring each products contribution to it's product category.

Grain:One row represents the total completed sales for 2025 of single product with it's contribution to it's product cateogry.

Tables Used:
    • FactSales
    • DimProduct
    • DimDate
*/

-- CTE ! - ProductGrossSales
With ProductGrossSales AS (
    SELECT
        fs.productkey,
        Sum(fs.salesamount)             AS GrossSales,
        Count(DISTINCT fs.ordernumber)  AS TotalOrders
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.DateKey = dd.DateKey
        WHERE fs.SalesStatus = 'completed' 
            AND dd.CalendarYear = 2025
        GROUP BY fs.productkey
),
-- CTE 2 - CategorySales
CategorySales AS (
    SELECT
        dp.Category,
        SUM(pgs.GrossSales) AS TotalCategorySales    
    FROM ProductGrossSales AS pgs
    INNER JOIN DimProduct AS dp
        ON pgs.ProductKey = dp.ProductKey
    GROUP BY dp.Category
),
-- CTE 3 - ProductPerformance
ProductPerformance AS (
    SELECT 
            pgs.ProductKey,
            pgs.GrossSales,
            pgs.TotalOrders,
            dp.Category,
            cs.TotalCategorySales,
            -- Avg Order Value = Gross Sales / Total Orders
            CAST(pgs.GrossSales AS DECIMAL(18,2))
            /
            NULLIF(pgs.TotalOrders,0) AS AverageOrderValue,
            -- Product Contribution to Category = Gross Sales / Total Category Sales * 100
            CAST(pgs.GrossSales AS DECIMAL(18,2))
            /
            NULLIF(CAST(cs.TotalCategorySales AS DECIMAL(18,2)),0)
            *100 AS ProductCategoryPct,
            -- Product Rank based on Gross Sales within it's Category
            RANK()OVER(PARTITION BY cs.category ORDER BY pgs.GrossSales DESC) AS productRank
    FROM ProductGrossSales AS pgs
    INNER JOIN DimProduct AS dp
        ON pgs.ProductKey = dp.ProductKey
    Inner Join CategorySales AS cs
        ON dp.Category = cs.Category
)

-- FINAL SELECT 
SELECT 
        dp.ProductId,
        dp.ProductName,
        pp.Category,
        
        pp.TotalOrders,
        pp.GrossSales,
        ROUND(pp.AverageOrderValue,2) AS AverageOrderValue,

        ROUND(pp.TotalCategorySales,2) AS TotalCategorySales,
        ROUND(pp.ProductCategoryPct,2) AS ProductCategoryPct,
        
        pp.productRank
FROM ProductPerformance AS pp
INNER JOIN DimProduct AS dp
    ON pp.ProductKey = dp.ProductKey
WHERE pp.productRank <= 3
ORDER BY pp.Category, pp.productRank, pp.GrossSales DESC
