/*
===============================================================================
Business Requirement : BR #07 - Employee Performance Analysis
Author               : Atul Kumar Keshari
Database             : Retail_SQL_Bootcamp
Description          : This report provides comprehensive analysis of Employee performance by identifying best-performing Employees based on gross sales and measuring each Employees contribution to Company's Total sales
*/

-- CTE 1- Employee Sales

With EmployeeSales AS  (
    SELECT fs.employeeKey,
            COUNT(DISTINCT fs.orderNumber) as TotalOrders,
            SUM(fs.salesamount) as EmployeeGrossSales
    FROM factsales as fs
    INNER JOIN dimdate as dd 
        ON fs.datekey = dd.datekey
    WHERE fs.salesstatus = 'completed'
        AND dd.calendarYear = 2025
    GROUP BY fs.EmployeeKey
),

-- CTE 2- Company's Total Sales

CompanyTotalSales AS (
    SELECT sum(es.employeegrosssales) as TotalCompanySales
    FROM EmployeeSales as es
),

-- CTE 3- EmployeePerformance
EmployeePerformance AS (
    SELECT 
        es.employeekey,
        es.totalOrders,
        es.employeeGrossSales,
        cts.totalCompanySales,
        -- AverageOrderValue
        CAST(es.employeeGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(es.totalOrders AS DECIMAL(18,4)),0) AS avgOrderValue,
        
        -- EmployeeContributionPct
        CAST(es.employeeGrossSales AS DECIMAL(18,4))
        /
        NULLIF(CAST(cts.totalCompanySales AS DECIMAL(18,4)),0)*100 AS empSalesContributionPct,

        -- Rank Employee on Employee Gross Sales
        RANK()OVER(ORDER BY es.employeeGrossSales DESC) AS employeeRank

    FROM EmployeeSales AS es
    CROSS JOIN CompanyTotalSales AS cts

)
-- FINAL SELECT
    SELECT de.EmployeeID,
            de.EmployeeName,
            de.Designation,

            ep.totalOrders,
            ROUND(ep.employeeGrossSales,2) AS employeeGrossSales,
            ROUND(ep.avgOrderValue,2) AS avgOrderValue,
           
            ROUND(ep.totalCompanySales,2) AS CompanyTotalSales,
            ROUND(ep.empSalesContributionPct,2) AS empSalesContributionPct,

            ep.employeeRank

    FROM EmployeePerformance AS ep
    INNER JOIN DimEmployee AS de
        ON ep.employeekey = de.employeekey
    
    ORDER BY ep.employeeRank,ep.employeeGrossSales;

    