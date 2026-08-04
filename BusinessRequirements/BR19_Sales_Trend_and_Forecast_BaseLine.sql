/*
===============================================================================
Business Requirement : BR #19 - Sales Trend and Forecast Baseline
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides a baseline for sales trend and forecast analysis.
*/

-- CTE 1 - MonthlySales: Calculate monthly sales
WITH MonthlySales AS (
    SELECT
        dd.CalendarYear,
        dd.CalendarMonth,
        dd.monthName,
        
        CAST(SUM(fs.salesAmount) AS DECIMAL(18,4)) AS GrossSales,
        
        SUM(fs.SalesQuantity) AS QuantitySold,
        
        COUNT(DISTINCT fs.OrderNumber) AS TotalOrders
    
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.DateKey = dd.DateKey
    
    WHERE fs.SalesStatus = 'Completed'
    GROUP BY 
             dd.CalendarYear, 
             dd.CalendarMonth,
             dd.monthName
),

-- CTE 2 - SalesTrend : Calculate 3 Month Moving Average, Running Total, Previous Month Sales, and Previous Year Sales.
SalesTrend AS (
    SELECT 
        ms.CalendarYear,
        ms.CalendarMonth,
        ms.monthName,
        ms.GrossSales,
        ms.QuantitySold,
        ms.TotalOrders,

        -- Running Total 
        SUM(ms.GrossSales) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth) AS RunningTotalSales,

        -- Previous Month Sales
        LAG(ms.GrossSales) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth) AS PreviousMonthSales,

        -- Previous Year Sales
        LAG(ms.GrossSales,12) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth) AS PreviousYearSales,

        -- Moving Average (3 months)
        AVG(ms.GrossSales) OVER (ORDER BY ms.CalendarYear, ms.CalendarMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage3Month,

        -- AverageOrderValue
        1.0*ms.GrossSales
        /
        NULLIF(ms.TotalOrders,0) AS AverageOrderValue

    FROM MonthlySales AS ms
),

-- CTE 3 - GrowthMetrics - Calculate MoMGrowth%, YoYGrowth%, AvgOrderValue, TrenDirection, ForecastBaseline

GrowthMetrics AS (
    SELECT
        st.CalendarYear,
        st.CalendarMonth,
        st.monthName,
        st.GrossSales,
        st.QuantitySold,
        st.TotalOrders,
        st.AverageOrderValue,
        st.RunningTotalSales, 
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
)

-- FINAL SELECT
SELECT 
    gm.CalendarYear,
    gm.CalendarMonth,
    gm.monthName,
    
    gm.QuantitySold,
    gm.TotalOrders,
    ROUND(gm.GrossSales,2) AS GrossSales,

    ROUND(gm.AverageOrderValue,2) AS AverageOrderValue,
    ROUND(gm.RunningTotalSales,2) AS RunningTotalSales,
    ROUND(gm.PreviousMonthSales,2) AS PreviousMonthSales,
    ROUND(gm.PreviousYearSales,2) AS PreviousYearSales,
    ROUND(gm.MovingAverage3Month,2) AS ForecastBaseline,
    ROUND(gm.MoMGrowth,2) AS MoMGrowth,
    ROUND(gm.YoYGrowth,2) AS YoYGrowth,

    CASE
        WHEN gm.MoMGrowth > 0 THEN 'Growing'
        WHEN gm.MoMGrowth < 0 THEN 'Declining'
        ELSE 'Stable'
    END AS TrendDirection


FROM GrowthMetrics AS gm
ORDER BY gm.CalendarYear,
        gm.CalendarMonth