/*
===============================================================================
Business Requirement : BR #11 - Customer Retention and Repeat Purchase
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Customer Retention and Repeat Purchase by identifying best Customer based on last purchase, average days between purchases, and active days.
*/
-- CTE 1- CustomerOrders

With CustomerOrders AS(
    SELECT 
        fs.customerkey,
        fs.OrderNumber,
        dd.fullDate AS purchaseDate
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.datekey = dd.datekey
    WHERE dd.calendaryear = 2025 
        AND fs.salesStatus = 'completed'
),

-- CTE 2- CustomerPurchaseHistory
CustomerPurchaseHistory AS (
    SELECT 
        co.customerKey,
        co.orderNumber,
        co.purchaseDate,
        
        -- Previous Purchase Date
        LAG(co.purchaseDate) OVER (PARTITION BY co.customerKey ORDER BY co.purchaseDate) AS prevPurchaseDate
    FROM CustomerOrders AS co
),
-- CTE 3- CustomerPurchaseGap
CustomerPurchaseGap AS (
    SELECT 
        cph.customerKey,
        cph.orderNumber,
        cph.purchaseDate,
        cph.prevPurchaseDate,

        -- calculate difference between two purchase days
        DATEDIFF(cph.purchaseDate,cph.prevpurchaseDate) AS purchaseGapDays
        
    FROM CustomerPurchaseHistory AS cph
),
-- CTE 4- CustomerAvgGapDays
CustomerAvgGapDays AS (
    SELECT 
            cpg.customerKey,
            -- cpg.orderNumber,
            -- cpg.purchaseDate,
            -- cpg.prevPurchaseDate,
            -- cpg.purchaseGapDays,

            MIN(cpg.purchaseDate) AS firstPurchase,
            MAX(cpg.purchaseDate) AS lastPurchase,
            COUNT(DISTINCT cpg.OrderNumber) AS totalOrders,

            -- Average Purchase Gap Days
            AVG(cpg.purchasegapDays) as avgPurchaseGap,
            
            -- Active Days 
            DATEDIFF(MAX(cpg.purchaseDate),MIN(cpg.purchaseDate)) +1 AS activeDays
            
    FROM CustomerPurchaseGap AS cpg
    GROUP BY 
            cpg.customerKey
),
-- CTE 5- CustomerRetention
CustomerRetention AS (
    SELECT 
            cagd.customerKey,
            -- cagd.orderNumber,
            -- cagd.purchaseDate,
            -- cagd.prevPurchaseDate,
            -- cagd.purchaseGapDays,
            cagd.firstPurchase,
            cagd.lastPurchase,
            cagd.totalOrders,
            cagd.avgPurchaseGap,
            cagd.activeDays,

            -- customer Retention
            CASE
                WHEN cagd.totalOrders = 1 THEN 'One Time Customer'

                WHEN  cagd.totalOrders >= 5 AND cagd.avgPurchaseGap <= 30 THEN 'Highly Loyal'
                
                WHEN cagd.totalOrders >= 5 THEN 'Loyal Customer'
                
                WHEN  cagd.avgPurchaseGap <= 30 THEN 'Highly Engaged'
                
                WHEN cagd.avgPurchaseGap <= 90 THEN 'Regular Customer'
                ELSE 'Occasional Customer'
            END AS customerRetention
            
    FROM CustomerAvgGapDays AS cagd
)

/*
Verify Customer Retention Data
SELECT
    customerRetention,
    COUNT(*) AS CustomerCount
FROM CustomerRetention
GROUP BY customerRetention;
*/

-- Fianl Select

SELECT 
    dc.customerId       AS Customer_ID,
    dc.customerName     AS Customer_Name,
    cr.firstPurchase    AS First_Purchase,
    cr.lastPurchase     AS Last_Purchase,
    cr.totalOrders      AS Total_Orders,
    cr.avgPurchaseGap   AS Avg_Gap_Days,
    cr.activeDays       AS ActiveDays,
    cr.customerRetention AS Customer_Type

FROM CustomerRetention AS cr
INNER JOIN DimCustomer AS dc
    ON cr.customerKey = dc.customerKey
WHERE cr.customerRetention IN ('Loyal Customer', 'One Time Customer','Highly Engaged')
ORDER BY 
    cr.totalOrders DESC,
    cr.activeDays DESC,
    cr.avgPurchaseGap;
