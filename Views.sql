--The following queries create and use views. The queries have been combined in one file for simplicity

CREATE VIEW CustomerAddresses AS
SELECT Customers.CustomerID, EmailAddress, LastName, FirstName, BillLine1, BillLine2, BillCity, BillState, BillZip, ShipLine1, ShipLine2, ShipCity, ShipState, ShipZip
FROM Customers,
(SELECT Customers.CustomerID, Addresses.CustomerID as AddressCust, Line1 as BillLine1, Line2 as BillLine2,  City as BillCity, State as BillState, ZipCode as BillZip
FROM Addresses, Customers
WHERE Customers.BillingAddressID = Addresses.AddressID) as billing
INNER JOIN
(SELECT Customers.CustomerID, Addresses.CustomerID as AddressCust, Line1 as ShipLine1, Line2 as ShipLine2, City as ShipCity, State as ShipState, ZipCode as ShipZip
FROM Addresses, Customers
WHERE Customers.ShippingAddressID = Addresses.AddressID) as shipping on shipping.CustomerID = billing.CustomerID
WHERE Customers.CustomerID = shipping.CustomerID AND Customers.CustomerID = billing.CustomerID
GO


SELECT CustomerID, LastName, FirstName, BillLine1
FROM CustomerAddresses
GO

UPDATE CustomerAddresses
SET ShipLine1 = '1990 Westwood Blvd'
WHERE CustomerID = 8
GO

CREATE VIEW OrderItemProducts AS
SELECT Orders.OrderID, OrderDate, TaxAmount, ShipDate, ItemPrice, DiscountAmount, ItemPrice - DiscountAmount as FinalPrice, Quantity,
 ((ItemPrice - DiscountAmount) * Quantity) + TaxAmount as ItemTotal, ProductName
FROM Orders, OrderItems, Products
WHERE Orders.OrderID = OrderItems.OrderID AND OrderItems.ProductID = Products.ProductID
GO

CREATE VIEW ProductSummary AS
SELECT ProductName, COUNT(ProductName) as OrderCount, COUNT(ProductName) * FinalPrice as OrderTotal
FROM OrderItemProducts  
GROUP BY ProductName, FinalPrice
GO

SELECT TOP 5 *
FROM ProductSummary
ORDER BY OrderTotal DESC
