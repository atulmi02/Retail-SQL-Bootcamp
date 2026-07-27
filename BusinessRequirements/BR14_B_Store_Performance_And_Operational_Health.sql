/*
===============================================================================
Business Requirement : BR #14 B - Store Performance & Operational Health
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
),

/*
=============== BR #14_B Starts Here =========
*/
-- CTE 4 - StoreHealthSummary
StoreHealthSummary AS (
    SELECT
        smt.StoreKey,
        
        -- Total Growth Months - Count months where sales increased compared to previous month
        SUM(
            CASE 
                WHEN smt.MoMGrowth > 0 Then 1
                ELSE 0
            END
        ) AS TotalGrowthMonths,

        -- Total Decline Months - -- Count months where sales decreased compared to previous month
        SUM(
            CASE 
                WHEN smt.MoMGrowth < 0 Then 1
                ELSE 0
            END
        ) AS TotalDeclineMonths,

        -- Average MOM Growth
        AVG(smt.MoMGrowth) AS AvgMoMGrowth,

        -- Best Monthly Rank
        MIN(smt.StoreRank) AS BestMonthRank,

        -- Worst Monthly Rank
        MAX(smt.StoreRank) AS WorstMonthRank,

        -- Total Gross Sales
        SUM(smt.GrossSales) AS TotalGrossSaLes
    FROM StoreMonthlyTrend AS smt
    GROUP BY smt.storeKey
),

-- CTE 5- StorePerformanceClassification
StorePerformanceClassification AS (
    SELECT 
        shs.storeKey,
        shs.TotalGrowthMonths,
        shs.TotalDeclineMonths,
        shs.AvgMoMGrowth,
        shs.BestMonthRank,
        shs.WorstMonthRank,
        shs.TotalGrossSaLes,
        CASE
            WHEN shs.AvgMoMGrowth < -5 OR shs.TotalDeclineMonths > 6 
                THEN 'Need Attention'

            WHEN shs.TotalGrowthMonths >=8 AND shs.AvgMoMGrowth >0 
                THEN 'Growing Store'

            WHEN shs.TotalDeclineMonths >=8 AND shs.AvgMoMGrowth < 0 
                THEN 'Declining Store'
    
            ELSE 'Stable'
        END AS StoreStatus
    FROM StoreHealthSummary AS shs
)
-- FINAL SELECT
SELECT 
    ds.StoreID,
    ds.StoreName,
    ds.City,
    spc.TotalGrowthMonths,
    spc.TotalDeclineMonths,
    ROUND(spc.AvgMoMGrowth,2) AS AvgMoMGrowth,
    spc.BestMonthRank,
    spc.WorstMonthRank,
    ROUND(spc.TotalGrossSaLes,2) AS TotalGrossSaLes,
    spc.StoreStatus
FROM StorePerformanceClassification AS spc
INNER JOIN DimStore AS ds
    ON spc.storeKey = ds.storeKey
ORDER BY 
    CASE spc.StoreStatus
        WHEN 'Need Attention' THEN 1
        WHEN 'Declining Store' THEN 2
        WHEN 'Stable' THEN 3
        WHEN 'Growing Store' THEN 4
    END,
spc.AvgMoMGrowth ASC,
spc.TotalDeclineMonths DESC,
spc.TotalGrossSaLes DESC;
