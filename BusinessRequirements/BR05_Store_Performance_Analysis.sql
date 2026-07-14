/*
===============================================================================
Business Requirement : BR #05 - Store Performance Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          :
The Sales Director wants to evaluate store performance for the calendar
year 2025.

The report identifies the best-performing stores based on Gross Sales,
Total Orders, Average Order Value, Sales Contribution Percentage,
and Store Rank.

Grain:
One row represents the annual sales performance of a single store
for the calendar year 2025.

Tables Used:
    • FactSales
    • DimStore
    • DimDate
==============================================================================

/*
CTE 1 - StoreGrossSales

Purpose

- Aggregate completed sales for each store in 2025.
- Calculate :
  - Gross Sales
  - Total Orders

*/
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
),

/*
CTE 3 - StorePerformance
*/
StorePerformance AS (
    SELECT 
            sgs.StoreKey,
            sgs.GrossSales,
            sgs.TotalOrders,
            -- Average Order Value = Gross Sales / Total Orders
            CAST(sgs.GrossSales AS DECIMAL(18,2))
            /
            NULLIF(sgs.TotalOrders,0) AS AverageOrderValue,
            -- Sales Contribution Percentage = Gross Sales / Total Company Sales * 100
            CAST(sgs.GrossSales AS DECIMAL(18,2))
            /
            NULLIF(CAST(cts.TotalCompanySales AS DECIMAL(18,2)),0)
            *100 AS SalesContributionPct,
            -- Store Rank based on Gross Sales
            RANK() OVER (ORDER BY sgs.GrossSales DESC) AS StoreRank
    FROM StoreGrossSales AS sgs
    CROSS JOIN CompanyTotalSales AS cts
)
SELECT 
        ds.StoreName,
        ds.StoreId,
        ds.City,
        ds.State,
        sp.GrossSales,
        sp.TotalOrders,
        ROUND(sp.AverageOrderValue,2) AS AverageOrderValue,
        ROUND(sp.SalesContributionPctage,2) AS SalesContributionPercentage,
        sp.StoreRank
FROM StorePerformance AS sp
INNER JOIN DimStore AS ds
    ON sp.StoreKey = ds.StoreKey
ORDER BY sp.StoreRank,
         sp.GrossSales DESC;