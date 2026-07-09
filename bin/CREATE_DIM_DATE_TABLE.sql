-- CREATE DIM DATE Table
DROP TABLE IF EXISTS DimDate;

CREATE TABLE DimDate
(
    DateKey            INT PRIMARY KEY,
    FullDate           DATE NOT NULL,

    CalendarDay        TINYINT NOT NULL,
    DayName            VARCHAR(10) NOT NULL,

    CalendarMonth      TINYINT NOT NULL,
    MonthName          VARCHAR(15) NOT NULL,
    MonthShortName     CHAR(3) NOT NULL,

    CalendarQuarter    TINYINT NOT NULL,
    CalendarYear       SMALLINT NOT NULL,

    WeekNumber         TINYINT NOT NULL,
    DayOfYear          SMALLINT NOT NULL,

    IsWeekend          BOOLEAN NOT NULL,

    FinancialMonth     TINYINT NOT NULL,
    FinancialQuarter   TINYINT NOT NULL,
    FinancialYear      VARCHAR(9) NOT NULL,

    IsMonthStart       BOOLEAN NOT NULL,
    IsMonthEnd         BOOLEAN NOT NULL,

    IsQuarterStart     BOOLEAN NOT NULL,
    IsQuarterEnd       BOOLEAN NOT NULL,

    IsYearStart        BOOLEAN NOT NULL,
    IsYearEnd          BOOLEAN NOT NULL,

    IsHoliday          BOOLEAN DEFAULT FALSE,
    HolidayName        VARCHAR(50),

    FestivalName       VARCHAR(50)
);