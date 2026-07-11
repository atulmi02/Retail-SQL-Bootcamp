/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : H01_Create_Numbers.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_Numbers;

CREATE TABLE H_Numbers
(
    NumberID INT PRIMARY KEY
);

/*
Load Numbers
*/
SET SESSION cte_max_recursion_depth = 100000;

INSERT INTO H_Numbers(NumberID)

WITH RECURSIVE NumberSeries AS
(
    SELECT 1 AS NumberID

    UNION ALL

    SELECT NumberID + 1
    FROM NumberSeries
    WHERE NumberID < 100000
)

SELECT NumberID
FROM NumberSeries;

/*
Validation
*/
SELECT min(numberid) AS MinNumber, max(numberid) AS MaxNumber, count(*) AS TotalNumbers
FROM H_Numbers;