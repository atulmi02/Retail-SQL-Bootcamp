**INTERVIEW QUESTION**

1. Explain the difference between GROUP BY and window functions?
       
    GROUP BY aggregates rows into groups and **returns one row per group**, reducing the number of rows in the result set.

    **Window functions** perform calculations across a set of related rows **without collapsing the result set**, so every original row is preserved while adding calculated values such as running totals, rankings, moving averages, or previous/next values.
    
2. Why use LAG() instead of a self-join?

    LAG() is preferred over a self-join because it is specifically designed to access previous or next rows within an ordered result set. It makes the query simpler, more readable, and usually more efficient.

    A self-join requires joining the dataset to itself, which increases query complexity and can require additional join processing.

    Window functions like LAG() operate over the existing result set without creating another logical copy of the table, allowing SQL Server to optimize the execution more effectively.

3. Why use NULLIF()?

    NULLIF() is used to prevent divide-by-zero errors. If the denominator is zero, 
    NULLIF() returns NULL instead of 0, so SQL Server returns NULL for the calculation rather than raising a runtime error.

4. Why aggregate before applying window functions?

    We aggregate before applying window functions to reduce the number of rows that the window functions need to process.

5. 