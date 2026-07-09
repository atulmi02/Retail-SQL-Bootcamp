/******************************************************************************
Project      : Retail ERP Data Warehouse
Script       : 01_Create_DimDate.sql
Database     : Retail_SQL_Bootcamp
Author       : Atul Kumar Keshari
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimDate;

CREATE TABLE DimDate
(
    DateKey              INT             NOT NULL,
    FullDate             DATE            NOT NULL,

    CalendarDay          TINYINT         NOT NULL,
    DayName              VARCHAR(10)     NOT NULL,
    DayOfWeek            TINYINT         NOT NULL,
    DayOfYear            SMALLINT        NOT NULL,

    CalendarMonth        TINYINT         NOT NULL,
    MonthName            VARCHAR(15)     NOT NULL,
    MonthShortName       CHAR(3)         NOT NULL,

    CalendarQuarter      TINYINT         NOT NULL,
    QuarterName          VARCHAR(2)      NOT NULL,

    CalendarYear         SMALLINT        NOT NULL,
    WeekNumber           TINYINT         NOT NULL,

    FinancialMonth       TINYINT         NOT NULL,
    FinancialQuarter     TINYINT         NOT NULL,
    FinancialYear        VARCHAR(9)      NOT NULL,

    IsWeekend            BOOLEAN         NOT NULL DEFAULT FALSE,

    IsMonthStart         BOOLEAN         NOT NULL DEFAULT FALSE,
    IsMonthEnd           BOOLEAN         NOT NULL DEFAULT FALSE,

    IsQuarterStart       BOOLEAN         NOT NULL DEFAULT FALSE,
    IsQuarterEnd         BOOLEAN         NOT NULL DEFAULT FALSE,

    IsYearStart          BOOLEAN         NOT NULL DEFAULT FALSE,
    IsYearEnd            BOOLEAN         NOT NULL DEFAULT FALSE,

    IsHoliday            BOOLEAN         NOT NULL DEFAULT FALSE,
    HolidayName          VARCHAR(50)     DEFAULT NULL,

    FestivalName         VARCHAR(50)     DEFAULT NULL,

    CreatedDate          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_DimDate PRIMARY KEY (DateKey),

    CONSTRAINT UK_DimDate_FullDate UNIQUE (FullDate)
);
CREATE INDEX IX_DimDate_Year
ON DimDate(CalendarYear);

CREATE INDEX IX_DimDate_Month
ON DimDate(CalendarMonth);

CREATE INDEX IX_DimDate_Quarter
ON DimDate(CalendarQuarter);

CREATE INDEX IX_DimDate_Week
ON DimDate(WeekNumber);

CREATE INDEX IX_DimDate_FinancialYear
ON DimDate(FinancialYear);

CREATE INDEX IX_DimDate_IsWeekend
ON DimDate(IsWeekend);