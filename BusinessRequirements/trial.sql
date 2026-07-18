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
)

-- CTE 3- EmployeePerformance

    SELECT 
        es.employeekey,
        es.totalOrders,
        es.employeeGrossSales,
        
        -- AverageOrderValue
        CAST(es.employeeGrossSales AS DECIMAL(18,2))
        /
        NULLIF(CAST(es.totalOrders AS DECIMAL(18,2)),0) AS avgOrderValue,
        
        -- EmployeeContributionPct
        CAST(es.employeeGrossSales AS DECIMAL(18,2))
        /
        NULLIF(CAST(cts.totalCompanySales AS DECIMAL(18,2)),0)*100 AS empSalesContributionPct,

        -- Rank Employee on Employee Gross Sales
        RANK()OVER(ORDER BY es.employeeGrossSales DESC) AS employeeRank

    FROM EmployeeSales AS es
    CROSS JOIN CompanyTotalSales AS cts;

