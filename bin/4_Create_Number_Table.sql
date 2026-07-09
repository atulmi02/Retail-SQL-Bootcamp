-- Inserting 1 million rows
SET SESSION cte_max_recursion_depth = 100000;
INSERT INTO Numbers (N)
WITH RECURSIVE cte AS
(
    SELECT 1 AS N
    UNION ALL
    SELECT N + 1
    FROM cte
    WHERE N < 100000
)
SELECT N
FROM cte;
