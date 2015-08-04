--The following queries create and use basic scripts. The queries have been combined in one file for simplicity

USE MyGuitarShop
DECLARE @productsCount int
SET @productsCount =
(SELECT Count(*) FROM Products)
GO

IF @productsCount >= 7
PRINT 'The number of products is greater than or equal to 7.'
ELSE 
PRINT 'The number of products is less than 7.'

USE MyGuitarShop
DECLARE @productsCount int, @avgListPrice money;
SET @productsCount =
(SELECT Count(*) FROM Products);

SET @avgListPrice = (SELECT AVG(ListPrice) FROM Products);


IF @productsCount >= 7 
BEGIN
Print 'Products Count is ' + CONVERT(VARCHAR,@productsCount,1) ;
Print 'Average List Price is ' + CONVERT(VARCHAR, @avgListPrice,1);
END;
ELSE 
Print 'The number of products is less than 7'
GO


DECLARE @count int
SET @count = 1

PRINT 'Common factors of 10 and 20'
WHILE @count <= 20
BEGIN
	IF 10%@count = 0 AND 20%@count = 0
	PRINT @count;

	SET @count = @count + 1;
END
GO


USE MyGuitarShop
BEGIN TRY
Insert INTO Categories (CategoryName) values('Guitars')
Print 'SUCCESS: Record was inserted.'
END TRY
BEGIN CATCH
Print 'FAILURE: Record was not inserted.'
Print 'Error ' + Convert(varchar, ERROR_NUMBER(), 1) + ': ' + ERROR_MESSAGE();
END CATCH


