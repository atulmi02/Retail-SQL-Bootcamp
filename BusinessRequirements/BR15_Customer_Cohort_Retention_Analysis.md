# BR#15 Customer Cohort Retention Analysis

## Business Requirement

The Marketing Director wants to understand whether newly accquired customers continue purchasing after their first completed purchase.

The report should analyze customer retention by grouping customers into cohorts based on their first purchase month during calendar year 2025.

## Business Objectives

- How many new customers were acquired each month?
- How many customers returned in subsequent months?
- What is customer retention rate?
- Which customer cohort has highest retention rate?
- Which customer cohort is losing customers the fastest?

## Grain of report

**One row represent the repeat purchase performance of single customer cohort for single activity month during calendar year 2025**

### Example :-

| CohortMonth | ActivityMonth | CohortSize | RepeatCustomers | Retention% |
| ----------- | ------------- | ---------: | --------------: | ---------: |
| Jan         | Jan           |        120 |             120 |    100.00% |
| Jan         | Feb           |        120 |              78 |     65.00% |
| Jan         | Mar           |        120 |              60 |     50.00% |
| Jan         | Apr           |        120 |              48 |     40.00% |
| Feb         | Feb           |        150 |             150 |    100.00% |
| Feb         | Mar           |         95 |              95 |     63.33% |
| Feb         | Apr           |         70 |              70 |     46.67% |

---

## Description of Cohort
```
A cohort is a group of customers who share the same first completed purchase month.
Cohort analysis separates customer acquisition from customer retention.
Once assigned, a customer always remains in the same cohort regardless of future purchases.

```
That group becomes a fixed group that we track over time.

### Example

Suppose these are your first purchases:

| Customer | First Purchase	| Cohort  |
|----------|----------------|---------|
|   C001   |    10-Jan-2025	| January |
|C002|	18-Jan-2025         | January |
|C003|	05-Feb-2025	        | February |
|C004|	20-Feb-2025	    | February |
|C005|	08-Mar-2025	| March |

Now you have three independent cohorts:

January Cohort → C001, C002
February Cohort → C003, C004
March Cohort → C005

Then we track them

Suppose they purchase like this:

| Customer	| Jan	| Feb	| Mar	| Apr |
|-----------|-------|-------|-------|-----|
| C001 |	✅ |	✅ |	❌ |	✅ |
| C002 |	✅ |	❌ |	✅ |	❌ |
| C003 |	❌ |	✅ |	✅ |	❌ |
| C004 |	❌ |	✅ |	❌ |	✅ |
| C005 |	❌ |	❌ |	✅ |	✅ |

Now summarize by cohort:

| Cohort   | New Customers | Jan | Feb | Mar | Apr |
| -------- | ------------: | --: | --: | --: | --: |
| January  |             2 |   2 |   1 |   1 |   1 |
| February |             2 |   - |   2 |   1 |   1 |
| March    |             1 |   - |   - |   1 |   1 |

### Skills to learn

- Finding the first purchase of each customer using MIN()
- Assigning customers to a cohort
- Self-joining customer activity with cohort information
- Calculating months since acquisition
- Using COUNT(DISTINCT CustomerKey) correctly
- Computing retention percentages
- Thinking in terms of customer lifecycle rather than monthly sales

### Business Concepts to learn

- Find each customer's first order.
- Calculate customer retention.
- Build a cohort analysis.
- Measure repeat purchase behavior.
- Identify churn

### This will answer to multiple business questions:
Customer Retention Analysis
Customer Churn Analysis
Subscription Renewal Analysis
User Engagement Analysis
App Retention Dashboards

---

## KPIs

| KPI           |    Definition             |
|---------------|---------------------------|
| Cohort Month  | Month of customer's first completed purchase. |
| Activity Month | Month on which customer made a completed purchase |
| Cohort Size | Number of customers acquired in that cohort |
| Active customers | Number of customers from that cohort who purchased in the activity month |
| Retention % | AcitveCustomers / Cohort size * 100 |
| Month since acquisition | Number of months between CohortMonth and ActivityMonth |

## Table Required

Fact Sales
- dateKey
- customerKey
- orderNumber
- salesStatus
  
Dim Date
- dateKey
- fullDate
- calendarYear
- calendarMonth
- monthName

## SQL Concepts

- Min
- COUNT(DISTINCT)
- INNER JOIN
- CTEs
- CASE
- GROUP BY
- DATEDIFF()
- TIMESTAMPDIFF()
- Window Function

## Query Design

### CTE 1- CustomerFirstPurchase
    First completed purchase of every customer

### CTE 2- CustomerActivity
    Retrieve every completed purchase for every customer.

### CTE 3- CustomerCohort
    Assgin each purchase to its cohort month

### CTE 4- CohortSummary
    Calculate cohort size and active customers

### CTE 5- CohortRetention
    Calcluate retention percentage and months since acquisition.

## Business Formula

- Retention  = Active Customer / Cohort Size
- Retention % = Retention * 100
- Months Since Acquisition = ActivityCalendarMonth - CohortCalendarMonth