/*
05_Create DimEmployee
*/
/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 05_Create_DimEmployee.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimEmployee;

CREATE TABLE DimEmployee
(
    EmployeeKey        INT AUTO_INCREMENT PRIMARY KEY,

    EmployeeID         VARCHAR(20) NOT NULL UNIQUE,

    EmployeeName       VARCHAR(100) NOT NULL,

    Gender             ENUM('Male','Female') NOT NULL,

    Designation        VARCHAR(50) NOT NULL,

    StoreKey           INT NOT NULL,

    HireDate           DATE NOT NULL,

    Salary             DECIMAL(10,2) NOT NULL,

    Email              VARCHAR(100) UNIQUE,

    Phone              VARCHAR(20),

    IsActive           BOOLEAN DEFAULT TRUE,

    CreatedDate        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Employee_Store
        FOREIGN KEY (StoreKey)
        REFERENCES DimStore(StoreKey)
);

/*
Create Index
*/
CREATE INDEX IX_DimEmployee_Store
ON DimEmployee(StoreKey);

CREATE INDEX IX_DimEmployee_Designation
ON DimEmployee(Designation);

CREATE INDEX IX_DimEmployee_Active
ON DimEmployee(IsActive);

/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 05_Load_DimEmployee.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM DimEmployee;

INSERT INTO DimEmployee
(
    EmployeeID,
    EmployeeName,
    Gender,
    Designation,
    StoreKey,
    HireDate,
    Salary,
    Email,
    Phone,
    IsActive
)

SELECT

CONCAT('EMP',LPAD(n.NumberID,5,'0')),

CONCAT(
ELT((n.NumberID % 20)+1,
'Amit','Rahul','Rohit','Vikas','Suresh',
'Pankaj','Ankit','Deepak','Vivek','Manoj',
'Priya','Neha','Pooja','Sneha','Kavita',
'Anjali','Riya','Swati','Megha','Divya'),
' ',
ELT((n.NumberID % 20)+1,
'Sharma','Verma','Gupta','Patel','Singh',
'Yadav','Kumar','Joshi','Mishra','Pandey',
'Agarwal','Kapoor','Jain','Sinha','Das',
'Reddy','Nair','Iyer','Chauhan','Mehta')
),

CASE
WHEN MOD(n.NumberID,2)=0
THEN 'Male'
ELSE 'Female'
END,

CASE
WHEN MOD(n.NumberID,10)=1 THEN 'Store Manager'
WHEN MOD(n.NumberID,10)=2 THEN 'Assistant Manager'
WHEN MOD(n.NumberID,10) IN (3,4,5) THEN 'Sales Associate'
WHEN MOD(n.NumberID,10) IN (6,7) THEN 'Cashier'
WHEN MOD(n.NumberID,10)=8 THEN 'Inventory Executive'
ELSE 'Customer Service Executive'
END,

((n.NumberID-1) % 50)+1,

DATE_ADD('2019-01-01',INTERVAL MOD(n.NumberID*23,2190) DAY),

CASE
WHEN MOD(n.NumberID,10)=1 THEN 70000
WHEN MOD(n.NumberID,10)=2 THEN 50000
WHEN MOD(n.NumberID,10) IN (3,4,5) THEN 32000
WHEN MOD(n.NumberID,10) IN (6,7) THEN 28000
WHEN MOD(n.NumberID,10)=8 THEN 35000
ELSE 30000
END,

CONCAT('employee',LPAD(n.NumberID,5,'0'),'@retailmart.com'),

CONCAT('9',LPAD(MOD(n.NumberID*4567891,1000000000),9,'0')),

CASE
WHEN MOD(n.NumberID,20)=0
THEN FALSE
ELSE TRUE
END

FROM H_Numbers n

WHERE n.NumberID<=200;