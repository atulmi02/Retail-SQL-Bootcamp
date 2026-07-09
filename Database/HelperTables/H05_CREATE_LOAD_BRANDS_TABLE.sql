/*
H05_Create_Brands
*/
USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_Brands;

CREATE TABLE H_Brands
(
    BrandID INT AUTO_INCREMENT PRIMARY KEY,
    BrandName VARCHAR(50),
    CategoryName VARCHAR(50)
);
/*
Load Brands
*/
INSERT INTO H_Brands
(BrandName, CategoryName)
VALUES

-- Electronics
('Apple','Electronics'),
('Samsung','Electronics'),
('Sony','Electronics'),
('Dell','Electronics'),
('HP','Electronics'),
('Lenovo','Electronics'),
('Boat','Electronics'),
('JBL','Electronics'),

-- Home Appliances
('LG','Home Appliances'),
('Whirlpool','Home Appliances'),
('Bosch','Home Appliances'),
('IFB','Home Appliances'),
('Prestige','Home Appliances'),
('Philips','Home Appliances'),
('Havells','Home Appliances'),
('Bajaj','Home Appliances'),

-- Grocery
('Amul','Grocery'),
('Nestle','Grocery'),
('Britannia','Grocery'),
('Tata','Grocery'),
('Aashirvaad','Grocery'),
('Fortune','Grocery'),
('Parle','Grocery'),
('Patanjali','Grocery'),

-- Fashion
('Levis','Fashion'),
('Raymond','Fashion'),
('Allen Solly','Fashion'),
('Van Heusen','Fashion'),
('Louis Philippe','Fashion'),
('Peter England','Fashion'),
('Biba','Fashion'),
('W','Fashion'),

-- Sports
('Nike','Sports'),
('Adidas','Sports'),
('Puma','Sports'),
('Reebok','Sports'),
('Yonex','Sports'),
('Cosco','Sports'),
('Nivia','Sports'),
('Decathlon','Sports'),

-- Furniture
('Godrej','Furniture'),
('Nilkamal','Furniture'),
('Durian','Furniture'),
('Urban Ladder','Furniture'),
('IKEA','Furniture'),
('Home Centre','Furniture'),
('Damro','Furniture'),
('Pepperfry','Furniture'),

-- Beauty
('Lakme','Beauty'),
('L Oreal','Beauty'),
('Maybelline','Beauty'),
('Nivea','Beauty'),
('Dove','Beauty'),
('Himalaya','Beauty'),
('Biotique','Beauty'),
('Mamaearth','Beauty'),

-- Toys
('Lego','Toys'),
('Funskool','Toys'),
('Mattel','Toys'),
('Hot Wheels','Toys'),
('Barbie','Toys'),
('Hamleys','Toys'),
('Hasbro','Toys'),
('Fisher Price','Toys');