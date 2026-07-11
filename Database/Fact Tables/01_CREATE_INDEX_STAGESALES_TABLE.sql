/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 08_Create_StageSales.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS StageSales;

CREATE TABLE StageSales
(
    StageSalesID        BIGINT AUTO_INCREMENT PRIMARY KEY,

    OrderNumber         VARCHAR(30) NOT NULL,

    OrderDate           DATE NOT NULL,

    CustomerKey         INT NOT NULL,

    ProductKey          INT NOT NULL,

    StoreKey            INT NOT NULL,

    EmployeeKey         INT NOT NULL,

    PromotionKey        INT NOT NULL,

    SalesQuantity       INT NOT NULL,

    SalesStatus         VARCHAR(20) NOT NULL,

    LoadDate            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/*
Create Indexes
*/
CREATE INDEX IX_StageSales_OrderDate
ON StageSales(OrderDate);

CREATE INDEX IX_StageSales_Customer
ON StageSales(CustomerKey);

CREATE INDEX IX_StageSales_Product
ON StageSales(ProductKey);

CREATE INDEX IX_StageSales_Store
ON StageSales(StoreKey);

CREATE INDEX IX_StageSales_Employee
ON StageSales(EmployeeKey);

CREATE INDEX IX_StageSales_Promotion
ON StageSales(PromotionKey);

CREATE INDEX IX_StageSales_Status
ON StageSales(SalesStatus);