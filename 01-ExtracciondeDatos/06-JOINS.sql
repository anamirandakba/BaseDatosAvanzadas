USE NORTHWND;

SELECT TOP 0 CategoryID, CategoryName
INTO categoriesnew
FROM Categories;


ALTER TABLE categoriesnew
ADD CONSTRAINT pk_categories_new
PRIMARY KEY (Categoryid);

SELECT TOP 0 productid, ProductName, CategoryID
INTO productsnew
FROM Products;


ALTER TABLE productsnew
ADD CONSTRAINT pk_products_new
PRIMARY KEY (productid);

ALTER TABLE productsnew
ADD CONSTRAINT fk_products_categories2
FOREIGN KEY (categoryid)
REFERENCES categoriesnew (categoryid)
ON DELETE CASCADE;

INSERT INTO categoriesnew
VALUES
('C1'),
('C2'),
('C3'),
('C4');

INSERT INTO productsnew
VALUES
('P1', 1),
('P2', 1),
('P3', 2),
('P4', 2),
('P5', 4),
('P6', NULL);

SELECT *
FROM categoriesnew;

SELECT *
FROM productsnew;

SELECT *
FROM categoriesnew AS c
INNER JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT *
FROM categoriesnew AS c
LEFT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT *
FROM categoriesnew AS c
LEFT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE ProductID IS NULL;

SELECT *
FROM categoriesnew AS c
RIGHT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID;

SELECT *
FROM productsnew AS p
LEFT JOIN 
categoriesnew AS c
ON p.CategoryID = c.CategoryID;

SELECT *
FROM categoriesnew AS c
RIGHT JOIN 
productsnew AS p
ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IS NULL;

SELECT TOP 0
CategoryID AS [Numero],
CategoryName AS [Nombre],
[Description] AS [Descripción]
INTO Categories_nuevas
FROM Categories;

ALTER TABLE Categories_nuevas 
ADD CONSTRAINT pk_categories_nuesvas
PRIMARY KEY ([Numero]);

SELECT *
FROM Categories_nuevas;

INSERT INTO Categories
VALUES ('Ropa','Ropa de paca',NULL),
		('Linea Blanca','Ropita coqueta',NULL);

SELECT * 
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Numero;

INSERT INTO Categories_nuevas
SELECT
	c.CategoryName
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL;


SELECT *
FROM categoriesnew;

INSERT INTO Categories_nuevas
SELECT
	c.CategoryName
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL;

INSERT INTO Categories
VALUES ('Ropa','Ropa de paca',NULL),
		('Linea Blanca','Ropita coqueta',NULL);

DELETE FROM Categories_nuevas;


INSERT INTO Categories_nuevas
SELECT
UPPER(c.CategoryName) AS [CATEGORIAS],--UPPER PARA HACER TODO EN MAYUSCULAS
UPPER(CAST (c.Description AS varchar)) AS [DESCRIPCIÓN]
FROM Categories AS c
LEFT JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Numero
WHERE cn.Numero IS NULL;


SELECT * 
FROM Categories_nuevas


SELECT * 
FROM Categories AS c
INNER JOIN Categories_nuevas AS cn
ON c.CategoryID = cn.Numero;


DELETE Categories_nuevas;

--Reiniciar los identity(cuando las tablas tienen integridad referencial,
--sino utilizar truncate)
DBCC CHECKIDENT('Categories_nuevas',RESEED,0);


--el truncate elimina los datos de la tabla al igual que el delete 
--pero solamente funciona si no tiene integridad referencial,
--ademas reinicia los identity
TRUNCATE TABLE Categories_nuevas;

--full join
SELECT * 
FROM categoriesnew AS C
FULL JOIN
productsnew AS P
ON C.CategoryID = P.CategoryID;

--CROSS JOIN(para ver las coincidencias)
SELECT * 
FROM categoriesnew AS C
CROSS JOIN
productsnew AS P








