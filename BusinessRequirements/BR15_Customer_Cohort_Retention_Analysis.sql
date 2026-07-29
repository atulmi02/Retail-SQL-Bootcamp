/*
===============================================================================
Business Requirement : BR #15 - Customer Cohort Retention Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Customer Cohort Retention Analysis by identifying  customer cohort and retention rate.
*/

-- CTE 1- CustomerFirstPurchase

WITH CustomerFirstPurchase AS (
    SELECT 
            fs.CustomerKey,
            MIN(dd.fullDate) AS FirstPurchase
            
    FROM factsales as fs
    INNER JOIN dimdate as dd
        ON fs.DateKey = dd.DateKey
    WHERE dd.CalendarYear = 2025
        AND fs.SalesStatus = 'completed'
    GROUP BY fs.CustomerKey
),
-- CTE 2- CustomerActivity
CustomerActivity AS (
    SELECT 
        fs.customerKey,
        dd.calendarMonth,
        dd.monthName
    FROM factsales as fs
    INNER JOIN dimdate as dd
        ON fs.DateKey = dd.DateKey
    WHERE dd.CalendarYear = 2025
        AND fs.SalesStatus = 'completed'
    GROUP BY fs.customerKey,
            dd.calendarMonth,
            dd.monthName
),
-- CustomerCohort
CustomerCohort AS (
    SELECT 
        cfp.customerKey,
        dd.calendarMonth AS CohortCalendarMonth,
        dd.monthName AS CohortMonth,
        ca.calendarMonth AS ActivityCalendarMonth,
        ca.monthName AS ActivityMonth
    FROM CustomerFirstPurchase AS cfp
    INNER JOIN dimdate AS dd
        ON cfp.firstPurchase = dd.fulldate
    INNER JOIN CustomerActivity AS ca
        ON cfp.customerKey = ca.customerKey
    WHERE ca.calendarMonth >= dd.calendarMonth
),
-- CTE 4 -CohortSummary
CohortSummary AS (
    SELECT 
        COUNT(DISTINCT(cc.customerKey)) AS ActiveCustomers,
        cc.CohortCalendarMonth,
        cc.CohortMonth,
        cc.ActivityCalendarMonth,
        cc.ActivityMonth
    FROM CustomerCohort AS cc
    GROUP BY
        cc.CohortCalendarMonth,
        cc.CohortMonth,
        cc.ActivityCalendarMonth,
        cc.ActivityMonth
),

-- CTE 5- CohortSize
CohortMetrics AS (
    SELECT 
        cs.ActiveCustomers,
        cs.CohortCalendarMonth,
        cs.CohortMonth,
        cs.ActivityCalendarMonth,
        cs.ActivityMonth,
        MAX(
            CASE 
                WHEN cs.CohortCalendarMonth = cs.ActivityCalendarMonth THEN cs.ActiveCustomers
            END)
        OVER (PARTITION BY cs.CohortCalendarMonth)
        AS CohortSize
    FROM CohortSummary AS cs
),
-- CTE 6- RetentionAnalysis
RetentionAnalysis AS (
    SELECT
        csc.ActiveCustomers,
        csc.CohortCalendarMonth,
        csc.CohortMonth,
        csc.ActivityCalendarMonth,
        csc.ActivityMonth,
        csc.cohortSize,
        -- RetentionPct
        CAST(csc.ActiveCustomers AS DECIMAL(18,2))
        /
        NULLIF(csc.CohortSize,0)
        * 100 AS RetentionPct,
        -- Months Since Acquisition
        csc.ActivityCalendarMonth - csc.CohortCalendarMonth AS MonthsSinceAcquisition
    FROM CohortMetrics AS csc
)
-- Final Select
SELECT 
    -- ra.CohortCalendarMonth,
    ra.CohortMonth,
    -- ra.ActivityCalendarMonth,

    ra.ActivityMonth, 
    ra.MonthsSinceAcquisition,

    ra.cohortSize,
    ra.ActiveCustomers,

    ROUND(ra.RetentionPct,2) AS retentionPct  

FROM RetentionAnalysis AS ra
ORDER BY   
        ra.CohortCalendarMonth,
        ra.ActivityCalendarMonth;