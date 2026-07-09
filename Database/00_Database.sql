/**************************************************************************
 Project      : Retail ERP Data Warehouse
 Database     : Retail_SQL_Bootcamp
 Author       : Atul Kumar Keshari
 Version      : 1.0
 Database     : MySQL 8
**************************************************************************/

-- ==========================================================
-- Drop Existing Database (Development Only)
-- ==========================================================

DROP DATABASE IF EXISTS Retail_SQL_Bootcamp;

-- ==========================================================
-- Create Database
-- ==========================================================

CREATE DATABASE Retail_SQL_Bootcamp
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- ==========================================================
-- Use Database
-- ==========================================================

USE Retail_SQL_Bootcamp;

-- ==========================================================
-- SQL Mode
-- ==========================================================

SET SQL_SAFE_UPDATES = 0;

SET FOREIGN_KEY_CHECKS = 0;

SET SESSION cte_max_recursion_depth = 100000;

-- ==========================================================
-- Project Information
-- ==========================================================

SELECT
'Retail_SQL_Bootcamp' AS DatabaseName,
VERSION()             AS MySQLVersion,
CURRENT_USER()        AS CurrentUser,
NOW()                 AS InstallationDate;