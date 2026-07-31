# BR  #16 - Customer Lifetime Value (CLV) Analysis

## Business Requirement 

The Marketing Director wants to identify the most valuable customers based on their purchasing behaviour during the calendar year 2025.

The report should evaluate customer value by analyzing their revenur contribution, purchasing frequency, and average spending.

## Business Objective

- Which customer generated highest revenue?
- Who are top 10 most valuable customers?
- Which customer place frequent orders?
- What is the average order value of each customer?
- Which customer contribute most to total sales?
- How should customer segmented based on their lifetime value?

## Grain of Report

**One row of report represent single customer performance for completed sales for the year 2025 including its gross sales,total orders,contribution to company total sales, average order value.**

## KPIs

- Active Days
- Average Order Value
- Contribution %
- Customer Rank
- Customer Segment - Contribution >= 5 Then Platinum, >= 2 Then Gold, >= 1 Then Silver Else Bronze
- Cumulative Contribution *Like Pareto Analysis*
- Add Top 20% 
- ABC Classification - Top 80% customers as A, 80-95 % as B, else C
  
## Tables 

- Reuse BR09 Output

---

### What is ABC Classification?

ABC Classification is based on the Pareto Principle (80/20 Rule).

The idea is:

```
A small percentage of customers (or products) generates most of the revenue.

Instead of looking at individual customer contribution, 
we look at the cumulative contribution after sorting customers from highest to lowest sales.
```

ABC Classification

A = first 80% cumulative revenue
B = next 15%
C = last 5%

Notice something important:

A customers are not the top 20% of customers.
They are the customers who together generate the first 80% of revenue.

Sometimes:

15% of customers generate 80% of sales.
Sometimes 22%.
Sometimes only 8%.

The classification depends on revenue, not the number of customers.

### Why retailers use it

Suppose you own a supermarket.

**Class A Customers**
    Highest revenue
    Highest purchase frequency
    VIP customers
    Personal offers
    Loyalty programs
    Priority service

**Class B Customers**
    Good customers
    Upselling opportunities
    Encourage them to become A customers

**Class C Customers**
    Low-value or infrequent customers
    Marketing campaigns
    Reactivation offers
    Analyze whether retaining them is profitable

**The same concept is used for products**
- Which products should always be in stock
- Which products deserve the most shelf space
- Which products need the closest inventory monitoring