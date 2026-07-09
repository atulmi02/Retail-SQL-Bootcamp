/*
03_CREATE_DIMPRODUCT
*/
/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 03_Create_DimProduct.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimProduct;

CREATE TABLE DimProduct
(
    ProductKey          INT AUTO_INCREMENT PRIMARY KEY,

    ProductID           VARCHAR(20) NOT NULL UNIQUE,

    SKU                 VARCHAR(30) NOT NULL UNIQUE,

    Barcode             VARCHAR(20) NOT NULL UNIQUE,

    ProductName         VARCHAR(100) NOT NULL,

    Category            VARCHAR(50) NOT NULL,

    SubCategory         VARCHAR(50),

    Brand               VARCHAR(50) NOT NULL,

    UnitCost            DECIMAL(10,2) NOT NULL,

    UnitPrice           DECIMAL(10,2) NOT NULL,

    ProfitMargin        DECIMAL(5,2) NOT NULL,

    UnitOfMeasure       VARCHAR(20) NOT NULL,

    PackageSize         VARCHAR(30),

    ReorderLevel        INT NOT NULL,

    IsActive            BOOLEAN NOT NULL DEFAULT TRUE,

    CreatedDate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/*
Create Indexes
*/
CREATE INDEX IX_DimProduct_Category
ON DimProduct(Category);

CREATE INDEX IX_DimProduct_Brand
ON DimProduct(Brand);

CREATE INDEX IX_DimProduct_Name
ON DimProduct(ProductName);

CREATE INDEX IX_DimProduct_SKU
ON DimProduct(SKU);

CREATE INDEX IX_DimProduct_IsActive
ON DimProduct(IsActive);

/*
LOAD DimProduct
*/
USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM DimProduct;

INSERT INTO DimProduct
(
    ProductID,
    SKU,
    Barcode,
    ProductName,
    Category,
    SubCategory,
    Brand,
    UnitCost,
    UnitPrice,
    ProfitMargin,
    UnitOfMeasure,
    PackageSize,
    ReorderLevel,
    IsActive
)

SELECT

CONCAT('PRD',LPAD(n.NumberID,6,'0')),

CONCAT('SKU',LPAD(n.NumberID,8,'0')),

CONCAT('89',LPAD(n.NumberID,10,'0')),

pm.ProductName,

pm.CategoryName,

pm.SubCategory,

pm.BrandName,

pm.UnitCost,

pm.UnitPrice,

ROUND(
((pm.UnitPrice-pm.UnitCost)/pm.UnitPrice)*100,
2
),

CASE
WHEN pm.CategoryName='Grocery' THEN 'Piece'
WHEN pm.CategoryName='Beauty' THEN 'Piece'
WHEN pm.CategoryName='Electronics' THEN 'Piece'
WHEN pm.CategoryName='Furniture' THEN 'Piece'
WHEN pm.CategoryName='Sports' THEN 'Piece'
WHEN pm.CategoryName='Fashion' THEN 'Piece'
WHEN pm.CategoryName='Home Appliances' THEN 'Piece'
ELSE 'Piece'
END,

CASE
WHEN pm.CategoryName='Grocery' THEN 'Standard'
WHEN pm.CategoryName='Beauty' THEN 'Standard'
ELSE 'Single Unit'
END,

CASE
WHEN pm.CategoryName='Electronics' THEN 20
WHEN pm.CategoryName='Furniture' THEN 10
WHEN pm.CategoryName='Home Appliances' THEN 15
WHEN pm.CategoryName='Fashion' THEN 50
WHEN pm.CategoryName='Sports' THEN 40
WHEN pm.CategoryName='Beauty' THEN 75
WHEN pm.CategoryName='Grocery' THEN 100
ELSE 25
END,

CASE
WHEN MOD(n.NumberID,25)=0 THEN FALSE
ELSE TRUE
END

FROM H_Numbers n

JOIN H_ProductMaster pm
ON pm.ProductMasterID = ((n.NumberID-1) % 64) + 1

WHERE n.NumberID <= 500;