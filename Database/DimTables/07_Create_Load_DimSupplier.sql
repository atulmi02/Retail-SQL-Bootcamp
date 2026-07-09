/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 07_Create_DimSupplier.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimSupplier;

CREATE TABLE DimSupplier
(
    SupplierKey        INT AUTO_INCREMENT PRIMARY KEY,

    SupplierID         VARCHAR(20) NOT NULL UNIQUE,

    SupplierName       VARCHAR(100) NOT NULL,

    ContactPerson      VARCHAR(100),

    Phone              VARCHAR(20),

    Email              VARCHAR(100),

    City               VARCHAR(50),

    State              VARCHAR(50),

    Country            VARCHAR(50) DEFAULT 'India',

    SupplierCategory   VARCHAR(50),

    Rating             DECIMAL(2,1),

    LeadTimeDays       INT,

    IsActive           BOOLEAN DEFAULT TRUE,

    CreatedDate        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/*
Create Index
*/
CREATE INDEX IX_DimSupplier_Category
ON DimSupplier(SupplierCategory);

CREATE INDEX IX_DimSupplier_State
ON DimSupplier(State);

CREATE INDEX IX_DimSupplier_Rating
ON DimSupplier(Rating);

CREATE INDEX IX_DimSupplier_Active
ON DimSupplier(IsActive);

/*
Load dim supplier
*/
/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 07_Load_DimSupplier.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE DimSupplier;

INSERT INTO DimSupplier
(
    SupplierID,
    SupplierName,
    ContactPerson,
    Phone,
    Email,
    City,
    State,
    Country,
    SupplierCategory,
    Rating,
    LeadTimeDays,
    IsActive
)

SELECT

CONCAT('SUP',LPAD(n.NumberID,4,'0')),

CONCAT(
ELT((n.NumberID % 15)+1,
'Tech Distributors',
'Fresh Foods',
'Fashion Hub',
'Sports World',
'Home Solutions',
'Furniture House',
'Beauty Care',
'Kitchen Essentials',
'Digital World',
'Prime Suppliers',
'National Traders',
'Metro Supply',
'Elite Distribution',
'Smart Retail',
'Universal Supply'),
' ',
n.NumberID
),

CONCAT(
ELT((n.NumberID % 20)+1,
'Amit','Rahul','Rohit','Vikas','Suresh',
'Ankit','Deepak','Vivek','Manoj','Pankaj',
'Priya','Neha','Pooja','Sneha','Riya',
'Anjali','Divya','Megha','Kavita','Swati'),
' ',
ELT((n.NumberID % 20)+1,
'Sharma','Gupta','Singh','Verma','Patel',
'Yadav','Kumar','Joshi','Pandey','Mishra',
'Kapoor','Jain','Sinha','Das','Reddy',
'Nair','Iyer','Mehta','Chauhan','Agarwal')
),

CONCAT('9',LPAD(MOD(n.NumberID*6543217,1000000000),9,'0')),

CONCAT('supplier',LPAD(n.NumberID,4,'0'),'@retailmart.com'),

c.CityName,

c.StateName,

'India',

ELT((n.NumberID % 8)+1,
'Electronics',
'Home Appliances',
'Grocery',
'Fashion',
'Sports',
'Furniture',
'Beauty',
'Toys'
),

ROUND(3.5 + (RAND()*1.5),1),

5 + MOD(n.NumberID,16),

CASE
WHEN MOD(n.NumberID,20)=0 THEN FALSE
ELSE TRUE
END

FROM H_Numbers n

JOIN H_Cities c
ON c.CityID=((n.NumberID-1)%25)+1

WHERE n.NumberID<=100;