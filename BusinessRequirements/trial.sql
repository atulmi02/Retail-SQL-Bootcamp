With CustomerGrossSales AS (
    SELECT fs.customerKey,
            COUNT(DISTINCT fs.orderNumber) AS TotalOrder,
            SUM(fs.salesAmount) AS GrossSales,
            MIN(dd.fulldate) AS Firstdate,
            MAX(dd.fulldate) AS Lastdate
    FROM FACTSALES AS fs
    INNER JOIN DIMDATE AS dd 
        ON fs.datekey = dd.datekey
    WHERE fs.salesstatus = 'completed' 
        AND dd.calendaryear = 2025
    GROUP BY fs.customerkey
),
-- CTE 2- CompanyTotalSales

CompanyTotalSales AS (  
    SELECT SUM(GrossSales) AS TotalCompanySales
    FROM CustomerGrossSales 
)
SELECT 
            cgs.customerKey,

            CAST(cgs.totalOrder AS DECIMAL (18,4)) AS PurchaseFrequency,
            
            CAST(cgs.grossSales AS DECIMAL(18,4)) AS grossSales,
            
            cgs.firstDate,
            cgs.lastDate,
            
            -- Active days 
            DATEDIFF(cgs.lastdate,cgs.firstdate) AS activeDays,
            
            -- AverageOrderValue
            CAST(cgs.grossSales AS DECIMAL(18,4)) 
            /
            NULLIF( CAST(cgs.totalOrder AS DECIMAL (18,4)),0) AS avgOrderValue,

            -- CustomerSalesContributionPct
            CAST(cgs.grossSales AS DECIMAL(18,4)) 
            /
            NULLIF(CAST(cts.totalcompanysales AS DECIMAL(18,4)),0)
            AS customerContributionPct,

            -- CustomerRank
            RANK()OVER(ORDER BY cgs.grossSales DESC) AS customerRank

    FROM CustomerGrossSales AS cgs
    CROSS JOIN CompanyTotalSales AS cts;