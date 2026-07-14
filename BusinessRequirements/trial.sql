With StoreGrossSales AS (
    SELECT 
        fs.StoreKey,
        Sum(fs.SalesAmount) AS GrossSales,
        Count(Distinct fs.OrderNumber) AS TotalOrders
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.DateKey = dd.DateKey
    WHERE dd.CalendarYear = 2025
        AND fs.salesStatus = 'completed' 
        GROUP BY fs.StoreKey
),

/*
CTE 2 - CompanyTotalSales
*/
CompanyTotalSales AS (
    SELECT 
        SUM(SalesAmount) AS TotalCompanySales
    FROM FactSales
)
/*
CTE 3 - StorePerformance
*/
    SELECT 
            sgs.StoreKey,
            sgs.GrossSales,
            sgs.TotalOrders,
            CAST(sgs.GrossSales AS DECIMAL(18,2))
            /
            sgs.TotalOrders AS AverageOrderValue,
            CAST(sgs.GrossSales AS DECIMAL(18,2))
            /
            NULLIF(CAST(cts.TotalCompanySales AS DECIMAL(18,2)),0)
            *100 AS SalesContributionPercentage,
            RANK() OVER (ORDER BY sgs.GrossSales DESC) AS StoreRank
    FROM StoreGrossSales AS sgs
    CROSS JOIN CompanyTotalSales AS cts