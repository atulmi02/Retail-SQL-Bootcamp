/*
===============================================================================
Business Requirement : BR #18 - Market Basket Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of unique pair of products purchased together performance by identifying best-performing Product Pair based on Rank.
*/

-- CTE 1 - OrderProducts
WITH OrderProducts AS (
    SELECT 
        ProductKey,
        OrderNumber
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.DateKey = dd.DateKey
    WHERE dd.CalendarYear = 2025 AND fs.salesStatus = 'completed'
),
-- CTE 2 - ProductPairs - Using Self Join
ProductPairs AS (
    SELECT 
        op1.orderNumber,
        op1.ProductKey AS ProductKey1,
        op2.ProductKey AS ProductKey2
    FROM OrderProducts AS op1
    INNER JOIN OrderProducts AS op2
        ON op1.orderNumber = op2.orderNumber
    WHERE op1.ProductKey < op2.productKey
),
-- CTE 3 - ProductFrequency
ProductFrequency AS (
    SELECT  
        pp.ProductKey1,
        pp.ProductKey2,
        COUNT(*) AS OrderedTogether
    FROM ProductPairs AS pp
    GROUP BY 
        pp.ProductKey1,
        pp.ProductKey2
),
-- CTE 4 - ProductPairMetrics
ProductPairMetrics AS ( 
    SELECT
        pf.ProductKey1,
        pf.ProductKey2,
        pf.OrderedTogether,
        
        -- Product Pair Rank
        RANK() OVER 
            (ORDER BY 
                    pf.OrderedTogether DESC, 
                    pf.ProductKey1, 
                    pf.ProductKey2 
            ) AS ProductPairRank,

        -- Total Pair Orders
        SUM(pf.OrderedTogether) OVER() AS TotalPairOrders
    FROM ProductFrequency AS pf
),
-- CTE 5 - PairContribution
PairContribution AS (
    SELECT
        ppm.ProductKey1,
        ppm.ProductKey2,
        ppm.OrderedTogether,
        ppm.ProductPairRank,
        ppm.TotalPairOrders,

        -- Pair Contribution %
        1.0*ppm.OrderedTogether
        /
        NULLIF(ppm.TotalPairOrders,0)
        * 100 AS PairContributionPercentage,

        -- TOP N Pairs
        NTILE(5) OVER 
            (ORDER BY 
                ppm.OrderedTogether DESC,
                ppm.ProductKey1,
                ppm.ProductKey2
            )AS TopNPairs,

         -- Cumulative %
        SUM(
            1.0 * ppm.OrderedTogether
            /
            NULLIF(ppm.TotalPairOrders,0)
            * 100) 
        OVER (
            ORDER BY 
                ppm.OrderedTogether DESC, 
                ppm.ProductKey1, 
                ppm.ProductKey2 
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativePairPct

    FROM ProductPairMetrics AS ppm
)
-- FINAL SELECT
SELECT 
        dp1.ProductName AS ProductName1,
        dp2.ProductName AS ProductName2,
        -- abc.ProductKey1,
        -- abc.ProductKey2,
        abc.OrderedTogether,
        abc.ProductPairRank,
        abc.TotalPairOrders,
        ROUND(abc.PairContributionPercentage,2) AS PairContributionPercentage,
        ROUND(abc.CumulativePairPct,2) AS CumulativePairPct,
        abc.TopNPairs,

        -- TOP N Pairs
        CASE 
            WHEN abc.TopNPairs = 1 THEN 'Top 20%' 
            WHEN abc.TopNPairs = 2 THEN '20% - 40%' 
            WHEN abc.TopNPairs = 3 THEN '40% - 60%' 
            WHEN abc.TopNPairs = 4 THEN '60% - 80%' 
            ELSE 'Bottom 20%'
        END AS TopPairs,

        -- ABC Classification based on Cumulative Orders
        CASE 
            WHEN abc.CumulativePairPct <= 80 THEN 'A'
            WHEN abc.CumulativePairPct <= 95 THEN 'B'
            ELSE 'C'
        END AS ABCClassification
        
FROM PairContribution AS abc
INNER JOIN DimProduct AS dp1
    ON abc.ProductKey1 = dp1.ProductKey
INNER JOIN DimProduct AS dp2
    ON abc.ProductKey2 = dp2.ProductKey