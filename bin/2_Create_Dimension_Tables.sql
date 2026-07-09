USE SQL_Bootcamp;

-- ===========================================
-- DIM REGION
-- ===========================================

CREATE TABLE DimRegion (
    RegionKey INT PRIMARY KEY AUTO_INCREMENT,
    RegionName VARCHAR(50) NOT NULL
);

-- ===========================================
-- DIM CATEGORY
-- ===========================================

CREATE TABLE DimCategory (
    CategoryKey INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL
);

-- ===========================================
-- DIM SUPPLIER
-- ===========================================

CREATE TABLE DimSupplier (
    SupplierKey INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(150),
    SupplierCity VARCHAR(100)
);

-- ===========================================
-- DIM PRODUCT
-- ===========================================

CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY AUTO_INCREMENT,
    ProductID VARCHAR(20) UNIQUE,
    ProductName VARCHAR(200),
    CategoryKey INT,
    SupplierKey INT,
    Brand VARCHAR(100),
    UnitCost DECIMAL(10,2),
    UnitPrice DECIMAL(10,2),

    FOREIGN KEY(CategoryKey)
        REFERENCES DimCategory(CategoryKey),

    FOREIGN KEY(SupplierKey)
        REFERENCES DimSupplier(SupplierKey)
);

-- ===========================================
-- DIM CUSTOMER
-- ===========================================

CREATE TABLE DimCustomer (

    CustomerKey INT PRIMARY KEY AUTO_INCREMENT,

    CustomerID VARCHAR(20) UNIQUE,

    CustomerName VARCHAR(200),

    Gender VARCHAR(20),

    City VARCHAR(100),

    RegionKey INT,

    CustomerType VARCHAR(50),

    JoinDate DATE,

    FOREIGN KEY(RegionKey)
        REFERENCES DimRegion(RegionKey)
);

-- ===========================================
-- DIM STORE
-- ===========================================

CREATE TABLE DimStore (

    StoreKey INT PRIMARY KEY AUTO_INCREMENT,

    StoreName VARCHAR(150),

    RegionKey INT,

    City VARCHAR(100),

    FOREIGN KEY(RegionKey)
        REFERENCES DimRegion(RegionKey)
);

-- ===========================================
-- DIM EMPLOYEE
-- ===========================================

CREATE TABLE DimEmployee (

    EmployeeKey INT PRIMARY KEY AUTO_INCREMENT,

    EmployeeID VARCHAR(20),

    EmployeeName VARCHAR(150),

    ManagerKey INT NULL,

    Department VARCHAR(100),

    FOREIGN KEY(ManagerKey)
        REFERENCES DimEmployee(EmployeeKey)
);

-- ===========================================
-- DIM PROMOTION
-- ===========================================

CREATE TABLE DimPromotion (

    PromotionKey INT PRIMARY KEY AUTO_INCREMENT,

    PromotionName VARCHAR(100),

    DiscountPercent DECIMAL(5,2),

    StartDate DATE,

    EndDate DATE
);

-- ===========================================
-- DIM DATE
-- ===========================================

CREATE TABLE DimDate (

    DateKey INT PRIMARY KEY,

    FullDate DATE,

    CalendarDay INT,

    CalendarMonth INT,

    MonthName VARCHAR(20),

    CalendarQuarter INT,

    CalendarYear INT,

    WeekNumber INT,

    IsWeekend BOOLEAN
);