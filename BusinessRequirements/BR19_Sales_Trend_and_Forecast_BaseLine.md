# BR #19 - Sales Trend and Forecast Baseline

## Business Requirement

The Sales Management team wants to analyze historical sales trends and identify sales growth pattern over time.
The report should measure sales performance across months, detect, trends, compare growth with previous periods, and establish a baseline for future sales forecasting.

## Business Objectives

- How are sales trending over time?
- Which months shows the highest and lowest sales?
- Is sales performance improving or declining?
- What is MoM growth?
- What is YoY growth?
- What is cumulative sales trend?
- What is the three months moving average sales trend?
- What baseline trend can be used for future forecasting?

## Grain of Report

**One row of report represents total completed sales for one month with metrics MoM growth, YoY growth, cumulative sales**

## KPIs

**Sales KPIs**
- GrossSales
- TotalOrders
- TotalQtySold
- AvgOrderValue

**Trend KPIs**
- CumulativeSales
- 3-Month Moving Average 
- Previous Month Sales
- MoM Growth %
- Previous Year Same Month Sales(PreviousYearSales)
- YoY Growth %

**Forecast KPIs**
- Trend Direction
- Baseline Forecast

## Tables Required

FactSales
- DateKey
- SalesAmount
- OrderNumber
- Quantity
- SalesStatus

DimDate
- DateKey
- CalendarYear
- MonthNumber
- MonthName

## Output

| Year | Month | GrossSales | Orders | Quantity | AvgOrderValue | Running Total | 3-Month Avg | Previous Month | MoM % | Previous Year | YoY % | Trend | Forecast |

## Business Formula

1. GrossSales = SUM(salesAmount)
2. AvgOrderValue = GrossSales / Orders
3. RunningTotal = SUM(GrossSales) Over ( Order By Year, Month)
4. 3-MonthMovingAvg = AVG(GrossSales) Over ( Order By Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
5. PrevMonthSales = LAG(GrossSales)
6. MoMGrowth = (CurrentMonth - PreviousMonth) / PreviousMonth *100
7. PrevYearSales = LAG(GrossSales,12)
8. YoYGrowth = (CurrentMonthSales - PreviousYearSameMonth) / PreviousYearSameMonth *100
9. ForecastNextMonth = 3 MonthMovingAvg  

### Trend Direction

|   Condition | Trend     |
|----:        |----:      |
| MoM > 0     | Growing   |
| MoM < 0     | Declining |
| MoM = 0     | Stable    |

## Query Design

### CTE 1 - MonthlySales
Aggregate :
    
    GrossSales
    QuantitySold
    TotalOrders
    CalendarYear
    CalendarMonth

### CTE 2 - SalesTrend
Calculate:

    RunningTotal
    MovingAverage
    PrevMonthSales
    PrevYearSales

### CTE 3 - GrowthMetrics
Calculate:

    MoMGrowth%
    YoYGrowth%
    AvgOrderValue
    TrendDirection
    ForecastBaseline

## SQL Concepts Covered

- Aggregate Functions
- Window Functions
- LAG()
- Running Totals
- Moving Average
- Date Intelligence
- Month-over-Month Analysis
- Year-over-Year Analysis
- Trend Analysis
- Forecast Baseline

---

*Production Review*

    • Scalability
    • Index Recommendations
    • Expected Execution Plan
    • Optimization Opportunities
    • Senior SQL Developer Review

Power BI Visualization Ideas (optional)

Interview Questions