/*
H04_Create_ProductCategories
*/
USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_ProductCategories;

CREATE TABLE H_ProductCategories
(
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50),
    PriceMin DECIMAL(10,2),
    PriceMax DECIMAL(10,2)
);
/*
Load ProductCategories
*/
INSERT INTO H_ProductCategories
(CategoryName,PriceMin,PriceMax)

VALUES
('Electronics',5000,100000),
('Home Appliances',1500,60000),
('Furniture',3000,80000),
('Fashion',300,8000),
('Grocery',20,1000),
('Sports',200,15000),
('Beauty',100,5000),
('Toys',100,5000);