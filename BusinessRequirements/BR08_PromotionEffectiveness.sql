/*
===============================================================================
Business Requirement : BR #08 - Employee Performance Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Promotion performance by identifying best-performing Promotion based on gross sales and measuring each Promortion contribution to Company's Total sales
*/

-- CTE 1- Promotion Sales

With PromotionSales AS  (
    SELECT fs.PromotionKey,
            COUNT(DISTINCT fs.orderNumber) as TotalOrders,
            SUM(fs.salesamount) as PromoGrossSales
    FROM factsales as fs
    INNER JOIN dimdate as dd 
        ON fs.datekey = dd.datekey
    WHERE fs.salesstatus = 'completed'
        AND dd.calendarYear = 2025
    GROUP BY fs.PromotionKey
),

-- CTE 2- Company's Total Sales

CompanyTotalSales AS (
    SELECT sum(ps.PromoGrossSales) as TotalCompanySales
    FROM PromotionSales as ps
),

-- CTE 3- Promotion Performance
PromotionPerformance AS (
    SELECT 
        ps.promotionkey,
        ps.totalOrders,
        ps.PromoGrossSales,
        cts.totalCompanySales,
        -- AverageOrderValue
        CAST(ps.PromoGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(ps.totalOrders AS DECIMAL(18,4)),0) AS avgOrderValue,
        
        -- PromotionContributionPct
        CAST(ps.PromoGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(cts.totalCompanySales AS DECIMAL(18,4)),0)*100 AS PromoSalesContributionPct,

        -- Rank Promotion on Promotion Gross Sales
        RANK()OVER(ORDER BY ps.PromoGrossSales DESC) AS PromoRank

    FROM PromotionSales AS ps
    CROSS JOIN CompanyTotalSales AS cts

)
-- FINAL SELECT
    SELECT  dp.promotionId,
            dp.promotionName,
            dp.promotionType,

            pp.totalOrders,
            ROUND(pp.promoGrossSales,2) AS PromotionGrossSales,
            ROUND(pp.avgOrderValue,2) AS avgOrderValue,
           
            ROUND(pp.totalCompanySales,2) AS CompanyTotalSales,
            ROUND(pp.promoSalesContributionPct,2) AS promoSalesContributionPct,

            pp.promoRank

    FROM PromotionPerformance AS pp
    INNER JOIN DimPromotion AS dp
        ON pp.PromotionKey = dp.PromotionKey
    WHERE pp.promoRank <=5
    ORDER BY pp.promoRank,pp.promoGrossSales DESC;

    