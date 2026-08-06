/*
===============================================================================
Business Requirement : BR #20 - Executive Summary Report
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : Description :
This report provides an executive summary of yearly business performance by consolidating Sales, Customer, Promotion, Return, Product, Region, and Trend KPIs into a single reporting dataset.
*/

-- BaseTable - FactSales
WITH BaseSales AS (
    SELECT 
        dd.CalendarYear,
        dd.CalendarMonth,
        
        fss.CustomerKey,
        fss.ProductKey,
        fss.StoreKey,
        fss.PromotionKey,
        fss.salesAmount,
        fss.OrderNumber,
        fss.SalesQuantity
    FROM FactSales AS fss
    INNER JOIN DimDate AS dd
        ON fss.dateKey = dd.dateKey
    WHERE fss.salesStatus = 'completed'
    
),
-- CTE 1 - SalesSummary
SalesSummary AS (
    SELECT
        fs.calendarYear,

        -- GrossSales
        SUM(fs.salesAmount) AS GrossSales,
        
        -- TotalOrders
        COUNT(DISTINCT fs.OrderNumber) AS TotalOrders,
        
        -- QuantitySold
        SUM(fs.SalesQuantity) AS TotalQtySold,
        
        -- AverageOrderValue
        CAST(
            1.0*SUM(fs.salesAmount)
            /
            NULLIF(COUNT(DISTINCT fs.OrderNumber),0) 
        AS DECIMAL(18,2))
        AS AverageOrderValue
        
    FROM BaseSales AS fs
    GROUP BY fs.CalendarYear
),

-- CTE 2 - CustomerSummary
CustomerSummary AS (
    SELECT
        fs.calendarYear,
        -- ActiveCustomer
        COUNT(DISTINCT fs.customerKey) AS ActiveCustomer,

        -- RevenuePerCustomer
        CAST(
            1.0*SUM(fs.salesAmount)
            /
            NULLIF(COUNT(DISTINCT fs.customerKey),0) 
        AS DECIMAL(18,2)) 
        AS RevenuePerCustomer

    FROM BaseSales AS fs
    GROUP BY fs.calendarYear
),

-- CTE 3 - PromotionSummary
PromotionSummary AS (
    SELECT
        fs.calendarYear,
        -- GrossSales
        SUM(
            CASE 
                WHEN fs.PromotionKey IS NOT NULL AND fs.PromotionKey > 0 THEN fs.SalesAmount
                ELSE 0
            END 
        ) AS PromotionSales

    FROM BaseSales AS fs
    GROUP BY fs.calendarYear
),

-- CTE 4 - ProductSummary 
ProductSummary AS (
    SELECT
        fs.calendarYear,
        dp.productKey,
        dp.productName,
        SUM(fs.salesAmount) AS GrossSales          
    FROM BaseSales AS fs
    INNER JOIN dimproduct AS dp
        ON fs.ProductKey = dp.ProductKey
    GROUP BY fs.calendarYear,
            dp.productKey,
            dp.productName
),
-- ProductRank
ProductRank AS (
    SELECT
         ps.CalendarYear,
         ps.productKey,
         ps.GrossSales AS ProductGrossSales,
         ps.productName,
        -- Rank Top Product
        ROW_NUMBER()OVER(
            PARTITION BY ps.CalendarYear ORDER BY ps.GrossSales DESC) AS ProductRank -- filter rank = 1 in final output

    FROM ProductSummary AS ps
),

-- CTE 5 - Category Summary
CategorySummary AS (
    SELECT
        fs.calendarYear,
        dp.category,

        SUM(fs.salesAmount) AS GrossSales          
    
    FROM BaseSales AS fs
    INNER JOIN dimproduct AS dp
        ON fs.ProductKey = dp.ProductKey
    
    GROUP BY fs.calendarYear,
            dp.category
),
CategoryRank AS (
    SELECT
        cs.CalendarYear,
        cs.category,
        cs.GrossSales AS CategoryGrossSales,
        
        -- Category Rank
        ROW_NUMBER()OVER(
            PARTITION BY cs.CalendarYear ORDER BY cs.GrossSales DESC) AS CategoryRank -- Filter rank = 1 in output

    FROM CategorySummary AS cs
),

-- CTE 6.1 - RegionSummary
RegionSummary AS (
    SELECT
        fs.calendarYear,
        ds.region,

        SUM(fs.salesAmount) AS GrossSales          
    
    FROM BaseSales AS fs 
    INNER JOIN dimstore AS ds
        ON fs.StoreKey = ds.StoreKey
    
    GROUP BY fs.calendarYear,
            ds.Region
),
-- CTE 6.2 - RegionRank
RegionRank AS (
    SELECT
        rs.CalendarYear,
        rs.region,
        rs.GrossSales AS RegionGrossSales,
        
        -- Region Rank
        ROW_NUMBER()OVER(
            PARTITION BY rs.CalendarYear ORDER BY rs.GrossSales DESC) AS RegionRank -- Filter RegionRank = 1 in Final Output
            
    FROM RegionSummary AS rs
),
-- Trend KPIs
-- CTE 7.1 - MonthlySales: Calculate monthly sales
MonthlySales AS (
    SELECT
        fs.calendarYear,
        fs.CalendarMonth,
        
        
        CAST(SUM(fs.salesAmount) AS DECIMAL(18,4)) AS GrossSales,
        
        SUM(fs.SalesQuantity) AS QuantitySold,
        
        COUNT(DISTINCT fs.OrderNumber) AS TotalOrders
    
    FROM BaseSales AS fs
    GROUP BY 
             fs.calendarYear, 
             fs.CalendarMonth
            
),

-- CTE 7.2 - SalesTrend : Calculate 3 Month Moving Average, Running Total, Previous Month Sales, and Previous Year Sales.
SalesTrend AS (
    SELECT 
        ms.CalendarYear,
        ms.CalendarMonth,
        
        ms.GrossSales,
        ms.QuantitySold,
        ms.TotalOrders,

        -- Previous Month Sales
        LAG(ms.GrossSales) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth) AS PreviousMonthSales,

        -- Previous Year Sales
        LAG(ms.GrossSales,12) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth) AS PreviousYearSales,

        -- Moving Average (3 months)
        AVG(ms.GrossSales) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage3Month

    FROM MonthlySales AS ms
),

-- CTE 7.3 - GrowthMetrics - Calculate MoMGrowth%, YoYGrowth%, AvgOrderValue, TrenDirection, ForecastBaseline

GrowthMetrics AS (
    SELECT
        st.CalendarYear,
        st.CalendarMonth,
        
       
        st.PreviousMonthSales,
        st.PreviousYearSales,
        st.MovingAverage3Month,

        -- MoMGrowth%
        1.0*(st.GrossSales - st.PreviousMonthSales)
        /
        NULLIF(st.PreviousMonthSales,0)
        *100
        AS MoMGrowth,

        -- YoYGrowth%
        1.0*(st.GrossSales - st.PreviousYearSales)
        /
        NULLIF(st.PreviousYearSales,0)
        *100
        AS YoYGrowth

    FROM SalesTrend AS st
),
-- CTE 7.4 - LatestTrend - Get Latest MoMGrowth and YoYGrowth
LatestTrend AS (
    SELECT 
        gm.CalendarYear,
        gm.CalendarMonth,
      
        ROUND(gm.PreviousMonthSales,2) AS PreviousMonthSales,
        ROUND(gm.PreviousYearSales,2) AS PreviousYearSales,
        ROUND(gm.MovingAverage3Month,2) AS ForecastBaseline,
        ROUND(gm.MoMGrowth,2) AS MoMGrowth,
        ROUND(gm.YoYGrowth,2) AS YoYGrowth,
        
        ROW_NUMBER()OVER (PARTITION BY gm.CalendarYear ORDER BY  gm.CalendarMonth DESC) AS latestMonthRank -- FILTER BY latestMonthRank = 1 in Output

    FROM GrowthMetrics AS gm
)

-- FINAL DASHBOARD

SELECT
    -- SalesSummary output
    ss.calendarYear,
    ss.GrossSales,
    ss.TotalOrders,
    ss.TotalQtySold,
    ss.AverageOrderValue,

    -- CustomerSummary output
    cs.ActiveCustomer,
    cs.RevenuePerCustomer,

    -- PromotionSummary output
    ps.PromotionSales,

    -- ProductSummary
    prs.productKey,
    prs.productName,
    prs.ProductGrossSales,
    

    -- CategorySummary
    cr.category,
    cr.CategoryGrossSales,
    

    -- RegionSummary
    rr.region,
    rr.RegionGrossSales,
    
    -- TrendSummary
    lt.PreviousYearSales,
    lt.YoYGrowth,
    lt.PreviousMonthSales,
    lt.MoMGrowth,
    lt.ForecastBaseline
    
FROM SalesSummary AS ss

INNER JOIN CustomerSummary AS cs
    ON ss.calendarYear = cs.calendarYear
INNER JOIN PromotionSummary AS ps
    ON ss.calendarYear = ps.calendarYear
INNER JOIN ProductRank AS prs
    ON ss.calendarYear = prs.calendarYear
INNER JOIN CategoryRank AS cr
    ON ss.calendarYear = cr.calendarYear
INNER JOIN RegionRank AS rr
    ON ss.calendarYear = rr.calendarYear
INNER JOIN LatestTrend AS lt
    ON ss.calendarYear = lt.calendarYear

WHERE lt.latestMonthRank = 1
    AND rr.RegionRank = 1
    AND cr.CategoryRank = 1
    AND prs.ProductRank = 1

ORDER BY ss.calendarYear DESC;
