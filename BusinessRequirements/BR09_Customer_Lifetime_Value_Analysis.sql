/*
===============================================================================
Business Requirement : BR #09 - Customer Lifetime Value
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Customer performance by identifying best-performing Customer based on gross sales and measuring each customer's contribution to company's total sales
*/
-- CTE 1 - CustomeGrossSales
With CustomerGrossSales AS (
    SELECT fs.customerKey,
            COUNT(DISTINCT fs.orderNumber) AS TotalOrders,
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
),

-- CTE 3- CustomerPerformace
CustomerPerformance AS (
    SELECT 
            cgs.customerKey,
            cgs.TotalOrders  AS PurchaseFrequency,
            cgs.grossSales  AS grossSales,
            cgs.firstDate,
            cgs.lastDate,
            
            -- Active days 
            DATEDIFF(cgs.lastdate,cgs.firstdate)+1 AS activeDays,
            
            -- AverageOrderValue
            CAST(cgs.grossSales AS DECIMAL(18,4)) 
            /
            NULLIF( CAST(cgs.TotalOrders AS DECIMAL (18,4)),0) AS avgOrderValue,

            -- CustomerSalesContributionPct
            CAST(cgs.grossSales AS DECIMAL(18,4)) 
            /
            NULLIF(CAST(cts.totalcompanysales AS DECIMAL(18,4)),0)
            *100
            AS customerContributionPct,

            -- CustomerRank
            RANK()OVER(ORDER BY cgs.grossSales DESC) AS customerRank

    FROM CustomerGrossSales AS cgs
    CROSS JOIN CompanyTotalSales AS cts
    
)

-- FINAL SELECT
SELECT dc.customerId AS Customer_Id,
        dc.customerName AS Customer_Name,
        dc.email AS Email,
        dc.phone AS Phone,
        
        cp.firstDate AS First_Purchase,
        cp.lastDate AS Last_Purchase,
        cp.activeDays AS Active_Days,

        ROUND(cp.purchaseFrequency,2) AS Purchase_Frequency,
        ROUND(cp.GrossSales,2) AS CustomerGrossSales,
        ROUND(cp.avgOrderValue,2) AS Average_Order_Value,

        ROUND(cp.customerContributionPct,2) AS  Customer_Contribution_Pct,
        
        cp.customerRank

FROM CustomerPerformance AS cp
INNER JOIN DimCustomer AS dc
    ON cp.customerKey = dc.customerKey
ORDER BY cp.customerRank, cp.grossSales DESC;
