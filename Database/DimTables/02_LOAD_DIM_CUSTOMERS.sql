/******************************************************************************
Project      : Retail ERP Data Warehouse
Script       : 02_Load_DimCustomer.sql
Database     : Retail_SQL_Bootcamp
******************************************************************************/

USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM DimCustomer;

INSERT INTO DimCustomer
(
    CustomerID,
    CustomerName,
    Gender,
    DateOfBirth,
    Age,
    Email,
    Phone,
    City,
    State,
    Country,
    PostalCode,
    CustomerSegment,
    JoinDate,
    IsActive
)

SELECT

CONCAT('CUST',LPAD(N,6,'0')),

CONCAT(
    ELT((N % 20)+1,
    'Aarav','Vivaan','Aditya','Vihaan','Arjun',
    'Sai','Krishna','Rohan','Rahul','Karan',
    'Priya','Ananya','Pooja','Sneha','Neha',
    'Aisha','Kavya','Meera','Diya','Riya'),
    ' ',
    ELT((N % 20)+1,
    'Sharma','Verma','Gupta','Patel','Singh',
    'Yadav','Kumar','Joshi','Nair','Reddy',
    'Iyer','Kapoor','Mehta','Jain','Agarwal',
    'Pandey','Mishra','Sinha','Chauhan','Das')
),

CASE
WHEN MOD(N,2)=0 THEN 'Male'
ELSE 'Female'
END,

DATE_ADD('1960-01-01',INTERVAL MOD(N*17,16000) DAY),

TIMESTAMPDIFF
(
YEAR,
DATE_ADD('1960-01-01',INTERVAL MOD(N*17,16000) DAY),
CURDATE()
),

CONCAT('customer',LPAD(N,6,'0'),'@retailmart.com'),

CONCAT
(
'9',
LPAD(MOD(N*9876543,1000000000),9,'0')
),

ELT((N % 10)+1,
'Delhi',
'Mumbai',
'Bengaluru',
'Hyderabad',
'Chennai',
'Pune',
'Kolkata',
'Ahmedabad',
'Jaipur',
'Lucknow'),

ELT((N % 10)+1,
'Delhi',
'Maharashtra',
'Karnataka',
'Telangana',
'Tamil Nadu',
'Maharashtra',
'West Bengal',
'Gujarat',
'Rajasthan',
'Uttar Pradesh'),

'India',

ELT((N % 10)+1,
'110001',
'400001',
'560001',
'500001',
'600001',
'411001',
'700001',
'380001',
'302001',
'226001'),

CASE

WHEN N<=200 THEN 'VIP'

WHEN N<=600 THEN 'Gold'

WHEN N<=1200 THEN 'Silver'

ELSE 'Regular'

END,

DATE_ADD('2021-01-01',INTERVAL MOD(N*13,1460) DAY),

CASE
WHEN MOD(N,20)=0 THEN FALSE
ELSE TRUE
END

FROM Numbers

WHERE N<=2000;