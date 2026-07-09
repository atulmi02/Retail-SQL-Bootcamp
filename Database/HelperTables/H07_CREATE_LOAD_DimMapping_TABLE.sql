/*
Helper Date Mapping Table
*/
DROP TABLE IF EXISTS H_DateMap;

CREATE TABLE H_DateMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY FullDate) AS RowNo,
DateKey
FROM DimDate;

ALTER TABLE H_DateMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HDate_DateKey
ON H_DateMap(DateKey);

/*
Customer Mapping Table
*/
DROP TABLE IF EXISTS H_CustomerMap;

CREATE TABLE H_CustomerMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY CustomerKey) AS RowNo,
CustomerKey
FROM DimCustomer;

ALTER TABLE H_CustomerMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HCustomer_CustomerKey
ON H_CustomerMap(CustomerKey);

/*
Product Mapping
*/
DROP TABLE IF EXISTS H_ProductMap;

CREATE TABLE H_ProductMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY ProductKey) AS RowNo,
ProductKey
FROM DimProduct;

ALTER TABLE H_ProductMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HProduct_ProductKey
ON H_ProductMap(ProductKey);

/*
Store Mapping
*/
DROP TABLE IF EXISTS H_StoreMap;

CREATE TABLE H_StoreMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY StoreKey) AS RowNo,
StoreKey
FROM DimStore;

ALTER TABLE H_StoreMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HStore_StoreKey
ON H_StoreMap(StoreKey);

/*
Employee Mapping
*/
DROP TABLE IF EXISTS H_EmployeeMap;

CREATE TABLE H_EmployeeMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY EmployeeKey) AS RowNo,
EmployeeKey,
StoreKey
FROM DimEmployee;

ALTER TABLE H_EmployeeMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HEmployee_EmployeeKey
ON H_EmployeeMap(EmployeeKey);

CREATE INDEX IX_HEmployee_StoreKey
ON H_EmployeeMap(StoreKey);
/*
Promotion Mapping
*/
DROP TABLE IF EXISTS H_PromotionMap;

CREATE TABLE H_PromotionMap
AS
SELECT
ROW_NUMBER() OVER(ORDER BY PromotionKey) AS RowNo,
PromotionKey
FROM DimPromotion;

ALTER TABLE H_PromotionMap
ADD PRIMARY KEY(RowNo);

CREATE INDEX IX_HPromotion_PromotionKey
ON H_PromotionMap(PromotionKey);

SELECT COUNT(*) FROM H_DateMap;

SELECT COUNT(*) FROM H_CustomerMap;

SELECT COUNT(*) FROM H_ProductMap;

SELECT COUNT(*) FROM H_StoreMap;

SELECT COUNT(*) FROM H_EmployeeMap;

SELECT COUNT(*) FROM H_PromotionMap;
