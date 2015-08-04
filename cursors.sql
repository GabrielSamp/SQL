--The following queries create and use cursors. The queries have been combined in one file for simplicity.

USE MyGuitarShop;
DECLARE listPriceCursor CURSOR
STATIC
FOR
SELECT ProductName, ListPrice
FROM Products
WHERE ListPrice > 700
ORDER BY ListPrice DESC

DECLARE @productNameVar varchar(max), @listPriceVar money
OPEN listPriceCursor
FETCH NEXT FROM listPriceCursor INTO @productNameVar, @listPriceVar
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT @productNameVar +', ' + CONVERT(varchar, @listPriceVar)
FETCH NEXT FROM listPriceCursor INTO @productNameVar, @listPriceVar
END
CLOSE listPriceCursor
DEALLOCATE listPriceCursor


DECLARE shipAvgCursor CURSOR
STATIC
FOR 
SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;

OPEN shipAvgCursor
FETCH NEXT FROM shipAvgCursor
WHILE @@FETCH_STATUS = 0
FETCH NEXT FROM shipAvgCursor

CLOSE shipAvgCursor
DEALLOCATE shipAvgCursor

DECLARE shipAvgCursor CURSOR
STATIC
FOR 
SELECT LastName, AVG(ShipAmount) AS ShipAmountAvg
FROM Customers JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
GROUP BY LastName;


DECLARE @LastName varchar(MAX), @shipAvg money
OPEN shipAvgCursor
FETCH NEXT FROM shipAvgCursor INTO @LastName, @shipAvg
WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM shipAvgCursor INTO @LastName, @shipAvg
PRINT @LastName + ', $' + CONVERT(varchar, @shipAvg)
END
CLOSE shipAvgCursor
DEALLOCATE shipAvgCursor