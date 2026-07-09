/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 11_Load_FactSales.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE FactSales;

INSERT INTO FactSales
(
    OrderNumber,
    DateKey,
    CustomerKey,
    ProductKey,
    StoreKey,
    EmployeeKey,
    PromotionKey,
    SalesQuantity,
    UnitPrice,
    DiscountAmount,
    SalesAmount,
    CostAmount,
    ProfitAmount,
    SalesStatus
)

SELECT

    ss.OrderNumber,

    dd.DateKey,

    ss.CustomerKey,

    ss.ProductKey,

    ss.StoreKey,

    ss.EmployeeKey,

    ss.PromotionKey,

    ss.SalesQuantity,

    dp.UnitPrice,

    ROUND(
        (dp.UnitPrice * ss.SalesQuantity * prm.DiscountPercent) / 100,
        2
    ) AS DiscountAmount,

    ROUND(
        (dp.UnitPrice * ss.SalesQuantity)
        -
        ((dp.UnitPrice * ss.SalesQuantity * prm.DiscountPercent)/100),
        2
    ) AS SalesAmount,

    ROUND(
        dp.UnitCost * ss.SalesQuantity,
        2
    ) AS CostAmount,

    ROUND(
        (
            (dp.UnitPrice * ss.SalesQuantity)
            -
            ((dp.UnitPrice * ss.SalesQuantity * prm.DiscountPercent)/100)
        )
        -
        (dp.UnitCost * ss.SalesQuantity),
        2
    ) AS ProfitAmount,

    CASE

        WHEN MOD(ss.StageSalesID,20)=0
            THEN 'Cancelled'

        WHEN MOD(ss.StageSalesID,10)=0
            THEN 'Returned'

        ELSE 'Completed'

    END

FROM StageSales ss

INNER JOIN DimDate dd
ON ss.OrderDate = dd.FullDate

INNER JOIN DimProduct dp
ON ss.ProductKey = dp.ProductKey

INNER JOIN DimPromotion prm
ON ss.PromotionKey = prm.PromotionKey;
/*
Validations
==============
SELECT COUNT(*) AS TotalSales FROM FactSales;
SELECT SalesStatus,COUNT(*) TotalRows FROM FactSales GROUP BY SalesStatus;
SELECT MIN(SalesAmount),MAX(SalesAmount),AVG(SalesAmount) FROM FactSales;
SELECT MIN(ProfitAmount),MAX(ProfitAmount),AVG(ProfitAmount) FROM FactSales;
*/
