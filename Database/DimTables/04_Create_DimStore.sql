/*
04_Create DimStore
*/
/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 04_Create_DimStore.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE DimEmployee;
TRUNCATE TABLE DimStore;

DROP TABLE IF EXISTS DimStore;

SET FOREIGN_KEY_CHECKS = 1;
CREATE TABLE DimStore
(
    StoreKey        INT AUTO_INCREMENT PRIMARY KEY,

    StoreID         VARCHAR(20) NOT NULL UNIQUE,

    StoreName       VARCHAR(100) NOT NULL,

    City            VARCHAR(50) NOT NULL,

    State           VARCHAR(50) NOT NULL,

    Region          VARCHAR(20) NOT NULL,

    StoreType       VARCHAR(30) NOT NULL,

    OpenDate        DATE NOT NULL,

    IsActive        BOOLEAN DEFAULT TRUE,

    CreatedDate     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
Index DimStore
*/
CREATE INDEX IX_DimStore_City
ON DimStore(City);

CREATE INDEX IX_DimStore_State
ON DimStore(State);

CREATE INDEX IX_DimStore_Region
ON DimStore(Region);

CREATE INDEX IX_DimStore_Type
ON DimStore(StoreType);

/*
Load Dim Store
*/
USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM DimStore;

INSERT INTO DimStore
(
    StoreID,
    StoreName,
    City,
    State,
    Region,
    StoreType,
    OpenDate,
    IsActive
)

SELECT

CONCAT('STR',LPAD(n.NumberID,4,'0')),

CONCAT('RetailMart ',c.CityName,' ',n.NumberID),

c.CityName,

s.StateName,

s.Region,

CASE
WHEN MOD(n.NumberID,3)=1 THEN 'Mall'
WHEN MOD(n.NumberID,3)=2 THEN 'High Street'
ELSE 'Standalone'
END,

DATE_ADD('2018-01-01',INTERVAL MOD(n.NumberID*37,2555) DAY),

CASE
WHEN MOD(n.NumberID,25)=0 THEN FALSE
ELSE TRUE
END

FROM H_Numbers n

JOIN H_Cities c
ON c.CityID=((n.NumberID-1)%25)+1

JOIN H_States s
ON s.StateName=c.StateName

WHERE n.NumberID<=50;