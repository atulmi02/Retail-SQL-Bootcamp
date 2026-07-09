/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 10_Create_FactSales.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS FactSales;

CREATE TABLE FactSales
(
    SalesKey            BIGINT AUTO_INCREMENT PRIMARY KEY,

    OrderNumber         VARCHAR(30) NOT NULL UNIQUE,

    DateKey             INT NOT NULL,

    CustomerKey         INT NOT NULL,

    ProductKey          INT NOT NULL,

    StoreKey            INT NOT NULL,

    EmployeeKey         INT NOT NULL,

    PromotionKey        INT NOT NULL,

    SalesQuantity       INT NOT NULL,

    UnitPrice           DECIMAL(10,2) NOT NULL,

    DiscountAmount      DECIMAL(10,2) NOT NULL,

    SalesAmount         DECIMAL(12,2) NOT NULL,

    CostAmount          DECIMAL(12,2) NOT NULL,

    ProfitAmount        DECIMAL(12,2) NOT NULL,

    SalesStatus         VARCHAR(20) NOT NULL,

    CreatedDate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY(DateKey)
        REFERENCES DimDate(DateKey),

    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY(ProductKey)
        REFERENCES DimProduct(ProductKey),

    CONSTRAINT FK_FactSales_Store
        FOREIGN KEY(StoreKey)
        REFERENCES DimStore(StoreKey),

    CONSTRAINT FK_FactSales_Employee
        FOREIGN KEY(EmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),

    CONSTRAINT FK_FactSales_Promotion
        FOREIGN KEY(PromotionKey)
        REFERENCES DimPromotion(PromotionKey)
);

/*
Create Index
*/
CREATE INDEX IX_FactSales_Date
ON FactSales(DateKey);

CREATE INDEX IX_FactSales_Customer
ON FactSales(CustomerKey);

CREATE INDEX IX_FactSales_Product
ON FactSales(ProductKey);

CREATE INDEX IX_FactSales_Store
ON FactSales(StoreKey);

CREATE INDEX IX_FactSales_Employee
ON FactSales(EmployeeKey);

CREATE INDEX IX_FactSales_Promotion
ON FactSales(PromotionKey);

CREATE INDEX IX_FactSales_Status
ON FactSales(SalesStatus);

CREATE INDEX IX_FactSales_OrderNumber
ON FactSales(OrderNumber);