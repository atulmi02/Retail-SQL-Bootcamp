/*
02_Create_DimCustomer

This is one of the most important dimensions because it will drive analyses such as:

Customer Lifetime Value (CLV)
RFM Analysis
Customer Segmentation
Repeat vs New Customers
Cohort Analysis
Churn Analysis
Geographic Sales Analysis

This table supports all major customer analytics:

✅ Customer Lifetime Value (CLV)
✅ Customer Segmentation
✅ Repeat Purchase Analysis
✅ Churn Analysis
✅ Cohort Analysis
✅ Geographic Sales Analysis
✅ Power BI Slicers
✅ Advanced SQL Window Functions
*/
/******************************************************************************
Project      : Retail ERP Data Warehouse
Script       : 02_Create_DimCustomer.sql
Database     : Retail_SQL_Bootcamp
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimCustomer;

CREATE TABLE DimCustomer
(
    CustomerKey         INT AUTO_INCREMENT,
    CustomerID          VARCHAR(20) NOT NULL,
    CustomerName        VARCHAR(100) NOT NULL,

    Gender              ENUM('Male','Female','Other') NOT NULL,

    DateOfBirth         DATE NOT NULL,
    Age                 TINYINT NOT NULL,

    Email               VARCHAR(100) NOT NULL,
    Phone               VARCHAR(20) NOT NULL,

    City                VARCHAR(50) NOT NULL,
    State               VARCHAR(50) NOT NULL,
    Country             VARCHAR(50) NOT NULL DEFAULT 'India',
    PostalCode          VARCHAR(10),

    CustomerSegment     ENUM('VIP','Gold','Silver','Regular') NOT NULL,

    JoinDate            DATE NOT NULL,

    IsActive            BOOLEAN NOT NULL DEFAULT TRUE,

    CreatedDate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_DimCustomer
        PRIMARY KEY(CustomerKey),

    CONSTRAINT UK_DimCustomerID
        UNIQUE(CustomerID),

    CONSTRAINT UK_DimCustomerEmail
        UNIQUE(Email),

    CONSTRAINT CK_Age
        CHECK (Age BETWEEN 18 AND 80)
);
CREATE INDEX IX_DimCustomer_Name
ON DimCustomer(CustomerName);

CREATE INDEX IX_DimCustomer_City
ON DimCustomer(City);

CREATE INDEX IX_DimCustomer_State
ON DimCustomer(State);

CREATE INDEX IX_DimCustomer_Segment
ON DimCustomer(CustomerSegment);

CREATE INDEX IX_DimCustomer_JoinDate
ON DimCustomer(JoinDate);

CREATE INDEX IX_DimCustomer_IsActive
ON DimCustomer(IsActive);