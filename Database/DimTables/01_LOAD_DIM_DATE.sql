/******************************************************************************
Project      : Retail ERP Data Warehouse
Script       : 01_Load_DimDate.sql
Database     : Retail_SQL_Bootcamp
******************************************************************************/

USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM DimDate;

SET SESSION cte_max_recursion_depth = 2000;

INSERT INTO DimDate
(
    DateKey,
    FullDate,
    CalendarDay,
    DayName,
    DayOfWeek,
    DayOfYear,
    CalendarMonth,
    MonthName,
    MonthShortName,
    CalendarQuarter,
    QuarterName,
    CalendarYear,
    WeekNumber,
    FinancialMonth,
    FinancialQuarter,
    FinancialYear,
    IsWeekend,
    IsMonthStart,
    IsMonthEnd,
    IsQuarterStart,
    IsQuarterEnd,
    IsYearStart,
    IsYearEnd,
    IsHoliday,
    HolidayName,
    FestivalName
)

WITH RECURSIVE DateSeries AS
(
    SELECT DATE('2023-01-01') AS FullDate

    UNION ALL

    SELECT DATE_ADD(FullDate,INTERVAL 1 DAY)

    FROM DateSeries

    WHERE FullDate < '2025-12-31'
)

SELECT

DATE_FORMAT(FullDate,'%Y%m%d')+0,

FullDate,

DAY(FullDate),

DAYNAME(FullDate),

DAYOFWEEK(FullDate),

DAYOFYEAR(FullDate),

MONTH(FullDate),

MONTHNAME(FullDate),

DATE_FORMAT(FullDate,'%b'),

QUARTER(FullDate),

CONCAT('Q',QUARTER(FullDate)),

YEAR(FullDate),

WEEK(FullDate,1),

CASE
WHEN MONTH(FullDate)>=4
THEN MONTH(FullDate)-3
ELSE MONTH(FullDate)+9
END,

CASE

WHEN MONTH(FullDate) BETWEEN 4 AND 6 THEN 1
WHEN MONTH(FullDate) BETWEEN 7 AND 9 THEN 2
WHEN MONTH(FullDate) BETWEEN 10 AND 12 THEN 3
ELSE 4

END,

CASE

WHEN MONTH(FullDate)>=4
THEN CONCAT(YEAR(FullDate),'-',RIGHT(YEAR(FullDate)+1,2))

ELSE CONCAT(YEAR(FullDate)-1,'-',RIGHT(YEAR(FullDate),2))

END,

CASE

WHEN DAYOFWEEK(FullDate) IN (1,7)
THEN TRUE
ELSE FALSE

END,

CASE
WHEN DAY(FullDate)=1
THEN TRUE
ELSE FALSE
END,

CASE
WHEN FullDate=LAST_DAY(FullDate)
THEN TRUE
ELSE FALSE
END,

CASE

WHEN MONTH(FullDate) IN (1,4,7,10)
AND DAY(FullDate)=1
THEN TRUE
ELSE FALSE

END,

CASE

WHEN FullDate IN
(
LAST_DAY(CONCAT(YEAR(FullDate),'-03-01')),
LAST_DAY(CONCAT(YEAR(FullDate),'-06-01')),
LAST_DAY(CONCAT(YEAR(FullDate),'-09-01')),
LAST_DAY(CONCAT(YEAR(FullDate),'-12-01'))
)
THEN TRUE
ELSE FALSE

END,

CASE

WHEN MONTH(FullDate)=1
AND DAY(FullDate)=1
THEN TRUE
ELSE FALSE

END,

CASE

WHEN MONTH(FullDate)=12
AND DAY(FullDate)=31
THEN TRUE
ELSE FALSE

END,

FALSE,

NULL,

NULL

FROM DateSeries;