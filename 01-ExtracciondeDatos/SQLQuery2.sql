--consultas Simples
USE NORTHWND;

--Seleccionar cada una de las tablas de la base de datos de Northwind

SELECT *
FROM Orders;

SELECT *
FROM Shippers;

SELECT *
FROM Products;

SELECT *
FROM [Order Details];


--Proyeccion de la tabla 

SELECT ProductName, QuantityPerUnit, UnitPrice
FROM Products;

--Alias de columna com sobre nombre

SELECT 
ProductName AS NombreProducto,
QuantityPerUnit 'Unidades Medida',
UnitPrice AS [Precio Unitario]
FROM Products;

--campo calculado y alias de tablas 
SELECT 
	[Order Details].OrderID AS [NUMERO DE ORDEN],
	Products.ProductID AS [NUMERO DE PRODUCTO],
	ProductName AS [NOMBRE DEL PRODUCTO],
	Quantity 'CANTIDAD',
	[Order Details].UnitPrice AS PRECIO,
	(Quantity * [Order Details].UnitPrice) AS SUBTOTAL
FROM [Order Details] 
INNER JOIN
Products
ON 
Products.ProductID = [Order Details].ProductID;
--misma consulta colocandole alias a las tablas para el IINER JOIN
SELECT 
	od.OrderID AS [NUMERO DE ORDEN],
	pr.ProductID AS [NUMERO DE PRODUCTO],
	ProductName AS [NOMBRE DEL PRODUCTO],
	Quantity 'CANTIDAD',
	od.UnitPrice AS PRECIO,
	(Quantity * od.UnitPrice) AS SUBTOTAL
FROM [Order Details] AS od
INNER JOIN
Products AS pr
ON 
pr.ProductID = od.ProductID;

--operadores relacionales (<, >, >=, <=, =, != ó <>)
--Mostrar todos los productos con un precio mayores a 20
SELECT 
	ProductName AS [NOMBRE DEL PRODUCTO],
	QuantityPerUnit AS [DESCRIPCIÓN],
	UnitPrice AS [PRECIO]
FROM Products
WHERE UnitPrice > 20;

--seleccionar todos los clientes que no sean de M?xico
SELECT *
FROM Customers
WHERE Country <> 'Mexico';

--seleccionar todos aquellas ordenes donde se realizaron en 1997
SELECT 
	OrderID AS [NUMERO DE ORDEN],
	OrderDate AS [FECHA DE ORDEN],
	YEAR(OrderDate) AS [AÑO CON YEAR],
	DATEPART(YEAR,OrderDate) AS [AÑO CON DATEPART]
FROM Orders
WHERE YEAR(OrderDate) = 1997;

SET LANGUAGE SPANISH;
SELECT 
	OrderID AS [NUMERO DE ORDEN],
	OrderDate AS [FECHA DE ORDEN],
	YEAR(OrderDate) AS [AÑO CON YEAR],
	DATEPART(YEAR,OrderDate) AS [AÑO CON DATEPART],
	DATEPART(QUARTER,OrderDate) AS [TRIMESTRE],
	DATEPART(WEEKDAY,OrderDate) AS [DIA SEMANA],
	DATENAME(WEEKDAY,OrderDate) AS [NOMBRE DIA SEMANA] 
FROM Orders
WHERE YEAR(OrderDate) = 1997;

--operaciones lógicas (AND, OR, NOT)

--seleccionar los productos que rengan un precio mayor a 20 y un estock mayor a 30
SELECT 
	ProductID AS [NÚMERO PRODUCTO],
	ProductName AS [NOMBRE DEL PRODUCTO],
	UnitsInStock AS [EXISTENCIA],
	UnitPrice AS [PRECIO],
	(UnitPrice*UnitsInStock) AS [COSTO INVENTARIO]
FROM Products
WHERE UnitPrice > 20 
AND UnitsInStock >30;

--seleccionar a los clientes de Estados Unidos o Canada
SELECT *
FROM Customers;
SELECT 
	ContactName AS [NOMBRE],
	ContactTitle,
	City,
	Country
FROM Customers
WHERE 
	Country = 'USA'
OR
	Country = 'Canada';
--seleccionar los clientes de blasil, rio de janeiro y que tengan región
SELECT 
	*
FROM Customers
WHERE Country = 'brasil'
AND City = 'Rio de Janeiro'
AND Region IS NOT NULL;

--OPERADOR IN 

--selecionar todos los clientes de USA, Alemania y Francia
SELECT *
FROM Customers
WHERE Country = 'USA'
OR Country = 'Germany'
OR Country = 'France'
ORDER BY Country;

SELECT *
FROM Customers
WHERE Country IN('USA','Germany','France')
ORDER BY Country;
	
--Seleccionar los nombre de 3 categorias especificas
SELECT 
	CategoryName AS [NOMBRE],
	[Description] AS [DESCRIPCIÓN]
FROM Categories
WHERE CategoryName IN ('Produce','Grains/Cereals','Condiments');
--seleccionar los pedidos de tes empleados en especifico
SELECT e.EmployeeID,
CONCAT(e.FirstName, e.LastName) AS Fullname,
o.OrderDate
FROM Orders AS o
JOIN Employees e 
ON o.EmployeeID = e.EmployeeID
WHERE e.EmployeeID IN (2,4,3);

--seleccionar todos los clientes que no sean de alemania, mexico y argentina 

SELECT *
FROM Customers
WHERE Country NOT IN ('Mexico','Germany','Argentina')
ORDER BY Country;

--OPERADOR BETWEEN

--seleccionar todos los productos que su precion esten entre 10 y 30
SELECT ProductName,UnitPrice 
FROM Products
WHERE 
UnitPrice >= 10 
AND 
UnitPrice <=30
ORDER BY 2 DESC;--el numero indica la columna que ordenara
--ORDER BY [precio] DESC

SELECT ProductName,UnitPrice 
FROM Products
WHERE 
UnitPrice BETWEEN 10 AND 30;

--Seleccionar todas las ordenes de 1995 a 1997
SELECT *
FROM Orders
WHERE
DATEPART(YEAR,OrderDate) 
BETWEEN 1995 AND 1997;

--seleccionar todoos los productos que no esten en un precio entre 10 y 20 
SELECT *
FROM Products
WHERE UnitPrice NOT BETWEEN 10 AND 20;

--OPERADOR LIKE BUSCA POR PATRON 
--WILDCARDS->SIGNOS QUE NECESITO PARA ARMAR UN PATRON (%, _, [], [^])

--seleccionar todos los cleintes en donde su nombre comiencec con 'A'
SELECT *
FROM Customers
WHERE CompanyName LIKE 'A%';

SELECT *
FROM Customers
WHERE CompanyName LIKE 'AN%';

--seleccionar todos los clientes de una ciudad
--que se comiensa con L, seguido de cualquier caracter,
--despues de nd y que termine con dos caracteres cualquiera 
SELECT *
FROM Customers
WHERE City LIKE 'L_nd__';

--seleccionar todos los clientes que su nombre termine con A
SELECT *
FROM Customers
WHERE CompanyName LIKE '%A';


--devolver todos los clientes que en la ciudad contengan la letra L
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE City LIKE '%L%';--busca que tenga una L

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE City LIKE '%LA%';

--devolver todos los clientes que comienzan con A o comienzan con B
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'A%'
OR CompanyName LIKE 'B%';

--devolver todos los clientes que comienzan con B y terminan con s 
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'B%S';

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'B%'
AND CompanyName LIKE '%S';

--devolver todos los clientes que comiencen con a y tengan almenos tres caracteres de longitud 
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE 'A__%';

--devolver todos los clientes que tienen r en la segunda posición 
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '_R%';

--devolver todos los clientes que contengan A,B ó C al inicio
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[ABC]%';--que comiencen con abc

--devolver todos los clientes que NO contengan A,B ó C al inicio
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[^ABC]%';--el acento siclunfejo hace que los excluya
SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName NOT LIKE '[ABC]%';

SELECT CustomerID,CompanyName,City
FROM Customers
WHERE CompanyName LIKE '[A-F]%';--de la A a la F, dandole un rango 

--seleccionar todos los clientes de Berlin mostrando solo los 3 primeros ordenados
--de el mayor al menor 
SELECT TOP 3 *
FROM Customers
WHERE Country = 'USA'
ORDER BY Country; 

--SELECCIONAR TODOS LOS CLIENTES ORDENADOS DE FORMA ASCENDETE POR SU NÚMERO DE CLIENTE 
--PERO SALTANDO LAS PRIMERAS CINCO FILAS (OFFSET)
SELECT  *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS;

--SELECCIONAR TODOS LOS CLIENTES ORDENADOS DE FORMA ASCENDETE POR SU NÚMERO DE CLIENTE 
--PERO SALTANDO LAS PRIMERAS CINCO FILAS Y mostrando las siguientes 10 (OFFSET Y FETCH)
SELECT  *
FROM Customers
ORDER BY CustomerID ASC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY;




SELECT 
	COUNT(ShipRegion) AS [NÚMERO DE REGIONES]
FROM Orders;

SELECT 
MAX (Orderdate) AS [ULTIMA FECHA COMPRA]
FROM Orders;

SELECT MAX (UnitPrice) AS [PRECIO MAS ALTO ]
FROM Products;

SELECT MIN (UnitsInStock) AS [STOCK MINIMO]
FROM Products;

SELECT*,
(UnitPrice * Quantity- (1-Discount)) AS [IMPORTE]
FROM [Order Details]

SELECT
	ROUND(SUM(UnitPrice * Quantity- (1-Discount)), 2) AS [IMPORTE]--ROUND para redonderar,redondea dos decimales
FROM [Order Details]


--seleccionar el promedio de ventas 
SELECT
	ROUND(AVG(UnitPrice * Quantity- (1-Discount)), 2) 
	AS [PROMEDIO DE VENTAS]--primero suma y luego divide entre el número de filas
FROM [Order Details]

--seleccionar el numero de ordenes realizadas a Alemania 
SELECT *
FROM Orders;

SELECT *
FROM Orders
WHERE ShipCountry = 'Germany';

SELECT COUNT(*) AS [TOTAL DE ORDENES]--el count indica la cantidad de ordenes que hay 
FROM Orders
WHERE ShipCountry = 'Germany'
AND CustomerID = 'LEHMS';

SELECT * 
FROM Customers;

--seleccionar la suma de las cantidades vendidas por cada orderid (agrupada)
SELECT 
	OrderID,SUM(Quantity) AS [TOTAL DE CANTIDADES]
FROM [Order Details]
GROUP BY OrderID;

--seleccionar el numero de productos por categoria 
SELECT 
	c.CategoryName AS [CATEGORIA]
	,COUNT(*) AS [TOTAL DE PRODUCTOS]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = C.CategoryID
WHERE c.CategoryName IN ('Beverages','Meat/Poultry')
GROUP BY CategoryName;

SELECT 
	c.CategoryName AS [CATEGORIA]
	,COUNT(*) AS [TOTAL DE PRODUCTOS]
FROM Products AS p
INNER JOIN Categories AS c
ON p.CategoryID = C.CategoryID
GROUP BY CategoryName;

SELECT 
	CategoryID,COUNT(UnitsInStock) AS [TOTAL DE PRODUCTOS]
FROM Products
GROUP BY CategoryID;

--obtener el total de pedidos realizados por cada cliente 
--obtener el numero total de pedidos que ha atendido cada empleado
SELECT
	EmployeeID AS [NÚMERO DE EMPLEADO],
	COUNT(*) AS [TOTAL DE ORDNES]
FROM Orders
GROUP BY EmployeeID
ORDER BY [TOTAL DE ORDNES] DESC;

SELECT
	e.FirstName,
	e.LastName [NÚMERO DE EMPLEADO],
	COUNT(*) AS [TOTAL DE ORDNES]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName
ORDER BY [TOTAL DE ORDNES] DESC;

--CONCATENANDO 
SELECT
	CONCAT( e.FirstName,' ',e.LastName )[NÚMERO DE EMPLEADO],
	COUNT(*) AS [TOTAL DE ORDNES]
FROM Orders AS o
INNER JOIN Employees AS e
ON o.EmployeeID = e.EmployeeID
GROUP BY e.FirstName,
		 e.LastName
ORDER BY [TOTAL DE ORDNES] DESC;

--ventas totales por producto 
SELECT 
	od.ProductID,
	ROUND(SUM(od.Quantity * od.UnitPrice *(1-Discount)),2) AS [VENTAS TOTALES]
FROM [Order Details] AS od
GROUP BY od.ProductID;

SELECT 
	p.ProductName,
	ROUND(SUM(od.Quantity * od.UnitPrice *(1-Discount)),2) AS [VENTAS TOTALES]
FROM [Order Details] AS od
INNER JOIN Products AS p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

SELECT TOP 1
	p.ProductName,
	ROUND(SUM(od.Quantity * od.UnitPrice *(1-Discount)),2) AS [VENTAS TOTALES]
FROM [Order Details] AS od
INNER JOIN Products AS p
ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY 2 DESC;

--calcular cuantos pedidos se realizaron por año 
SELECT 
	DATEPART(YY, OrderDate) AS [AÑO],
	COUNT(*) AS [NÚMERO DE PEDIDOS]
FROM Orders 
GROUP BY DATEPART(YY, Orderdate);
--cuantos productos ofrece cada provedor
SELECT 
	s.CompanyName AS [Proveedor],
	COUNT(*) AS [Número de productos]
FROM Products AS p
INNER JOIN Suppliers AS s
ON p.SupplierID = s.SupplierID
GROUP BY s.CompanyName
ORDER BY 2 DESC;
--seleccionar el numero de pedidos por cliente que hayan realizado mas de 10 
SELECT  
	c.CompanyName AS [CLIENTE],
	COUNT(*) AS [NÚMERO DE PEDIDOS]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
HAVING COUNT(*) > 10;
--seleccionar los empleados que hayan gestionado pedidos por un total superior a 
--10000 en ventas(mostrar el id del empleado, el nombre y el total de compras)
SELECT 
	o.EmployeeID AS [NOMBRE EMPLEADO],
	(e.FirstName + ' ' +e.LastName) AS [NOMBRE COMPLETO]--concatenar las columnas
	,ROUND(SUM(od.UnitPrice * od.Quantity *(1-Discount)),2) AS [TOTAL DE VENTAS]
FROM [Order Details] AS od
INNER JOIN Orders AS o
ON od.OrderID = o.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY o.EmployeeID,e.FirstName,e.LastName;
--seleccionar 