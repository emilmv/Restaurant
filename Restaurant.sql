CREATE DATABASE Restaurant
USE Restaurant
-- Food, Tables, Orders tables
CREATE TABLE Food
(
ID INT PRIMARY KEY IDENTITY,
FoodName NVARCHAR(255) UNIQUE NOT NULL,
FoodPrice DECIMAL(18,2) NOT NULL
)
CREATE TABLE Tables
(
ID INT PRIMARY KEY IDENTITY
)
CREATE TABLE Orders
(
ID INT PRIMARY KEY IDENTITY,
TableID INT FOREIGN KEY REFERENCES Tables(ID),
FoodID INT FOREIGN KEY REFERENCES Food(ID),
OrderTime DATETIME,
OrderQuantity INT
)

INSERT INTO Food (FoodName,FoodPrice) VALUES
('Pepperoni Pizza',25.00),
('Caesar Salad',12.00),
('Hot Dog',8.00),
('Doner',3.00)

INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES
INSERT INTO Tables DEFAULT VALUES

INSERT INTO Orders (TableID,FoodID,OrderTime,OrderQuantity) VALUES
(1,4,'2024-04-16 13:30:00',1),
(1,1,'2024-04-16 13:00:00',1),
(1,2,'2024-04-16 13:00:00',1),
(2,3,'2024-04-16 12:30:00',2),
(2,4,'2024-04-16 12:30:00',1)

-- Butun masa datalari ve qarshisinda sifarish sayi gosteren Query
SELECT t.ID AS [Table Number], o.OrderQuantity
FROM Tables t
JOIN Orders o ON t.ID=o.TableID

--Butun yemekleri sifarish sayina gore gosteren Query
SELECT f.FoodName, o.OrderQuantity
FROM Food f
JOIN Orders o ON f.ID = o.FoodID

--Sifarish datalarinin yaninda yemeyin adini gosteren Query, masanin nomresini gosteren Query (3 ve 4)
SELECT o.*, f.FoodName
FROM Orders o
JOIN Food f ON o.FoodID = f.ID

--Masa datalarinin yaninda sifarishlerin meblegi (GROUP BY kecmemishik amma onsuz mumkunuzdur)
SELECT t.*, SUM(f.FoodPrice * o.OrderQuantity) AS TotalOrderPrice
FROM Tables t
LEFT JOIN Orders o ON t.ID = o.TableID
LEFT JOIN Food f ON o.FoodID = f.ID
GROUP BY t.ID

--Ilk ve son sifarish arasindaki ferg 1-ci table ucun
SELECT DATEDIFF(MINUTE, MIN(OrderTime), MAX(OrderTime)) AS TimeDifferenceInMinutes
FROM Orders
WHERE TableID = 1

--30 deqiqe evvel verilmis sifarisin datalari
SELECT * FROM Orders
WHERE OrderTime>=DATEADD(MINUTE,-30,GETDATE())

--Sifaris olunmayan masalari select eden query
SELECT t.*,o.* FROM Tables t
LEFT JOIN Orders o on o.TableID=t.ID
WHERE o.TableID IS NULL

--Son 1 saat erzinde sifarish vermeyen masalar (Distinct kecmediyimiz ucun internetden tapdim)
SELECT t.*
FROM Tables t
LEFT JOIN (
    SELECT DISTINCT TableID
    FROM Orders
    WHERE OrderTime >= DATEADD(MINUTE, -60, GETDATE())
) o ON t.ID = o.TableID
WHERE o.TableID IS NULL;