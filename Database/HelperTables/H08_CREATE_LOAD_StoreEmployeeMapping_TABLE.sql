USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_StoreEmployeeMap;

CREATE TABLE H_StoreEmployeeMap
(
    StoreKey     INT NOT NULL,
    EmployeeNo   INT NOT NULL,
    EmployeeKey  INT NOT NULL,

    PRIMARY KEY (StoreKey, EmployeeNo)
);
/*
LOAD HELPER TABLE
only after DimEmployee is populated 
*/
INSERT INTO H_StoreEmployeeMap
(
    StoreKey,
    EmployeeNo,
    EmployeeKey
)

SELECT
    StoreKey,
    ROW_NUMBER() OVER
    (
        PARTITION BY StoreKey
        ORDER BY EmployeeKey
    ) AS EmployeeNo,

    EmployeeKey

FROM DimEmployee;

/*
Validation

SELECT * FROM H_StoreEmployeeMap ORDER BY StoreKey, EmployeeNo LIMIT 20;
SELECT StoreKey,COUNT(*) AS Employees FROM H_StoreEmployeeMap GROUP BY StoreKey ORDER BY StoreKey;
*/