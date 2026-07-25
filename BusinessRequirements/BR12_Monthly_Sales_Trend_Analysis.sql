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
            COUNT(DISTINCT orderNumber) AS totalOrders,
            SUM(fs.salesAmount) AS grossSales
    FROM factSales AS fs
    INNER JOIN dimDate AS dd
        ON fs.dateKey = dd.dateKey 
    WHERE fs.salesStatus = 'completed' 
        AND dd.calendarYear = 2025 
    GROUP BY 
        dd.calendarMonth
),

-- CTE 2- MonthlyPerformance
MonthlyPerformance AS (
    SELECT
        ms.calendarMonth,
        ms.totalOrders,

        -- AverageOrderValue
        CAST(ms.grossSales AS DECIMAL(18,4))
        /
        CAST(ms.totalOrders AS DECIMAL(18,4))
        AS AOV,

         ms.grossSales,

        -- PreviousMonthSales
        lag(ms.grossSales)OVER(ORDER BY ms.calendarMonth) AS prevMonthSales,

        -- RunningSales
        SUM(ms.grossSales)OVER(ORDER BY ms.calendarMonth) AS runningSales
        
    FROM monthlySales AS ms
),

-- CTE 3- MonthlyGrowth
MonthlyGrowth AS (
    SELECT
        mp.calendarMonth,
        mp.totalOrders,
        mp.AOV,
        mp.grossSales,
        mp.prevMonthSales,

        -- SalesDifference
        CAST(mp.grossSales AS DECIMAL(18,4))
        -
        IFNULL(CAST(mp.prevMonthSales AS DECIMAL(18,4)),0) AS salesDiff,
        
        -- MOM Growth%
        CAST(mp.grossSales AS DECIMAL(18,4))
        -
        IFNULL(CAST(mp.prevMonthSales AS DECIMAL(18,4)),0)
        /
        IFNULL(CAST(mp.prevMonthSales AS DECIMAL(18,4)),0)
        *100 AS MOMgrowth,

        CAST(mp.runningSales AS DECIMAL(18,4)) AS runningSales

    FROM MonthlyPerformance AS mp
)

-- FINAL SELECT
SELECT  
        mg.calendarMonth,
        dd.monthName,
        mg.totalOrders,
        ROUND(mg.AOV,2) AS AvgOrderValue,
        ROUND(mg.grossSales,2) AS GrossSales,
        ROUND(mg.prevMonthSales,2) AS PrevMonthSales,
        ROUND(mg.salesDiff,2) AS SalesDifference,
        ROUND(mg.momGrowth,2) AS MOMgrowth,
        ROUND(mg.runningSales,2) AS RunningSales
FROM monthlyGrowth AS mg
INNER JOIN dimDate AS dd
    ON mg.calendarMonth = dd.CalendarMonth
ORDER BY dd.CalendarMonth;
