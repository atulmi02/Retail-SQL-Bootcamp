SELECT fs.customerKey,
            COUNT(DISTINCT orderNumber) AS frequency,
            SUM(fs.salesAmount) AS monetary,
            MAX(dd.fulldate) AS lastPurchase
    FROM FactSales AS fs
    INNER JOIN DimDate AS dd
        ON fs.dateKey = dd.dateKey
    WHERE fs.salesStatus = 'completed' AND dd.calendarYear = 2025
    GROUP BY fs.customerKey