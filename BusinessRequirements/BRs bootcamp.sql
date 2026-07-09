| BR         | Topic                         | Main Concepts                    |
| ---------- | ----------------------------- | -------------------------------- |
| **BR #5**  | Customer Lifetime Value (CLV) | CTEs, Aggregation                |
| **BR #6**  | RFM Analysis                  | NTILE(), CASE                    |
| **BR #7**  | Store Performance Dashboard   | Multi-level Aggregation          |
| **BR #8**  | Employee Performance          | Ranking, KPIs                    |
| **BR #9**  | Promotion Effectiveness       | Before/After Analysis            |
| **BR #10** | Profitability Analysis        | Gross Profit, Margin             |
| **BR #11** | Inventory Planning            | Rolling Average, Forecast Basics |
| **BR #12** | Executive Sales Dashboard     | 8–10 KPIs in one query           |
Advanced SQL Module

Once those business requirements are complete, we'll move into SQL Server–specific development topics:

✅ Views
✅ Stored Procedures
✅ User Defined Functions (UDFs)
✅ Temporary Tables
✅ Table Variables
✅ Dynamic SQL
✅ Transactions
✅ Error Handling (TRY...CATCH)
✅ Recursive CTEs
✅ MERGE
✅ Pivot / Unpivot
✅ Query Optimization
✅ Execution Plans
✅ Index Tuning
Enterprise-Level Module

This is where you'll reach a professional SQL Server developer level.

You'll learn:

Partitioned Tables
Columnstore Indexes
Covering Indexes
Filtered Indexes
Statistics
Parameter Sniffing
Deadlocks
Isolation Levels
SQL Server Agent Jobs
ETL Design
Slowly Changing Dimensions (SCD)
Incremental Loading
Portfolio Projects

By the end of the bootcamp, you'll have complete, GitHub-ready projects such as:

Retail Sales Analytics
Customer 360 Dashboard
Sales Performance Dashboard
Inventory Analytics
Executive KPI Dashboard
Promotion Analysis
Customer Segmentation (RFM)
Sales Forecasting Dataset
My Suggestion

Looking at your progress over the last few weeks, I'd like to make one enhancement to the bootcamp.

After every Business Requirement, we'll add a short "Production Review" section where we discuss:

Would this query scale to 100 million or 1 billion rows?
Which indexes would you create?
What execution plan would SQL Server likely generate?
Could the query be rewritten more efficiently?
How would a senior SQL developer review this code?

This bridges the gap between writing a correct query and writing one that's ready for production systems.

I think this addition fits well with your goal of becoming a strong SQL developer and data analyst, and it will also prepare you for technical interviews that go beyond syntax.

now continue with BR#4 and help for its documentation on md file

Absolutely. From now on, every Business Requirement in your GitHub project will follow a professional documentation template. This is exactly how SQL projects are documented in many organizations.

For BR #4, create a file named:

BR04_Monthly_Sales_Trend_Analysis.md

Use the following content.

# BR #4 - Monthly Sales Trend Analysis

## Business Requirement

The Sales Director wants to analyze monthly sales performance for the year 2025 to identify sales trends, monitor business growth, and compare monthly performance.

The report should provide one row for each month and include key performance indicators that help management understand how sales are progressing throughout the year.

---

## Business Objective

- Analyze monthly sales performance.
- Identify the highest and lowest performing months.
- Track cumulative sales throughout the year.
- Measure month-over-month (MoM) sales growth.
- Rank months based on sales performance.

---

## Grain

**One row represents one month in the year 2025 with aggregated sales metrics and analytical calculations.**

---

## Tables Required

### FactSales

| Column | Purpose |
|---------|---------|
| DateKey | Join with DimDate |
| OrderNumber | Calculate Total Orders |
| SalesAmount | Calculate Gross Sales |
| SalesStatus | Filter completed sales |

### DimDate

| Column | Purpose |
|---------|---------|
| DateKey | Join Key |
| CalendarYear | Filter Year 2025 |
| MonthNumber | Chronological ordering |
| MonthName | Display month in report |

---

## Table Relationships

```
FactSales
    |
    | DateKey
    |
DimDate
```

---

## KPIs

- Gross Sales
- Total Orders
- Running Sales
- Previous Month Sales
- Month-over-Month Growth %
- Monthly Sales Rank

---

## SQL Concepts Used

- Common Table Expressions (CTEs)
- GROUP BY
- SUM()
- COUNT(DISTINCT)
- Window Functions
- SUM() OVER()
- LAG()
- RANK()
- CAST()
- NULLIF()
- ROUND()

---

## Query Design

### CTE 1 - MonthlySales

Purpose

- Aggregate completed sales for each month in 2025.
- Calculate:
  - Gross Sales
  - Total Orders

---

### CTE 2 - MonthlyPerformance

Purpose

Using the monthly aggregated data calculate:

- Running Total Sales
- Previous Month Sales
- Monthly Sales Rank

---

### Final SELECT

Calculate

- Average formatting
- Month-over-Month Growth %
- Display user-friendly columns
- Sort the report

---

## Business Formula

### Gross Sales

```
SUM(SalesAmount)
```

### Total Orders

```
COUNT(DISTINCT OrderNumber)
```

### Running Sales

```
SUM(GrossSales)
OVER(
ORDER BY MonthNumber
)
```

### Previous Month Sales

```
LAG(GrossSales)
OVER(
ORDER BY MonthNumber
)
```

### Month-over-Month Growth

```
(
Current Month Sales
-
Previous Month Sales
)
/
Previous Month Sales
*
100
```

### Monthly Rank

```
RANK()
OVER(
ORDER BY GrossSales DESC
)
```

---

## Expected Output

| Month | Gross Sales | Total Orders | Running Sales | Previous Month Sales | MoM Growth % | Sales Rank |
|--------|------------:|-------------:|--------------:|---------------------:|-------------:|-----------:|

---

## Performance Considerations

Recommended indexes

### FactSales

```
(DateKey, SalesStatus)
INCLUDE
(
SalesAmount,
OrderNumber
)
```

### DimDate

```
(CalendarYear, DateKey)
```

---

## Production Considerations

- Filter data as early as possible.
- Aggregate before applying window functions.
- Use NULLIF() to prevent divide-by-zero errors.
- Round only presentation values.
- Keep window functions in the same CTE whenever possible.
- Avoid unnecessary joins.
- Ensure indexes support filtering and grouping columns.

---

## Learning Outcome

After completing this Business Requirement, you will understand:

- Time-series analysis
- Running totals
- Previous period comparison
- Window functions
- Analytical reporting
- Query optimization basics
Folder Structure

Your project should now look like:

Retail-SQL-Bootcamp
│
├── README.md
│
├── Database
│   ├── CreateTables.sql
│   ├── CreateIndexes.sql
│   └── InsertData.sql
│
├── BusinessRequirements
│   ├── BR01_Top_Customers.sql
│   ├── BR01_Top_Customers.md
│   ├── BR02_Product_NetSales.sql
│   ├── BR02_Product_NetSales.md
│   ├── BR03_Customer_Purchase_Behaviour.sql
│   ├── BR03_Customer_Purchase_Behaviour.md
│   ├── BR04_Monthly_Sales_Trend.sql
│   └── BR04_Monthly_Sales_Trend.md
│
├── ExecutionPlans
│   ├── BR01.sqlplan
│   ├── BR02.sqlplan
│   ├── BR03.sqlplan
│   └── BR04.sqlplan
│
└── Images
    ├── BR01_Output.png
    ├── BR02_Output.png
    ├── BR03_Output.png
    └── BR04_Output.png
Next Step: Write the SQL

We'll continue with BR #4 exactly as we did for BR #2 and BR #3:

CTE 1: MonthlySales (aggregate monthly sales and orders)
CTE 2: MonthlyPerformance (running total, previous month sales, and rank using window functions)
Final SELECT: Calculate MoM Growth %, apply formatting, and sort the results.

This approach keeps the query clean, scalable, and aligned with SQL Server best practices.

which tool for md creation

Since you're building a professional GitHub portfolio, here are the tools I recommend in order of preference.

🥇 Option 1: Visual Studio Code (Recommended ⭐⭐⭐⭐⭐)

This is what professional developers use.

Install
Visual Studio Code
Markdown All in One extension
Markdown Preview Enhanced (optional)
Features
Live Markdown preview (Ctrl + Shift + V)
Git integration
Syntax highlighting
Easy image embedding
Table formatting
Direct GitHub compatibility

Example folder:

Retail-SQL-Bootcamp/
│
├── README.md
├── BusinessRequirements/
│   ├── BR01.md
│   ├── BR02.md
│   ├── BR03.md
│   └── BR04.md
🥈 Option 2: Typora ⭐⭐⭐⭐⭐

Best if you enjoy writing documentation.

Advantages:

Live preview
Beautiful formatting
Tables
Images
Drag-and-drop support

The free version is older, while newer versions are paid.

🥉 Option 3: Obsidian ⭐⭐⭐⭐☆

Excellent if you want to maintain a personal knowledge base for SQL, Python, Power BI, and interview notes.

It supports:

Wiki-style links
Tags
Graph view
Excellent Markdown support
4. GitHub Web Editor ⭐⭐⭐☆

You can edit .md files directly in GitHub, but it's not ideal for large documents.

My Recommendation for Your Bootcamp

Since you'll be using:

SQL Server / MySQL
Python
Power BI
Git
GitHub

I recommend Visual Studio Code for everything.

Your workflow would look like this:

VS Code
│
├── SQL Files
│
├── Markdown Documentation
│
├── Python Scripts
│
├── Git
│
└── GitHub Push

One IDE for your entire portfolio.

VS Code Extensions I Recommend

Install these:

Extension	Purpose
Markdown All in One	Markdown editing shortcuts
Markdown Preview Enhanced	Live preview with tables and diagrams
GitLens	Advanced Git history and blame
SQLTools	SQL execution and database explorer
MySQL (or SQLTools MySQL driver)	Connect to MySQL
Material Icon Theme	Better folder/file icons
Prettier	Formatting support
Code Spell Checker	Catch typos in documentation
For Your SQL Bootcamp

I recommend we standardize on Visual Studio Code. We'll keep everything in one project:

Retail-SQL-Bootcamp/
│
├── Database/
├── BusinessRequirements/
├── StoredProcedures/
├── Views/
├── ExecutionPlans/
├── Images/
├── Python/
├── PowerBI/
└── README.md

This mirrors the structure of many real-world analytics repositories and will make your GitHub portfolio look polished and professional.