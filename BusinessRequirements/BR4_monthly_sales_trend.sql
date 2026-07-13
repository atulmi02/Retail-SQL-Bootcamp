/*
BR#4 Monthly Sales Trend Analysis
*/

/*
INDEXING
*/

CREATE nonclustered INDEX IX_FactSales ON factsales(datekey, salesstatus) INCLUDE ( ordernumber, salesamount);

CREATE NONCLUSTERED INDEX IX_DimDate_YearMonth
ON DimDate
(
    CalendarYear,
    MonthNumber,
    DateKey
)
INCLUDE
(
    MonthName
);
/*
CTE: 1 Monthly_Sales_Trend
    filter : Year = 2025 and Sales Status = 'Completed'
    Group by : month number and name
    Calculate : Total Sales Amount, Total Orders
*/
With Monthly_Sales_Trend as (
    SELECT
        dd.calendarmonth,
        dd.monthname,
        COUNT(DISTINCT(fs.ordernumber)) as TotalOrders,
        SUM(fs.salesamount) as GrossSales
FROM factsales as fs
INNER JOIN dimdate as dd 
    ON fs.datekey = dd.datekey
WHERE dd.calendaryear = 2025 
    and fs.salesstatus = 'Completed'
GROUP BY dd.calendarmonth,
        dd.monthname
),

/* 
CTE: 2 Monthly_Prev_Sales
    Use Window Function to get Previous Month Sales Amount and running total of sales amount from cte 1
    Calculate : Prev Month Total Sales Amount, Running Total Sales Amount
*/
Monthly_prev_Sales as (
    SELECT 
            CalendarMonth,
            MonthName,
            TotalOrders,
            GrossSales,
            LAG(GrossSales) OVER ( ORDER BY calendarmonth) as PrevMonthGrossSales,
            SUM(GrossSales) OVER ( ORDER BY calendarmonth  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as RunningTotalGrossSales
    FROM Monthly_Sales_Trend
),
/*
CTE:3 Sales_Growth_Performance
    Use Window Function to get Row Number based on Gross Sales Amount from cte 2
    Calculate : Sales Growth Percentage, Row Number
*/
Sales_Growth_Performance as (
    SELECT 
            CalendarMonth,
            MonthName,  
            TotalOrders,
            GrossSales,
            PrevMonthGrossSales,
            RunningTotalGrossSales,
            (
                CAST(GrossSales - PrevMonthGrossSales AS DECIMAL(18,2))
                /
                NULLIF(CAST(PrevMonthGrossSales AS DECIMAL(18,2)), 0)
            )*100 
            AS MoMGrowthPct,
            RANK() OVER (ORDER BY GrossSales DESC) AS SalesRank
    FROM Monthly_prev_Sales 
)
    SELECT 
            CalendarMonth,
            MonthName,  
            TotalOrders,
            GrossSales,
            PrevMonthGrossSales,
            RunningTotalGrossSales,
            MoMGrowthPct,
            SalesRank
    FROM Sales_Growth_Performance
    ORDER BY CalendarMonth