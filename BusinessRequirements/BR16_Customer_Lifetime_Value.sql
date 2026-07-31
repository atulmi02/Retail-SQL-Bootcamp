/*
===============================================================================
Business Requirement : BR #16 - Customer Lifetime Value
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
            cgs.TotalOrders  AS TotalOrders,
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
    
),
-- CTE 4- CustomerSegment
CustomerSegment AS (
    SELECT 
            cp.customerKey,
            cp.TotalOrders  AS TotalOrders,
            cp.grossSales  AS grossSales,
            cp.firstDate,
            cp.lastDate,
            cp.activeDays,
            cp.avgOrderValue,
            cp.customerContributionPct,
            cp.customerRank,

            -- Cumulative Contribution
            SUM(cp.customerContributionPct)
                OVER (ORDER BY cp.grossSales DESC
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeContribution,
            
            -- Top N % of Customers
            NTILE(5) OVER (ORDER BY cp.grossSales DESC) AS CustomerGroup

    FROM CustomerPerformance AS cp
)

-- FINAL SELECT
SELECT dc.customerId AS Customer_Id,
        dc.customerName AS Customer_Name,
        dc.email AS Email,
        dc.phone AS Phone,
        
        cs.firstDate AS First_Purchase,
        cs.lastDate AS Last_Purchase,
        cs.activeDays AS Active_Days,

        ROUND(cs.TotalOrders,2) AS TotalOrders,
        ROUND(cs.GrossSales,2) AS CustomerGrossSales,
        ROUND(cs.avgOrderValue,2) AS Average_Order_Value,

        ROUND(cs.customerContributionPct,2) AS  Customer_Contribution_Pct,
       
        ROUND(cs.CumulativeContribution,2) AS CumulativeContribution,
        cs.customerRank,
        
        -- Customer Segment
            CASE 
                WHEN cs.customerGroup = 1 THEN 'Platinum'
                WHEN cs.customerGroup = 2 THEN 'Gold'
                WHEN cs.customerGroup = 3 THEN 'Silver'
                ELSE 'Bronze'
            END AS CustomerSegment,

        -- Top N Customers
        CASE 
            WHEN cs.CustomerGroup = 5 THEN 'Bottom 20%'
            WHEN cs.CustomerGroup = 4 THEN '60% - 80%'
            WHEN cs.CustomerGroup = 3 THEN '40% - 60%'
            WHEN cs.CustomerGroup = 2 THEN '20% - 40%'
            WHEN cs.CustomerGroup = 1 THEN 'Top 20%'
        END AS CustomerGroup,

        -- ABC Classification
        CASE 
            WHEN cs.CumulativeContribution <= 80 THEN 'A'
            WHEN cs.CumulativeContribution <= 95 THEN 'B'
            ELSE 'C'
        END AS ABC_Classification

FROM CustomerSegment AS cs
INNER JOIN DimCustomer AS dc
    ON cs.customerKey = dc.customerKey
ORDER BY cs.customerRank, cs.grossSales DESC;
