/*
===============================================================================
Business Requirement : BR #12 - Product Sales Trend and Growth Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Product Sales Trend and Growth Analysis by identifying previous month sales, MOM Growth, Cumulative Sales.
*/
-- CTE 1 - ProductMonthlySales
WITH ProductMonthlySales AS (
    SELECT
        fs.ProductKey,
        dd.calendarMonth,
        dd.monthName,

        COUNT(DISTINCT fs.orderNumber) AS TotalOrders,

        CAST(SUM(fs.SalesAmount) AS DECIMAL(18,4)) AS GrossSales

    FROM factsales AS fs
    INNER JOIN dimdate AS dd
        ON fs.DateKey = dd.DateKey
    WHERE fs.SalesStatus = 'completed'
        AND dd.CalendarYear = 2025
    GROUP BY fs.ProductKey,dd.CalendarMonth,dd.MonthName
),
-- CTE 2- ProductPerformance
ProductPerformance AS (
    SELECT 
        pms.ProductKey,
        pms.calendarMonth,
        pms.monthName,
        
        pms.totalOrders,
        -- AvgOrderValue
        pms.grossSales
        /
        NULLIF(pms.totalOrders,0) AS AvgOrderValue,

        pms.grossSales,
        -- PrevMonthSales
        LAG(pms.grossSales) OVER 
        (PARTITION BY pms.ProductKey ORDER BY pms.calendarMonth) AS PrevMonthSales,

        -- Running Product Sales
        SUM(pms.grossSales) OVER 
        (PARTITION BY pms.ProductKey ORDER BY pms.calendarMonth) AS RunningProductSales

    FROM ProductMonthlySales AS pms
)
-- CTE 3 - ProductGrowth
-- ProductGrowth AS (
    SELECT 
        pp.ProductKey,
        pp.calendarMonth,
        pp.monthName,
        pp.totalOrders,
        pp.AvgOrderValue,
        pp.grossSales,
        pp.prevMonthSales,

        -- SalesDifference
        CASE
            WHEN pp.prevMonthSales IS NULL OR pp.prevMonthSales = 0 THEN pp.grossSales
            ELSE     
            pp.prevMonthSales    
            -
            pp.grossSales
        END AS salesDifference,

        -- MoMgrowth%
        CASE
            WHEN pp.prevMonthSales IS NULL THEN 0
            ELSE 
                (pp.prevMonthSales 
                -
                pp.grossSales)
                /
                NULLIF(pp.prevMonthSales,0) 
                * 100
        END AS MOMGrowth,

        pp.runningProductSales
    FROM ProductPerformance AS pp

