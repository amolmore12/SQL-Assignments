--Sales_Table

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
SELECT * FROM Sales_Table AS A
RIGHT JOIN Orders_Table AS b
ON A.salesman_id = B.SalesmanId