# BR#14B - Store Performance & Operational Health

## Dependency

This report consumes the output of BR#14A (StoreMonthlyTrend) and performs store-level aggregation and classification.

## Business Requirement

The Operations Director wants to identify stores that are consistently growing, consistently declining, or require operational attention based on their monthly sales performance during the calendar year 2025.

## Business Objectives

The report answer the following:

- Which stores are consistently growing?
- Which stores are consistently declining?
- Which stores require operational attention?
- How many months did each store experience growth?
- How many months did each store experience decline?
- What was the average MOM Growth % for each store?

## Grain Of Report

One row represents the overall sales performance of a single store for the calendar year 2025 based on its monthly sales trends.


### Reuse BR #14 A
StoreMonthlyTrend      <- Reuse BR14A
            │
StoreHealthSummary
            │
StoreClassification
            │
Final Select

## Query Design

### CTE 1- Reuse StoreMonthlyTrend
### CTE 2- StoreHealthSummary
    StoreKey
    GrowthMonths
    DeclineMonths
    AverageMOMGrowth
    BestMonthlyRank
    WorstMonthlyRank
    TotalGrossSales

### CTE 3- StorePerformanceClassification

    CASE
        Growing
        Declining
        Needs Attention
        Stable
    END

### FINAL SELECT

StoreID
StoreName
City
GrowthMonths
DeclineMonths
AverageMOMGrowth
BestMonthlyRank
WorstMonthlyRank
TotalGrossSales
StoreStatus

## Business Rule

| Metric          | Proposed Rule                                                |
| --------------- | ------------------------------------------------------------ |
| Growing Store   | MOM Growth > 0 for at least 8 months                         |
| Declining Store | MOM Growth < 0 for at least 8 months                         |
| Needs Attention | Average MOM Growth < -5% **or** more than 6 declining months |
| Stable          | Everything else                                              |

## Tables Required

StoreMonthlyTrend (Output of BR#14A)

- StoreKey
- CalendarMonth
- GrossSales
- MOMGrowth
- RunningSales
- StoreRank

DimStore

- StoreKey
- StoreID
- StoreName
- City

## KPIs

- Growth Months
- Decline Months
- Average MOM Growth %
- Best Monthly Rank
- Worst Monthly Rank
- Total Gross Sales
- Store Performance Status

## Production Considerations

- Reuse BR14A dataset instead of querying FactSales again.
- Aggregate before classification.
- Avoid duplicate calculations.
- Keep business rules configurable.
- Separate KPI calculation from business classification.