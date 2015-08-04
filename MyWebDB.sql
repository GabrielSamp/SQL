--A series of SQl commands that creates a DB and tables in that DB then adds data and makes changes.  

IF DB_ID('MyWebDB') is not null
DROP DATABASE MyWebDB
go

CREATE DATABASE MyWebDB
GO

USE MyWebDB
CREATE TABLE Users 
(UserID int Primary Key, EmailAddress varchar(MAX), FirstName varchar(MAX), LastName varchar(MAX))
GO

USE MyWebDB
CREATE TABLE Products
(ProductId int Primary Key, ProductName varchar(MAX))
GO

USE MyWebDB
CREATE TABLE Downloads
(DownloadID int Primary Key, UserID int REFERENCES Users(UserID), DownloadDate DateTime, FileName varchar(MAX), ProductID int REFERENCES Products(ProductID))
GO

USE MyWebDB
Insert INTO Users (UserID, EmailAddress, FirstName, LastName) VALUES (1, 'johnsmith@gmail.com', 'John', 'Smith')
GO

USE MyWebDB
INSERT INTO Users (UserID, EmailAddress, FirstName, LastName) VALUES (2, 'janedoe@gmail.com', 'Jane', 'Doe')
GO

USE MyWebDB
INSERT INTO Products (ProductID, ProductName) VALUES (1, 'Music Songs Vol 1')
GO

USE MyWebDB
INSERT INTO Products (ProductID, ProductName) VALUES (2, 'Music Songs Vol 2')
GO

USE MyWebDB
INSERT INTO Downloads (DownloadID, UserID, DownloadDate, FileName, ProductID) VALUES (1, 1, GETDATE(), 'singSong.mp3', 2)
GO

USE MyWebDB
INSERT INTO Downloads (DownloadID, UserID, DownloadDate, FileName, ProductID) VALUES (2, 2, GETDATE(), 'musicalMusic.mp3', 1)
GO

USE MyWebDB
INSERT INTO Downloads (DownloadID, UserID, DownloadDate, FileName, ProductID) VALUES (3, 2, GETDATE(), 'musicalSong.mp3', 2)
GO

USE MyWebDB
SELECT EmailAddress as email_address, FirstName as first_name, LastName as last_name, DownloadDate as download_date, FileName as 'filename', ProductName as product_name
FROM Users, Products, Downloads
WHERE Downloads.UserID = Users.UserID AND Downloads.ProductID = Products.ProductID
GO


USE MyWebDB
ALTER TABLE Products 
ADD  ProductPrice decimal(5,2) DEFAULT 9.99, DateAdded datetime DEFAULT getdate()
GO


USE MyWebDB
ALTER TABLE Users
ALTER COLUMN FirstName varchar(20) NOT NULL
GO


USE MyWebDB
UPDATE Users 
SET FirstName = null
WHERE UserID = 1
GO

USE MyWebDB
UPDATE Users
SET FirstName = 'thisIsAVeryLongStringItShouldBeToLongForTheColumn'
WGO
HERE UserID = 1