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
--#Create a trigger that give an message whenever a new record is inserted.CREATE TRIGGER trg_AfterInsert
ON Jomato_1
AFTER INSERT
AS
BEGIN
    PRINT 'A new record has been inserted into the Jomato table.';
END;
