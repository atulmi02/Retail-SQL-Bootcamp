/*
H07_Create H_ProductMaster
*/
/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : H06_Create_ProductMaster.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_ProductMaster;

CREATE TABLE H_ProductMaster
(
    ProductMasterID INT AUTO_INCREMENT PRIMARY KEY,

    CategoryName    VARCHAR(50) NOT NULL,

    BrandName       VARCHAR(50) NOT NULL,

    ProductName     VARCHAR(100) NOT NULL,

    SubCategory     VARCHAR(50),

    UnitCost        DECIMAL(10,2),

    UnitPrice       DECIMAL(10,2)
);

/*
Load H_ProductMaster
*/

INSERT INTO H_ProductMaster
(CategoryName,BrandName,ProductName,SubCategory,UnitCost,UnitPrice)

VALUES

-- ======================================================
-- ELECTRONICS
-- ======================================================

('Electronics','Apple','iPhone 15','Mobile',65000,79999),
('Electronics','Apple','MacBook Air M3','Laptop',85000,99999),
('Electronics','Samsung','Galaxy S24','Mobile',52000,64999),
('Electronics','Samsung','55 Inch Smart TV','Television',42000,52999),
('Electronics','Sony','Bravia 55 TV','Television',48000,59999),
('Electronics','Sony','Noise Cancelling Headphones','Audio',12000,15999),
('Electronics','Dell','Inspiron 15','Laptop',45000,56999),
('Electronics','HP','Pavilion Laptop','Laptop',48000,58999),
('Electronics','Boat','Airdopes 311','Audio',1200,1999),
('Electronics','JBL','Flip 6 Speaker','Audio',6500,8999),

-- ======================================================
-- HOME APPLIANCES
-- ======================================================

('Home Appliances','LG','Double Door Refrigerator','Refrigerator',32000,39999),
('Home Appliances','LG','Front Load Washing Machine','Washing Machine',28000,34999),
('Home Appliances','Whirlpool','Single Door Refrigerator','Refrigerator',18000,23999),
('Home Appliances','Bosch','Dishwasher','Kitchen',42000,52999),
('Home Appliances','Prestige','Pressure Cooker 5L','Cookware',1500,2499),
('Home Appliances','Philips','Air Fryer','Kitchen',5200,6999),
('Home Appliances','Havells','Ceiling Fan','Electrical',1800,2699),
('Home Appliances','Bajaj','Mixer Grinder','Kitchen',2200,3299),

-- ======================================================
-- GROCERY
-- ======================================================

('Grocery','Amul','Butter 500g','Dairy',210,250),
('Grocery','Amul','Cheese Slices','Dairy',180,230),
('Grocery','Nestle','Maggi Noodles','Instant Food',12,18),
('Grocery','Nestle','Nescafe Coffee','Beverages',280,360),
('Grocery','Britannia','Good Day Biscuits','Snacks',25,35),
('Grocery','Tata','Tata Tea Gold 1kg','Beverages',480,620),
('Grocery','Aashirvaad','Atta 10kg','Staples',360,450),
('Grocery','Fortune','Sunflower Oil 5L','Cooking Oil',720,920),

-- ======================================================
-- FASHION
-- ======================================================

('Fashion','Levis','Slim Fit Jeans','Men',1800,2999),
('Fashion','Levis','Casual Shirt','Men',1200,1899),
('Fashion','Allen Solly','Formal Shirt','Men',1400,2299),
('Fashion','Van Heusen','Formal Trouser','Men',1700,2699),
('Fashion','Louis Philippe','Blazer','Men',4500,6999),
('Fashion','Biba','Kurti','Women',900,1599),
('Fashion','W','Printed Kurta','Women',1200,1899),
('Fashion','Raymond','Suit Fabric','Men',2800,3999),

-- ======================================================
-- SPORTS
-- ======================================================

('Sports','Nike','Running Shoes','Footwear',3200,4999),
('Sports','Adidas','Sports T-Shirt','Apparel',900,1499),
('Sports','Puma','Track Pant','Apparel',1200,1899),
('Sports','Reebok','Training Shoes','Footwear',2800,4299),
('Sports','Yonex','Badminton Racquet','Equipment',1800,2999),
('Sports','Cosco','Football','Equipment',650,999),
('Sports','Nivia','Cricket Kit','Equipment',2800,3999),
('Sports','Decathlon','Yoga Mat','Fitness',550,899),

-- ======================================================
-- FURNITURE
-- ======================================================

('Furniture','Godrej','Steel Wardrobe','Bedroom',14500,18999),
('Furniture','Nilkamal','Plastic Chair','Living Room',650,999),
('Furniture','Durian','Office Chair','Office',4200,6499),
('Furniture','Urban Ladder','Queen Bed','Bedroom',18500,24999),
('Furniture','IKEA','Study Table','Office',4500,6999),
('Furniture','Home Centre','TV Unit','Living Room',5200,7999),
('Furniture','Damro','Dining Table','Dining',9500,13999),
('Furniture','Pepperfry','Bookshelf','Living Room',3800,5999),

-- ======================================================
-- BEAUTY
-- ======================================================

('Beauty','Lakme','Foundation','Makeup',280,450),
('Beauty','L''Oreal','Shampoo','Hair Care',320,499),
('Beauty','Maybelline','Mascara','Makeup',280,399),
('Beauty','Nivea','Body Lotion','Skin Care',180,299),
('Beauty','Dove','Soap Pack','Bath',110,175),
('Beauty','Himalaya','Face Wash','Skin Care',90,160),
('Beauty','Biotique','Moisturizer','Skin Care',180,280),
('Beauty','Mamaearth','Vitamin C Serum','Skin Care',420,699),

-- ======================================================
-- TOYS
-- ======================================================

('Toys','Lego','Classic Building Blocks','Educational',850,1299),
('Toys','Funskool','Monopoly','Board Game',450,699),
('Toys','Mattel','Barbie Dream Doll','Dolls',750,1199),
('Toys','Hot Wheels','Car Pack','Vehicles',280,499),
('Toys','Hasbro','Play Doh Set','Creative',320,499),
('Toys','Fisher Price','Learning Blocks','Educational',550,799),
('Toys','Hamleys','Soft Teddy Bear','Soft Toys',420,699),
('Toys','Barbie','Fashion Doll','Dolls',650,999);