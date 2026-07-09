/*
This is the most important table in the entire bootcamp. We'll generate it using business rules rather than random values:

📅 Weekend sales uplift
🎆 Festival spikes (Diwali, Christmas, New Year)
🛍️ Promotion-driven discounts
👥 Customer purchase patterns
🏬 Store performance differences
📦 Product category popularity
💰 Profit calculated from DimProduct cost and selling price
📈 Sales status distribution:
85% Completed
10% Returned
5% Cancelled

Load FactSales
│
├── Step 1: Base Sales (100,000 rows)
├── Step 2: Product & Customer lookup
├── Step 3: Pricing calculations
├── Step 4: Promotion assignment
├── Step 5: Seasonal adjustments
├── Step 6: Status assignment
└── Step 7: Validation
*/
/*
Create Fact Sales
*/
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

    CONSTRAINT FK_FS_Date
        FOREIGN KEY(DateKey)
        REFERENCES DimDate(DateKey),

    CONSTRAINT FK_FS_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    CONSTRAINT FK_FS_Product
        FOREIGN KEY(ProductKey)
        REFERENCES DimProduct(ProductKey),

    CONSTRAINT FK_FS_Store
        FOREIGN KEY(StoreKey)
        REFERENCES DimStore(StoreKey),

    CONSTRAINT FK_FS_Employee
        FOREIGN KEY(EmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),

    CONSTRAINT FK_FS_Promotion
        FOREIGN KEY(PromotionKey)
        REFERENCES DimPromotion(PromotionKey)
);
/*
Create Indexes
*/
CREATE INDEX IX_FactSales_Date
ON FactSales(DateKey);

CREATE INDEX IX_FactSales_Product
ON FactSales(ProductKey);

CREATE INDEX IX_FactSales_Customer
ON FactSales(CustomerKey);

CREATE INDEX IX_FactSales_Store
ON FactSales(StoreKey);

CREATE INDEX IX_FactSales_Status
ON FactSales(SalesStatus);

CREATE INDEX IX_FactSales_Order
ON FactSales(OrderNumber);