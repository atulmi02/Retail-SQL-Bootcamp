TRUNCATE TABLE StageSales;

INSERT INTO StageSales
(
    OrderNumber,
    OrderDate,
    CustomerKey,
    ProductKey,
    StoreKey,
    EmployeeKey,
    PromotionKey,
    SalesQuantity,
    SalesStatus
)

SELECT

CONCAT('ORD',LPAD(n.NumberID,8,'0')),

DATE_ADD('2023-01-01',
INTERVAL ((n.NumberID-1)%1096) DAY),

((n.NumberID-1)%2000)+1,

((n.NumberID-1)%500)+1,

((n.NumberID-1)%50)+1,

sem.EmployeeKey,

((n.NumberID-1)%20)+1,

CASE
    WHEN MOD(n.NumberID,20)=0 THEN 5
    WHEN MOD(n.NumberID,10)=0 THEN 4
    WHEN MOD(n.NumberID,5)=0 THEN 3
    WHEN MOD(n.NumberID,2)=0 THEN 2
    ELSE 1
END,

'Pending'

FROM H_Numbers n

JOIN H_StoreEmployeeMap sem
ON sem.StoreKey=((n.NumberID-1)%50)+1
AND sem.EmployeeNo=((n.NumberID-1)%4)+1

WHERE n.NumberID<=100000;
/*
Validation

SELECT
COUNT(*) AS InvalidAssignments
FROM StageSales s
JOIN DimEmployee e
ON s.EmployeeKey = e.EmployeeKey
WHERE s.StoreKey <> e.StoreKey;

*/