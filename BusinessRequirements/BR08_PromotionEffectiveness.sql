/*
===============================================================================
Business Requirement : BR #08 - Promotion Performance Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Promotion performance by identifying best-performing Promotion based on gross sales and measuring each promortion's contribution to company's total sales
*/

-- CTE 1- Promotion Sales

With PromotionSales AS  (
    SELECT fs.PromotionKey,
            COUNT(DISTINCT fs.orderNumber) as TotalOrders,
            SUM(fs.salesamount) as PromotionGrossSales
    FROM factsales as fs
    INNER JOIN dimdate as dd 
        ON fs.datekey = dd.datekey
    WHERE fs.salesstatus = 'completed'
        AND dd.calendarYear = 2025
    GROUP BY fs.PromotionKey
),

-- CTE 2- CompanyTotalSales

CompanyTotalSales AS (
    SELECT sum(ps.PromotionGrossSales) as TotalCompanySales
    FROM PromotionSales as ps
),

-- CTE 3- Promotion Performance
PromotionPerformance AS (
    SELECT 
        ps.promotionkey,
        ps.totalOrders,
        ps.PromotionGrossSales,
        cts.totalCompanySales,
        -- AverageOrderValue
        CAST(ps.PromotionGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(ps.totalOrders AS DECIMAL(18,4)),0) AS avgOrderValue,
        
        -- PromotionContributionPct
        CAST(ps.PromotionGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(cts.totalCompanySales AS DECIMAL(18,4)),0)*100 AS PromotionSalesContributionPct,

        -- Rank Promotion on Promotion Gross Sales
        RANK()OVER(ORDER BY ps.PromotionGrossSales DESC) AS PromotionRank

    FROM PromotionSales AS ps
    CROSS JOIN CompanyTotalSales AS cts

)
-- FINAL SELECT
    SELECT  dp.promotionId,
            dp.promotionName,
            dp.promotionType,

            pp.totalOrders,
            ROUND(pp.PromotionGrossSales,2) AS PromotionGrossSales,
            ROUND(pp.avgOrderValue,2) AS avgOrderValue,
           
            ROUND(pp.totalCompanySales,2) AS CompanyTotalSales,
            ROUND(pp.PromotionSalesContributionPct,2) AS PromotionSalesContributionPct,

            pp.PromotionRank

    FROM PromotionPerformance AS pp
    INNER JOIN DimPromotion AS dp
        ON pp.PromotionKey = dp.PromotionKey
    WHERE pp.PromotionRank <=5
    ORDER BY pp.PromotionRank,pp.PromotionGrossSales DESC;

    