
DROP INDEX  IX_FactSales_DateKey_StoreKey ON FactSales;
DROP INDEX  IX_DimStore_StoreKey ON DimStore;
DROP INDEX  IX_DimDate_DateKey ON DimDate;

Create Index IX_FactSales_DateKey_StoreKey
ON FactSales (DateKey, StoreKey,SalesStatus,OrderNumber, SalesAmount);

Create Index IX_DimStore_StoreKey
ON DimStore (StoreKey,StoreName, StoreId, City, State);

Create  Index IX_DimDate_DateKey
ON DimDate (CalendarYear,DateKey);