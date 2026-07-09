USE SQL_Bootcamp;

-- ===========================================
-- FACT SALES
-- ===========================================

CREATE TABLE FactSales (

    SalesID BIGINT PRIMARY KEY AUTO_INCREMENT,

    OrderNumber VARCHAR(30),

    DateKey INT,

    CustomerKey INT,

    ProductKey INT,

    StoreKey INT,

    EmployeeKey INT,

    PromotionKey INT,

    SalesQuantity INT,

    UnitPrice DECIMAL(10,2),

    DiscountAmount DECIMAL(10,2),

    SalesAmount DECIMAL(12,2),

    CostAmount DECIMAL(12,2),

    ProfitAmount DECIMAL(12,2),

    SalesStatus VARCHAR(20),

    FOREIGN KEY(DateKey)
        REFERENCES DimDate(DateKey),

    FOREIGN KEY(CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    FOREIGN KEY(ProductKey)
        REFERENCES DimProduct(ProductKey),

    FOREIGN KEY(StoreKey)
        REFERENCES DimStore(StoreKey),

    FOREIGN KEY(EmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),

    FOREIGN KEY(PromotionKey)
        REFERENCES DimPromotion(PromotionKey)
);

-- ===========================================
-- FACT RETURNS
-- ===========================================

CREATE TABLE FactReturns (

    ReturnID BIGINT PRIMARY KEY AUTO_INCREMENT,

    DateKey INT,

    CustomerKey INT,

    ProductKey INT,

    ReturnQuantity INT,

    ReturnAmount DECIMAL(12,2),

    ReturnReason VARCHAR(100),

    FOREIGN KEY(DateKey)
        REFERENCES DimDate(DateKey),

    FOREIGN KEY(CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    FOREIGN KEY(ProductKey)
        REFERENCES DimProduct(ProductKey)
);