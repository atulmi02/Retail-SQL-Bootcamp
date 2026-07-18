# BR #07 - Employee Sales Performance

The sales director wants to evaluate performance of sales employees for the year 2025.

---

## Grain of Report

**One row of report represents the total completed sales by a single employee for year 2025 including it's contribution to company total sales**

## Business Obective

- Which employee generated the highest total sales?
- How many completed orders were handeled by each employee?
- What is Average Order Value for each employee?
- What are total completed Sales for each employee?
- What percentage  of company's total sales did each employee contribute?
- Rank employees based on total sales.

## Table Required

FactSales
- DateKey
- EmployeeKey
- SalesAmount
- SalesStatus
- OrderNumber
  
DimDate
- DateKey
- CalendarYear

DimEmployee
- EmployeeKey
- EmployeeId
- EmployeeName
- Designation

## KPIs

- Gross Sales
- Total Orders
- Average Order Value = Gross sales / Total Orders
- Employee Sales  to Company Sales pct = (Employee gross sales / Company Total Sales) * 100

  
## SQL Concepts

- CTE's
- Window functions
- Sum()
- Count()
- CAST()
- NULLIF()

## Query Design

### CTE 1- EmployeeSales

Purpose
- Filter completed sales for year 2025
- Calculate Total Order per Employee
- Calculate Total Sales per Employee

### CTE 2- CompanyTotalSales

Purpose

- Calculate  Company Total sales


### CTE 3- EmployeePerformance

Purpose
- Calculate average order value
- Calculate Employee contribution to company total sales
- Calculate Employee Rank on gross sales 

### Final Select

Final Report
- EmployeeID | EmployeeName | Designation | Total Orders | Gross Sales | Avg Order Value |  Total Sales  | Employee contribution pct | Employee Rank
- Sort report on ,Employee rank and gross sales DESC

---

## Expected Output

Employee | EmployeeName | Designation | Total Orders | Gross Sales | Avg Order Value |  Total Sales  | Employee contribution pct | Employee Rank

## Production Considerations

- Filter data as early as possible.
- Aggregate before applying window functions.
- Use NULLIF() to prevent divide-by-zero errors.
- Round only presentation values.
- Keep window functions in the same CTE whenever possible.
- Avoid unnecessary joins.
- Ensure indexes support filtering and grouping columns.

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

### Average Order Value

```
GrossSales/TotalOrders
```

### Employee Sales Contribution %

```
Employee Gross Sales/Company Sales * 100
```
