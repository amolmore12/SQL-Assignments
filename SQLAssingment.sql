--Sales_Table
-- #Insert a new record in your Orders table

create table Sales_Table(
salesman_id int,
Salesman_name varchar(255),
Commision int,
City varchar(255),
Age int);

Insert into Sales_Table (salesman_id,Salesman_name,Commision,City,Age)
Values
(101, 'Joe', 50, 'California', 17),
(102, 'Simon', 75, 'Texas', 25),
(103, 'Jessie', 105, 'Florida', 35),
(104, 'Danny', 100, 'Texas', 22),
(105, 'Lia', 65, 'New Jersey', 30);

--select * from Sales_Table;

--Customer_Table
-- #Add Primary key constraint for SalesmanId column in Salesman table. Add default constraint for City column in Salesman table. Add Foreign key constraint for SalesmanId column in Customer table. Add not null constraint in Customer_name column for the Customer table
	
CREATE TABLE Customer_Table (
    SalesmanId_Name INT,
    Customer_Id INT,
    Customer_Name VARCHAR(255),
    Purchase_Amount INT,
    );

INSERT INTO Customer_Table (SalesmanId_Name, Customer_Id, Customer_Name, Purchase_Amount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);

--select * from Customer_Table;

--Oders_Table
-- #Fetch the data where the Customer’s name is ending with ‘N’ also get the purchase amount value greater than 500.

CREATE TABLE Orders_Table 
(OrderId int, 
CustomerId int, 
SalesmanId int, 
Orderdate Date, 
Amount money)

INSERT INTO Orders_Table
Values 
(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500)

--select * from Orders_Table;

--Unique_Salesman_Id
-- #Using SET operators, retrieve the first result with unique SalesmanId values from two tables, and the other result containing SalesmanId with duplicates from two tables.

SELECT Salesman_Id
FROM Sales_Table
UNION
SELECT SalesmanId_Name
FROM Customer_Table;

--Duplicate_Salesman_Id

SELECT Salesman_Id
FROM (
    SELECT Salesman_Id FROM Sales_Table
    UNION ALL
    SELECT Salesmanid_name FROM Customer_Table
) AS CombinedSales
GROUP BY Salesman_Id
HAVING COUNT(*) > 1;.

--Matching_Data
-- #Display the below columns which has the matching data. Orderdate, Salesman Name, Customer Name, Commission, and City which has the range of Purchase Amount between 500 to 1500.
	
SELECT 
    A.Salesman_name,
	A.City,
	A.Commision,
    B.Customer_Name,
	C.Orderdate
FROM 
Sales_Table AS A
LEFT JOIN  Customer_Table AS B
ON A.salesman_id = B.SalesmanId_Name
LEFT JOIN Orders_Table AS C
ON A.salesman_id = C.SalesmanId
WHERE Purchase_Amount BETWEEN 500 AND 1500;

--fetch all the results
-- #Using right join fetch all the results from Salesman and Orders table.

SELECT * FROM Sales_Table AS A
RIGHT JOIN Orders_Table AS b
ON A.salesman_id = B.SalesmanId

--#Create a user-defined functions to stuff the Chicken into ‘Quick Bites’. Eg: ‘Quick Chicken Bites’.

CREATE FUNCTION dbo.StuffChickenIntoQuickBites()
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100);
    SET @Result = 'Quick ' + 'Chicken Bites';
    RETURN @Result;
END;

SELECT dbo.StuffChickenIntoQuickBites() AS Result;

--#Use the function to display the restaurant name and cuisine type which has the maximum number of rating.

SELECT RestaurantName, CuisinesType
FROM Jomato
WHERE No_of_Rating = (
    SELECT MAX(No_of_Rating) FROM Jomato
);

--#Create a Rating Status column to display the rating as ‘Excellent’ if it has more the 4 start rating, ‘Good’ if it has above 3.5 and below 4 star rating, ‘Average’ if it is above 3 and below 3.5 and ‘Bad’ if it is below 3 star rating and

Select *,	
CASE
When Rating > 4 then 'Excellent'
When Rating > 3.5 then 'Good'
When Rating > 3 then 'Avarage'
else 'Bad'end as Rating_Staus
from Jomato;

--#Find the Ceil, floor and absolute values of the rating column and display the current date and separately display the year, month_name and day.

SELECT
    CEILING(No_of_Rating) AS CeilRating,
    FLOOR(No_of_Rating) AS FloorRating,
    ABS(No_of_Rating) AS AbsoluteRating,
    CAST(GETDATE() AS DATE) AS CurrentDate,
    YEAR(GETDATE()) AS CurrentYear,
	DATENAME(MONTH, GETDATE()) AS CurrentMonth,
	DAY(GETDATE()) AS CurrentDay
	FROM Jomato;

--#Display the restaurant type and total average cost using rollup.

SELECT RestaurantType, AVG(AverageCost) AS TotalAverageCost
FROM Jomato
GROUP BY RestaurantType WITH ROLLUP;

--#Create a stored procedure to display the restaurant name, type and cuisine where the table booking is not zero.

CREATE PROCEDURE dbo.GetRestaurantsWithBookings
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        RestaurantName,
        RestaurantType,
        CuisinesType
    FROM 
        Jomato_1
    WHERE 
        TableBooking <> 0;
END;
EXEC dbo.GetRestaurantsWithBookings;

--#Create a transaction and update the cuisine type ‘Cafe’ to ‘Cafeteria’. Check the result and rollback it.

BEGIN TRANSACTION;
BEGIN TRY
    -- Update the cuisine type
    UPDATE Jomato_1
    SET CuisinesType = 'Cafeteria'
    WHERE CuisinesType = 'Cafe';

    -- Check the result
    SELECT RestaurantName, CuisinesType
    FROM Jomato_1
    WHERE CuisinesType = 'Cafeteria';

    -- Rollback the transaction
    ROLLBACK TRANSACTION;
    PRINT 'Transaction has been rolled back.';
END TRY
BEGIN CATCH
    -- Rollback in case of error
    ROLLBACK TRANSACTION;
    PRINT 'An error occurred. Transaction has been rolled back.';
END CATCH;

--#Generate a row number column and find the top 5 areas with the highest rating of restaurants.

WITH RankedAreas AS (
    SELECT 
        Area,
        AVG(No_of_Rating) AS AvgRating,
        ROW_NUMBER() OVER (ORDER BY AVG(No_of_Rating) DESC) AS RowNum
    FROM 
        Jomato_1
    GROUP BY 
        Area
)
SELECT 
    Area,
    AvgRating
FROM 
    RankedAreas
WHERE 
    RowNum <= 5;

--#Use the while loop to display the 1 to 50.

DECLARE @Counter INT = 1;

WHILE @Counter <= 50
BEGIN
    PRINT @Counter;  -- Display the current value of Counter
    SET @Counter = @Counter + 1;  -- Increment Counter
END;


--#Write a query to Create a Top rating view to store the generated top 5 highest rating of restaurants.

CREATE VIEW TopRating AS
WITH RankedRestaurants AS (
    SELECT 
        RestaurantName,
        No_of_Rating,
        ROW_NUMBER() OVER (ORDER BY No_of_Rating DESC) AS RowNum
    FROM 
        Jomato_1
)
SELECT 
    RestaurantName,
    No_of_Rating
FROM 
    RankedRestaurants
WHERE 
    RowNum <= 5;

SELECT * FROM TopRating;

--#Create a trigger that give an message whenever a new record is inserted.

CREATE TRIGGER trg_AfterInsert
ON Jomato_1
AFTER INSERT
AS
BEGIN
    PRINT 'A new record has been inserted into the Jomato table.';
END;

