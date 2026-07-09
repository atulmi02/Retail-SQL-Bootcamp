-- REBUILDING DATABASE FOR REATIL ERP DATA WAREHOUSE

-- DISABLE FOREIGN KEY CHECKS

SET FOREIGN_KEY_CHECKS = 0;

-- DROP ALL FACT TABLES
DROP TABLE IF EXISTS FactInventory;
DROP TABLE IF EXISTS FactReturns;
DROP TABLE IF EXISTS FactPurchase;
DROP TABLE IF EXISTS FactSales;

-- DROP ALL DIMENSION TABLES
DROP TABLE IF EXISTS DimPromotion;
DROP TABLE IF EXISTS DimEmployee;
DROP TABLE IF EXISTS DimStore;
DROP TABLE IF EXISTS DimProduct;
DROP TABLE IF EXISTS DimSupplier;
DROP TABLE IF EXISTS DimCustomer;
DROP TABLE IF EXISTS DimDate; 
DROP TABLE IF EXISTS DimCategory;
DROP TABLE IF EXISTS DimRegion;

-- ENABLE FOREIGN KEY CHECKS 

SET FOREIGN_KEY_CHECKS = 1;
/*
Retail_SQL_Bootcamp
│
├── 00_Database.sql
├── 01_Create_DimDate.sql
├── 02_Create_DimCustomer.sql
├── 03_Create_DimProduct.sql
├── 04_Create_DimStore.sql
├── 05_Create_DimEmployee.sql
├── 06_Create_DimPromotion.sql
├── 07_Create_DimSupplier.sql
├── 08_Create_FactSales.sql
├── 09_Create_FactReturns.sql
├── 10_Create_FactInventory.sql
├── 11_Create_FactPurchase.sql
│
├── LoadScripts
│     ├── 01_Load_DimDate.sql
│     ├── 02_Load_DimCustomer.sql
│     ├── ...
│
├── BusinessRequirements
│     ├── BR01.sql
│     ├── BR02.sql
│     ├── ...
│
└── README.md
*/ 