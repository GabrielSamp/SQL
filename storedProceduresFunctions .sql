--The following queries create and use scripts with functions ans stored procedures. The queries have been combined in one file for simplicity.

CREATE PROC spInsertCategory ( @Name varchar(255))
AS
BEGIN 
INSERT INTO Categories VALUES (@Name)
END


EXEC spInsertCategory 'Banjos'
EXEC spInsertCategory 'sousaphone'
GO

ALTER FUNCTION fnDiscountPrice (@ItemID int)
RETURNS money
BEGIN
RETURN ( SELECT (ItemPrice - DiscountAmount) FROM OrderItems WHERE ItemID = @ItemID) 
END;
GO



 PRINT 'Discount Price ' + CONVERT(VARCHAR, dbo.fnDiscountPrice(1), 1)
GO

CREATE FUNCTION fnItemTotal(@itemID money)
RETURNS money
BEGIN
RETURN (SELECT (Quantity * dbo.fnDiscountPrice(@itemID)) FROM OrderItems WHERE ItemID = @itemID)
END
GO


PRINT 'OrderItem total ' + CONVERT(VARCHAR, dbo.fnItemTotal(5), 1)
GO


CREATE PROC spInsertProduct (@CategoryID int, @ProductCode varchar(10), @ProductName varchar(255), @ListPrice money,  @DiscountPercent money)
AS
BEGIN
	IF(@ListPrice >= 0 AND @DiscountPercent >= 0)
		BEGIN
		INSERT INTO Products (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, DateAdded)
					  VALUES(@CategoryID, @ProductCode, @ProductName, '', @ListPrice, @DiscountPercent, GETDATE())
		END
	ELSE 
		BEGIN
			IF (@ListPrice < 0)
				BEGIN
					;
					THROW 50001, 'List Price must not be negitive', 1;
				END
			IF(@DiscountPercent < 0)
				BEGIN
					;
					THROW 50002, 'Discount Percent must not be negitive', 1;
				END
		END
END
GO

EXEC spInsertProduct 1, 'shredder', 'Really Cool Guitar', 1000, 10
EXEC spInsertProduct 2, 'Basstastic', 'Thump', 500, -5
EXEC spInsertProduct 2, 'Basstastic', 'Thump2', -500, -5
EXEC spInsertProduct 3, 'BangBang', 'DrumCircleMaster', -500, 5
GO


CREATE PROC spUpdateProductDiscount (@ProductID int, @DiscountPercent money)
AS 
BEGIN
	IF @DiscountPercent < 0
		BEGIN
			;
			THROW 50001, ' Discount Percent must be non negtive', 1;
		END 
	ELSE
		BEGIN
			UPDATE Products
			SET DiscountPercent = @DiscountPercent
			WHERE ProductID = @ProductID
		END
END
GO

EXEC spUpdateProductDiscount 1, 50
EXEC spUpdateProductDiscount 2, -40

GO


CREATE TRIGGER Products_UPDATE 
ON 
Products
AFTER UPDATE, INSERT
AS
IF EXISTS
		(SELECT * FROM inserted JOIN Products ON inserted.ProductID = Products.ProductID
		WHERE inserted.DiscountPercent <> Products.DiscountPercent )
			BEGIN
				IF (SELECT inserted.DiscountPercent FROM  inserted) < 0 
				OR (SELECT DiscountPercent FROM inserted) > 100
					BEGIN
						;
						THROW 50001, 'Discount Percent must be between 0 and 100' , 1
						ROLLBACK TRAN;
					END
				ELSE IF (SELECT DiscountPercent FROM inserted) > 0 AND (SELECT DiscountPercent FROM inserted) < 1		
					BEGIN
						UPDATE Products SET DiscountPercent = DiscountPercent * 100 WHERE DiscountPercent > 0 AND DiscountPercent < 1
					END
			 END
GO


UPDATE Products
SET DiscountPercent = .1 WHERE ProductID = 1
							
UPDATE Products
SET DiscountPercent = -100 WHERE ProductID = 2
							 
GO

CREATE TRIGGER Products_INSERT 
ON Products
AFTER INSERT
AS
IF (SELECT DateAdded FROM inserted) IS NULL
	BEGIN 
		UPDATE Products
		SET DateAdded = GETDATE() WHERE DateAdded IS NULL
	END
GO


INSERT INTO Products (CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent)
VALUES (1, 'soundMaker', 'musicMaker', 'WORDS WORDS WORDS', 1000, 10)
GO

CREATE TABLE ProductsAudit
(AuditID int IDENTITY NOT NULL, ProductID int, CategoryID varchar(10), ProductCode varchar(255), 
 ProductName varchar(255), ListPrice money, DiscountPercent money, DateUpdated datetime);
 GO

 CREATE TRIGGER Products_UPDATE_AUDIT
 ON 
 Products
 AFTER UPDATE
 AS
 BEGIN
	 INSERT INTO ProductsAudit (ProductID, CategoryID, ProductCode, 
	 ProductName, ListPrice, DiscountPercent, DateUpdated)
	 VALUES ((SELECT ProductID FROM deleted), (SELECT CategoryID FROM deleted), (SELECT ProductCode FROM deleted),
			  (SELECT ProductName FROM dele.ted), (SELECT ListPrice FROM deleted), (SELECT DiscountPercent FROM deleted), GETDATE())
END
GO
 

 UPDATE Products
 SET DiscountPercent = 50 WHERE ProductID = 1
GO