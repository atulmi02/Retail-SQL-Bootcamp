/*
===============================================================================
Business Requirement : BR #18B - Association Rule Mining - Market Basket Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides predictive analysis of unique pair of products purchased together performance by identifying best-performing Product Pair based on Rank, Support, Confidence and Lift.
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
        op1.OrderNumber,
        op1.ProductKey AS ProductKey1,
        op2.ProductKey AS ProductKey2
    FROM OrderProducts AS op1
    INNER JOIN OrderProducts AS op2
        ON op1.OrderNumber = op2.OrderNumber
    WHERE op1.ProductKey <> op2.ProductKey
),

-- CTE 3 - ProductPairFrequency
ProductPairFrequency AS (
    SELECT  
        pp.ProductKey1,
        pp.ProductKey2,
        COUNT(*) AS OrdersTogether
    FROM ProductPairs AS pp
    GROUP BY 
        pp.ProductKey1,
        pp.ProductKey2
),

-- CTE 4 - IndividualProductFrequency - Count how many orders each individual product appears in OrdersContainingProduct
IndividualProductFrequency AS (
    SELECT 
        op.ProductKey,
        COUNT(DISTINCT op.OrderNumber) AS OrdersContainingProduct
    FROM OrderProducts AS op
    GROUP BY 
        op.ProductKey
),

-- CTE 5 - TotalOrders
TotalOrders AS (
    SELECT 
        COUNT(DISTINCT OrderNumber) AS TotalOrders
    FROM OrderProducts
),

-- CTE 6 - AssociationMetrics 
AssociationMetrics AS (
    SELECT
        ppf.productKey1,
        ppf.productKey2,
        ipf1.OrdersContainingProduct AS OrdersContainingProduct1,
        ipf2.OrdersContainingProduct AS OrdersContainingProduct2,
        ppf.ordersTogether,
        to1.TotalOrders
    FROM ProductPairFrequency AS ppf
    INNER JOIN IndividualProductFrequency AS ipf1
        ON ppf.productKey1 = ipf1.productKey
    INNER JOIN IndividualProductFrequency AS ipf2
        ON ppf.productKey2 = ipf2.productKey
    CROSS JOIN TotalOrders AS to1
),

-- CTE 7 - FinalMetrics - Calculate Support, Confidence, and Lift
FinalMetrics AS (
    SELECT 
        am.productKey1,
        am.productKey2,
        am.ordersTogether,
        am.OrdersContainingProduct1,
        am.OrdersContainingProduct2,
        am.TotalOrders,

        -- Calculate Support
        1.0 * am.ordersTogether 
        / 
        NULLIF(am.totalOrders,0) AS Support,

        -- Calculate Confidence for Product 1 -> Product 2
        1.0 * am.ordersTogether
        /
        NULLIF(am.OrdersContainingProduct1,0) AS Confidence,

        -- Calculate Lift 
        1.0 * am.ordersTogether * am.totalOrders
        /
        NULLIF(am.OrdersContainingProduct1 * am.OrdersContainingProduct2,0) AS Lift

    FROM AssociationMetrics AS am
)
SELECT 
    -- fm.productKey1,
    -- fm.productKey2,
    dp1.ProductName AS ProductName1,
    dp2.ProductName AS ProductName2,
    fm.ordersTogether,
    fm.OrdersContainingProduct1,
    fm.OrdersContainingProduct2,
    fm.TotalOrders,
    ROUND(fm.Support*100,2) AS SupportPct,
    ROUND(fm.Confidence*100,2) AS ConfidencePct,
    ROUND(fm.Lift,2) AS Lift,
    -- Provide Rank based on Lift, Confidence, and Support
    RANK() OVER
            (
                ORDER BY 
                    fm.Lift DESC,
                    fm.Confidence DESC,
                    fm.Support DESC
            ) AS ProductRank,

    -- Association Strength
    CASE
        WHEN fm.Lift > 1.20 THEN 'Strong'
        WHEN fm.Lift >= 1 THEN 'Moderate'
        ELSE 'Weak'
    END AS AssociationStrength

FROM FinalMetrics AS fm
INNER JOIN DimProduct AS dp1
    ON fm.productKey1 = dp1.ProductKey
INNER JOIN DimProduct AS dp2
    ON fm.productKey2 = dp2.ProductKey
ORDER BY ProductRank; 
