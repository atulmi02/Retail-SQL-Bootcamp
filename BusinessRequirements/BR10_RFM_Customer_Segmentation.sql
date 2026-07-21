/*
===============================================================================
Business Requirement : BR #10 - RFM Customer Segmentation
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of RFM Customer Segmentation by identifying best-performing Customer based on gross sales and measuring each customer's RFM Score.
*/
-- CTE 1 - CustomerRFM
With CustomerRFM AS (
    SELECT fs.customerKey,
            COUNT(DISTINCT orderNumber) AS frequency,
            SUM(fs.salesAmount) AS monetary,
            MAX(dd.fulldate) AS lastPurchase
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.dateKey = dd.dateKey
    WHERE fs.salesStatus = 'completed' AND dd.calendarYear = 2025
    GROUP BY fs.customerKey
),
-- CTE 2- CustomerMetrics
CustomerMetrics AS (
    SELECT
        crfm.customerKey,
        crfm.frequency,
        crfm.monetary,  
        crfm.lastpurchase,
        DATEDIFF('2025-12-31', crfm.lastPurchase) AS recency
    FROM CustomerRFM AS crfm
    
),

-- CTE 3 - RFMScore
RFMScore AS (
    SELECT 
        cm.customerKey,
        
        cm.frequency,
        NTILE(5) OVER (ORDER BY cm.frequency DESC) AS FScore,

        cm.monetary,  
        NTILE(5) OVER (ORDER BY cm.monetary DESC) AS MScore,

        cm.recency,
        NTILE(5) OVER (ORDER BY cm.recency ASC) AS RScore
    FROM CustomerMetrics AS cm
),

-- FinalRFMscore
CustomerSegment AS (    
    SELECT 
        rs.customerKey,
        rs.recency,
        rs.RScore,
        rs.frequency,
        rs.FScore,
        rs.Monetary,
        rs.MScore,
        
        CONCAT(
            rs.RScore, 
            rs.FScore, 
            rs.MScore
        ) AS RFMScore,

        rs.RScore+ rs.FScore+ rs.MScore AS TotalScore,

        CASE
            WHEN (
                rs.RScore >= 4 AND 
                rs.FScore >= 4 AND 
                rs.MScore >=4
            ) THEN 'Champions'

            WHEN (
                rs.RScore >= 4 AND 
                rs.FScore>= 3
            ) THEN 'Loyal Customer'

            WHEN (
                rs.Rscore >= 4
            ) THEN "Potential Loyalist"

            WHEN (
                rs.RScore <= 2 AND 
                FScore >= 3
            ) THEN 'At Risk'

            ELSE 'Lost Customers'
        END AS customerSegment
    FROM RFMScore AS rs
)
SELECT 
    dc.customerID,
    dc.customerName,
    cs.recency,
    cs.frequency,
    cs.monetary,
    cs.rscore,
    cs.fscore,
    cs.mscore,
    cs.rfmscore,
    cs.totalscore,
    cs.customerSegment

FROM CustomerSegment AS cs
INNER JOIN DimCustomer AS dc
    ON cs.customerKey = dc.customerKey

ORDER BY 
    cs.rscore DESC,
    cs.fscore DESC, 
    cs.mscore DESC, 
    cs.monetary DESC; 