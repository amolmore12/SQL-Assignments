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
