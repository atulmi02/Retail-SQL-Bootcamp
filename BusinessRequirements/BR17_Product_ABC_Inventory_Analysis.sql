/*
===============================================================================
Business Requirement : BR #17 - Product ABC Inventory Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Product performance by identifying best-performing Product based on gross sales and measuring each Product's contribution to company's total sales
*/
-- ProductAnnualSales
WITH ProductAnnualSales AS (
    SELECT 
        fs.ProductKey,
        COUNT(DISTINCT fs.OrderNumber) AS TotalOrders,
        CAST(SUM(fs.SalesAmount) AS DECIMAL(18,4)) AS GrossSales
    FROM factsales AS fs
    INNER JOIN dimdate AS dd
        ON fs.DateKey = dd.DateKey
    WHERE fs.SalesStatus = 'completed'
        AND dd.CalendarYear = 2025
    GROUP BY fs.ProductKey
),
-- CTE 2- CompanyTotalSales
CompanyTotalSales AS(
    SELECT 
        SUM(pas.GrossSales) AS totalCompanySales
    FROM ProductAnnualSales AS pas
),
-- CTE 3- ProductMetrics
ProductMetrics AS (
    SELECT 
        pas.ProductKey,
        pas.TotalOrders,
        pas.GrossSales,

        -- AverageOrderValue
        pas.GrossSales
        /
        NULLIF(pas.TotalOrders,0) AS AverageOrderValue,

        -- ProductToCompanyContribution
        pas.GrossSales
        /
        NULLIF(cts.totalCompanySales,0) 
        *100 AS ProductToCompanyContributionPct

    FROM ProductAnnualSales AS pas
    CROSS JOIN CompanyTotalSales AS cts
),

-- CTE 4- CumulativeProductPct
CumulativeProductPct AS (
    SELECT 
        pm.ProductKey,
        dp.productId,
        dp.productName,
        dp.category,
        pm.TotalOrders,
        pm.GrossSales,
        pm.AverageOrderValue,
        pm.ProductToCompanyContributionPct,

        -- Cumulative Product Classification based on product to company contribution percentage
        SUM(pm.ProductToCompanyContributionPct)
            OVER (ORDER BY pm.GrossSales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeContributionPct,
        
        -- Top N Products based on Gross Sales
        NTILE(5)
         OVER  (ORDER BY pm.GrossSales DESC) AS ProductGroup,

        -- ProductRank
        RANK() OVER 
        ( ORDER BY pm.GrossSales DESC) AS ProductRank
    FROM ProductMetrics AS pm
    INNER JOIN dimproduct AS dp
        ON pm.ProductKey = dp.ProductKey
),
-- CTE 5- ProductClassification
ProductClassification AS (
    SELECT 
        cpp.ProductKey,
        cpp.productId,
        cpp.productName,
        cpp.category,
        cpp.TotalOrders,
        cpp.GrossSales,
        cpp.AverageOrderValue,
        cpp.ProductToCompanyContributionPct,
        cpp.CumulativeContributionPct,

        -- Product Classification based on cumulative product to company contribution percentage
        CASE 
            WHEN cpp.CumulativeContributionPct <= 80 THEN 'A'
            WHEN cpp.CumulativeContributionPct <= 95 THEN 'B'
            ELSE 'C'
        END AS ProductABCclassification,
        cpp.ProductGroup,

        -- Top N Products based on Gross Sales of Category
        CASE 
            WHEN cpp.ProductGroup = 1 THEN 'Top 20%'
            WHEN cpp.ProductGroup = 2 THEN '20% - 40%'
            WHEN cpp.ProductGroup = 3 THEN '40% - 60%'
            WHEN cpp.ProductGroup = 4 THEN '60% - 80%'
            ELSE 'Bottom 20%'  
        END AS ProductPerformance, 
        cpp.ProductRank
        
        
    FROM CumulativeProductPct AS cpp
)
-- FINAL SELECT 
SELECT 
        pc.productId,
        pc.productName,
        pc.category,
        pc.TotalOrders,
        ROUND(pc.GrossSales,2) AS GrossSales,
        ROUND(pc.AverageOrderValue,2) AS AverageOrderValue,
        ROUND(pc.ProductToCompanyContributionPct,2) AS ProductToCompanyContributionPct,
        ROUND(pc.CumulativeContributionPct,2) AS CumulativeContributionPct,
        pc.ProductABCclassification,
        -- pc.ProductGroup,
        pc.ProductPerformance,
        pc.ProductRank
FROM ProductClassification AS pc
ORDER BY pc.ProductRank, pc.GrossSales DESC;