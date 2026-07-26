/*
===============================================================================
Business Requirement : BR #12 - Monthly Sales Trend Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Monthly Sales Trend Analysis by identifying  previous month sales, MOM Growth, Cumulative Sales
*/
-- CTE 1- MonthlySales
With MonthlySales AS (
    SELECT
            dd.calendarMonth,
            dd.monthName,
            COUNT(DISTINCT orderNumber) AS totalOrders,
            CAST(SUM(fs.salesAmount) AS DECIMAL(18,4)) AS grossSales
    FROM factSales AS fs
    INNER JOIN dimDate AS dd
        ON fs.dateKey = dd.dateKey 
    WHERE fs.salesStatus = 'completed' 
        AND dd.calendarYear = 2025 
    GROUP BY 
        dd.calendarMonth,dd.MonthName
),

-- CTE 2- MonthlyPerformance
MonthlyPerformance AS (
    SELECT
        ms.calendarMonth,
        ms.monthName,
        ms.totalOrders,

        -- AverageOrderValue
        ms.grossSales
        /
        NULLIF(ms.totalOrders,0)
        AS AvgOrderValue,

         ms.grossSales,

        -- PreviousMonthSales
        lag(ms.grossSales)OVER(ORDER BY ms.calendarMonth) AS prevMonthSales,

        -- RunningSales
        SUM(ms.grossSales)OVER(ORDER BY ms.calendarMonth
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningSales
        
    FROM monthlySales AS ms
),

-- CTE 3- MonthlyTrend
MonthlyTrend AS (
    SELECT
        mp.calendarMonth,
        mp.monthName,
        mp.totalOrders,
        mp.AvgOrderValue,
        mp.grossSales,
        mp.prevMonthSales,

        -- SalesDifference
        CASE 
            WHEN 
                mp.prevMonthSales IS NULL 
                    THEN mp.grossSales
            ELSE
                mp.grossSales
                -
                mp.prevMonthSales
        END AS salesDiff,
                
        -- MOM Growth%
        CASE 
            WHEN mp.prevMonthSales IS NULL OR mp.prevMonthSales = 0 THEN 0
            ELSE
                (mp.grossSales
                -
                NULLIF(mp.prevMonthSales,0))
                /
                NULLIF(mp.prevMonthSales,0)
                *100 
            END AS MOMgrowth,

        mp.runningSales AS runningSales

    FROM MonthlyPerformance AS mp
)

-- FINAL SELECT
SELECT  
        mg.calendarMonth,
        mg.monthName,
        mg.totalOrders,
        ROUND(mg.AvgOrderValue,2) AS AvgOrderValue,
        ROUND(mg.grossSales,2) AS GrossSales,
        ROUND(mg.prevMonthSales,2) AS PrevMonthSales,
        ROUND(mg.salesDiff,2) AS SalesDifference,
        ROUND(mg.momGrowth,2) AS MOMgrowth,
        ROUND(mg.runningSales,2) AS RunningSales
FROM monthlyTrend AS mg;
