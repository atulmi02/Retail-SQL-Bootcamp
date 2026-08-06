/*
===============================================================================
Business Requirement : BR #21 - Executive Dashboard Dataset
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : Description :
This report provides an executive dashboard dataset for PowerBi to analyze business performance by consolidating Sales, Customer, Promotion, Return, Product, Region, and Trend KPIs into a single reporting dataset.
*/
-- CTE 1 - BaseSales
WITH BaseSales AS (
    SELECT
        fs.dateKey,
        dd.CalendarYear,
        dd.CalendarMonth,
        dd.MonthName,
        
        fs.ProductKey,
        dp.ProductID,
        dp.ProductName,
        dp.category,

        fs.CustomerKey,

        fs.PromotionKey,
        fs.StoreKey,
        ds.region,

        fs.OrderNumber,
        fs.SalesAmount,
        fs.SalesQuantity

    FROM factsales AS fs
    INNER JOIN dimdate AS dd
        ON fs.DateKey = dd.DateKey
    INNER JOIN dimproduct AS dp
        ON fs.ProductKey = dp.ProductKey
    INNER JOIN dimstore AS ds
        ON fs.StoreKey = ds.StoreKey
    WHERE fs.SalesStatus = 'completed'
),

-- CTE 2- DashboardSummary
DashboardSummary AS (
    SELECT
        
        bs.CalendarYear,
        bs.CalendarMonth,
        bs.MonthName,
        bs.region,
        bs.StoreKey,
        bs.ProductKey,
        bs.ProductID,
        bs.ProductName,
        bs.category,

        -- GrossSales
        SUM(bs.SalesAmount) AS GrossSales,

        -- TotalOrders
        COUNT(DISTINCT bs.OrderNumber) AS TotalOrders,

        -- TotalSoldQty
        SUM(bs.SalesQuantity) AS TotalSoldQty,

        -- ActiveCustomer
        COUNT(DISTINCT bs.CustomerKey) AS ActiveCustomers,

        -- PromotionSales
        SUM(
            CASE 
                WHEN bs.PromotionKey IS NOT NULL 
                    AND bs.PromotionKey > 0 
                THEN bs.SalesAmount  
                ELSE 0
            END
        ) AS PromotionSales

    FROM BaseSales AS bs
    GROUP BY 
        bs.CalendarYear,
        bs.CalendarMonth,
        bs.MonthName,
        bs.region,
        bs.ProductID,
        bs.ProductName,
        bs.category,
        bs.StoreKey,
        bs.ProductKey
       
),

-- CTE 3- DashboardMetrics
DashboardMetrics AS (
    SELECT
        
        ds.CalendarYear,
        ds.CalendarMonth,
        ds.MonthName,
        ds.region,
        ds.ProductID,
        ds.ProductName,
        ds.category,
        ds.TotalOrders,
        ds.GrossSales,
        ds.TotalSoldQty,
        ds.ActiveCustomers,
        ds.PromotionSales,
        ds.StoreKey,
        ds.ProductKey,
        

        -- AverageOrderValue
        CAST(ds.GrossSales AS DECIMAL(18,4))
        /
        NULLIF(ds.TotalOrders,0) AS AvgOrderValue,

        -- RevenuePerCustomer
        CAST(ds.GrossSales AS DECIMAL(18,4))
        /
        NULLIF(ds.ActiveCustomers,0) AS RevenuePerCustomer

    FROM DashboardSummary AS ds

),

-- CTE 4- DashboardTrend
DashboardTrend AS (
    SELECT
        
        dm.CalendarYear,
        dm.CalendarMonth,
        dm.MonthName,
        dm.region,
        dm.ProductID,
        dm.ProductName,
        dm.category,
        dm.TotalOrders,
        dm.GrossSales,
        dm.TotalSoldQty,
        dm.ActiveCustomers,
        dm.PromotionSales,
        dm.AvgOrderValue,
        dm.RevenuePerCustomer,
        dm.StoreKey,
        dm.ProductKey,
        
        -- PrevMonthSales
        LAG(dm.GrossSales) OVER (
            PARTITION BY 
                    dm.storeKey,
                    dm.ProductKey
            ORDER BY 
                    dm.CalendarYear,
                    dm.CalendarMonth
        ) AS PrevMonthSales,

        -- PrevYearSales
        LAG(dm.GrossSales,12) OVER (
            PARTITION BY 
                    dm.storeKey,
                    dm.ProductKey
            ORDER BY 
                    dm.CalendarYear,
                    dm.CalendarMonth
        ) AS PrevYearSales,

        -- ForcastBaseLine
        AVG(dm.GrossSales) OVER ( 
             PARTITION BY 
                    dm.StoreKey,
                    dm.ProductKey
            ORDER BY 
                    dm.CalendarYear,
                    dm.CalendarMonth
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW 
        ) AS ForecastBaseLine

    FROM DashboardMetrics AS dm
),

-- CTE 5- GrowthTrend
GrowthTrend AS (
    SELECT
        
        dt.CalendarYear,
        dt.CalendarMonth,
        dt.MonthName,
        dt.region,
        dt.ProductID,
        dt.ProductName,
        dt.category,
        dt.TotalOrders,
        dt.GrossSales,
        dt.TotalSoldQty,
        dt.ActiveCustomers,
        dt.PromotionSales,
        dt.AvgOrderValue,
        dt.RevenuePerCustomer,
        dt.PrevMonthSales,
        dt.PrevYearSales,
        dt.ForecastBaseline,
        dt.StoreKey,
        dt.ProductKey,
        

        -- MoMGrowth
        1.0*(dt.GrossSales - dt.PrevMonthSales)
        /
        NULLIF(dt.PrevMonthSales,0)
        *100
        AS MoMGrowth,

        -- YoYGrowth
        1.0*(dt.GrossSales - dt.PrevYearSales)
        /
        NULLIF(dt.PrevYearSales,0)
        *100
        AS YoYGrowth
    FROM DashboardTrend AS dt
)

SELECT
        gt.CalendarYear,
        gt.CalendarMonth,
        gt.MonthName,
        gt.region,
        gt.ProductID,
        gt.ProductName,
        gt.category,
        gt.TotalOrders,
        gt.StoreKey,
        gt.ProductKey,
        ROUND(gt.GrossSales,2) AS GrossSales,
        gt.TotalSoldQty,
        gt.ActiveCustomers,
        ROUND(gt.PromotionSales,2) AS PromotionSales,
        ROUND(gt.AvgOrderValue,2) AS AvgOrderValue,
        ROUND(gt.RevenuePerCustomer,2) AS RevenuePerCustomer,
        ROUND(gt.PrevMonthSales,2) AS PrevMonthSales,
        ROUND(gt.PrevYearSales,2) AS PrevYearSales,
        ROUND(gt.ForecastBaseline,2) AS ForecastBaseline,
        ROUND(gt.MoMGrowth,2) AS MoMGrowth,
        ROUND(gt.YoYGrowth,2) AS YoYGrowth

FROM GrowthTrend AS gt
ORDER BY 
        gt.CalendarYear DESC,
        gt.CalendarMonth

-- ==================== Verfiy dataset ================
/*
SELECT
    gt.CalendarYear,
    gt.CalendarMonth,
    gt.Region,
    gt.StoreKey,
    gt.ProductKey,
    gt.GrossSales AS DashboardSales,
    SUM(bs.SalesAmount) AS SourceSales
FROM GrowthTrend gt
JOIN BaseSales bs
    ON gt.CalendarYear = bs.CalendarYear
   AND gt.CalendarMonth = bs.CalendarMonth
   AND gt.Region = bs.Region
   AND gt.StoreKey = bs.StoreKey
   AND gt.ProductKey = bs.ProductKey
GROUP BY
    gt.CalendarYear,
    gt.CalendarMonth,
    gt.Region,
    gt.StoreKey,
    gt.ProductKey,
    gt.GrossSales
HAVING gt.GrossSales <> SUM(bs.SalesAmount);
*/