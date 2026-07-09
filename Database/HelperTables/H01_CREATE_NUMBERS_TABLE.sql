/* CREATE NUMBERS TABLE AND LOAD WITH NUMBERS TILL 1Million
*/
USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS Numbers;

CREATE TABLE Numbers
(
    N INT PRIMARY KEY
);

SET SESSION cte_max_recursion_depth = 100000;

INSERT INTO Numbers (N)
WITH RECURSIVE NumberSeries AS
(
    SELECT 1 AS N

    UNION ALL

    SELECT N + 1
    FROM NumberSeries
    WHERE N < 100000
)

SELECT N
FROM NumberSeries;
