/*
===============================================================================
Business Requirement : BR #14 A- Store Sales Trend & Growth Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Store Sales Trend & Growth Analysis by identifying  previous month sales, MOM Growth, Cumulative Sales.
*/
-- CTE 1- StoreMonthlySales
WITH StoreMonthlySales AS (
    SELECT 
        dd.CalendarMonth,
        fs.StoreKey,
        dd.MonthName,
    COUNT(DISTINCT fs.OrderNumber) AS TotalOrders,
    CAST(SUM(fs.SalesAmount) AS DECIMAL(18, 4)) AS GrossSales
FROM factsales AS fs
    INNER JOIN dimdate AS dd 
        ON fs.DateKey = dd.DateKey
WHERE dd.CalendarYear = 2025
    AND fs.SalesStatus = 'completed'
GROUP BY 
        fs.StoreKey,
        dd.CalendarMonth,
        dd.MonthName
),
-- CTE 2- StorePerformance
StorePerformance AS (
    SELECT  
        sms.StoreKey,

        sms.CalendarMonth,
        sms.MonthName,
        
        sms.TotalOrders,

        -- AvgOrderValue
        sms.GrossSales 
        /
        NULLIF(sms.TotalOrders,0)
        AS AvgOrderValue,

        sms.GrossSales,
        
        -- PrevMonthSales
        LAG(sms.GrossSales) 
        OVER (PARTITION BY sms.StoreKey ORDER BY sms.CalendarMonth) AS PrevMonthSales,

        -- RunningSales
        SUM(sms.GrossSales) 
        OVER (PARTITION BY sms.StoreKey ORDER BY sms.CalendarMonth ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSales,

        -- Rank
        RANK() 
        OVER (PARTITION BY sms.calendarMonth ORDER BY sms.GrossSales DESC) AS StoreRank

    FROM StoreMonthlySales AS sms
),
-- CTE 3- StoreMonthlyTrend
StoreMonthlyTrend AS (
    SELECT
        sp.StoreKey,
        sp.CalendarMonth,
        sp.MonthName,
        
        sp.TotalOrders,
        sp.AvgOrderValue,
        sp.GrossSales,
        sp.PrevMonthSales,

        -- SalesDifference
        CASE 
            WHEN sp.PrevMonthSales IS NULL THEN sp.GrossSales
            ELSE 
                sp.GrossSales
                -
                sp.PrevMonthSales 
        END AS SalesDiff,

        -- MoMGrowth
        CASE
            WHEN sp.PrevMonthSales IS NULL THEN 0
            ELSE
                (sp.GrossSales
                -
                sp.PrevMonthSales)
                /
                sp.PrevMonthSales
                * 100
        END AS MoMGrowth,
        
        sp.RunningSales,
        sp.storeRank

    FROM StorePerformance AS sp
)

-- FINAL SELECT
SELECT 
        ds.storeID,
        ds.StoreName,
        ds.city,
        smt.CalendarMonth,
        smt.MonthName,
        
        smt.TotalOrders,
        ROUND(smt.AvgOrderValue,2) AS AvgOrderValue,
        ROUND(smt.GrossSales,2) AS GrossSales,
        ROUND(smt.PrevMonthSales,2) AS PrevMonthSales,
        ROUND(smt.SalesDiff,2) AS SalesDiff,
        ROUND(smt.MomGrowth,2) AS MoMGrowth,
        ROUND(smt.RunningSales,2) AS RunningSales,
        smt.StoreRank

FROM StoreMonthlyTrend AS smt
INNER JOIN dimstore AS ds
    ON smt.storeKey = ds.storeKey
WHERE smt.storeRank <=3 AND smt.calendarMonth = 3
ORDER BY ds.StoreName,smt.CalendarMonth;

