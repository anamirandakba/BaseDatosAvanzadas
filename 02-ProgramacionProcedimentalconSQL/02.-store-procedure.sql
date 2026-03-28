CREATE DATABASE bdstored;
GO
USE bdstored; 
GO
--stored procedure

CREATE OR ALTER PROC spu_persona_saludar
   @nombre NVARCHAR(50) --parametro de entrada
AS
BEGIN
    PRINT 'HOLA '+' '+ @nombre
END;
GO

EXEC spu_persona_saludar 'ANA';
EXEC spu_persona_saludar 'KAREN';
EXEC spu_persona_saludar 'ALFREDO';
GO

/*SELECT CustomerID, CompanyName, City, Country
INTO Customers
FROM NORTHWND.dbo.Customers;
GO*/

SELECT * FROM Customers;
GO

--realizar un stored que reciba el parametro de un cliente 
--en particular y lo muestre

CREATE OR ALTER PROCEDURE spu_cliente_consultar_por_id
    @ID NVARCHAR(10)--parametro de entrada
AS
BEGIN
    SELECT CustomerID AS [NÚMERO],
    CompanyName AS [CLIENTE],
    City AS [CIUDAD],
    Country AS [PAÍS]
    FROM Customers
    WHERE CustomerID = @ID;
END;
GO

EXECUTE spu_cliente_consultar_por_id 'ANTON';
GO

SELECT 1 FROM Customers
WHERE EXISTS (SELECT 1
FROM Customers 
WHERE CustomerID = 'ANTON');
GO

DECLARE @valor INT

SET @valor = (SELECT 1--select 1 regresa un valor de 1 si existe el cliente, de lo contrario regresa un valor nulo
FROM Customers 
WHERE CustomerID = 'ANTON');

IF @valor = 1
BEGIN
    PRINT 'EL CLIENTE EXISTE';
END
ELSE
BEGIN
    PRINT 'EL CLIENTE NO EXISTE';
END;
GO

CREATE OR ALTER PROCEDURE spu_cliente_consultar_porid
    @ID NVARCHAR(10)--parametro de entrada
AS
BEGIN
    IF LEN(@ID) > 5
    BEGIN
        RAISERROR('EL ID DEL CLIENTE DEBE DE SER MENOR Ó IGUAL A 5',16,2);--si el ID es mayor a 5, se lanza un error con el mensaje especificado 
        --;THROW 5001,'5001, El ID del cliente debe ser menor o igual a 5 ',1;
        RETURN --si el ID es mayor a 5, se lanza un error y se detiene la ejecución del procedimiento
    END;

    IF EXISTS(SELECT 1 FROM Customers  WHERE CustomerID = @ID) 
    BEGIN
        SELECT CustomerID AS [NÚMERO],
        CompanyName AS [CLIENTE],
        City AS [CIUDAD],
        Country AS [PAÍS]
        FROM Customers
        WHERE CustomerID = @ID;

        RETURN;
    END
    --ELSE
        PRINT 'EL CLIENTE NO EXISTE';
END;
GO

EXECUTE spu_cliente_consultar_porid 'ANTONI';--el ID del cliente es mayor a 5, por lo tanto se lanza un error
EXECUTE spu_cliente_consultar_porid @ID = 'ANTON';--el ID del cliente es menor a 5 y existe, por lo tanto se muestra la información del cliente
EXECUTE spu_cliente_consultar_porid @ID = 'PAMEL';--EL ID DEL CLIENTE NO EXISTE ENTONCES NOS MUESTRA EL MENSAJE DE QUE EL CLIENTE NO EXISTE

DECLARE @ID2 AS CHAR(10) = (SELECT CustomerID FROM Customers WHERE CustomerID = 'ANTON');--se declara una variable @ID2 y se le asigna el valor del CustomerID 
EXECUTE spu_cliente_consultar_porid @ID2; 

DECLARE @ID3 AS CHAR(10);
SELECT @ID3 = (SELECT CustomerID FROM Customers WHERE CustomerID = 'ANTON');
EXECUTE spu_cliente_consultar_porid @ID3;--otra forma de asignar el valor del CustomerID a la variable @ID3 y luego ejecutar el procedimiento almacenado con esa variable como parámetro
GO

--PARAMETROS OUTPUT (PARAMETROS DE SALIDA)
CREATE OR ALTER PROCEDURE spu_operacion_sumar
    @a INT,
    @b INT,
    @resultado INT OUTPUT --parametro de salida
AS
BEGIN
    SET @resultado = @a + @b;--se asigna el resultado de la suma de @a y @b a la variable @resultado
END;
GO

--UTILIAR LA VARIABLE DE SALIDA
DECLARE @res INT;--se declara una variable @res para almacenar el resultado de la suma
EXECUTE spu_operacion_sumar  5, 10, @res OUTPUT;--output para que se guarde los datos en la varieble
SELECT @res AS [SUMA];
GO

--CREAR UN sp CON PARAMETROS DE ENTRADA Y SALIDA
--PARA CALCULAR EL AREA DE UN TRIANGULO 
CREATE OR ALTER PROCEDURE spu_calcular_area_triangulo
    @base FLOAT,
    @altura FLOAT,
    @area FLOAT OUTPUT--parametro de salida
AS 
BEGIN
    SET @area = (@base * @altura / 2)
END;
GO

DECLARE @area_triangulo FLOAT;
EXECUTE spu_calcular_area_triangulo 10.1, 6.8, @area_triangulo OUTPUT;
SELECT @area_triangulo AS [AREA DEL TRIANGULO];
GO
--MISMO EJERCICIO PERO AHORA VALIDANDO QUE NOS SEAN NEGATIVO Y MANDANDO ERRORES O CXCEPCIONES
/*CREATE OR ALTER PROC spu_calcular_areatriangulo_validacion
AS
 
BEGIN 
END;
GO*/

/*========================Logica dentro del SP================================*/

--crear un SP que evalue la edad de una persona
CREATE OR ALTER PROC usp_persona_evaluar
    @edad INT
AS 
    IF @edad >= 18 AND @edad <= 45
    BEGIN 
        PRINT('Eres un adulto sin pension')
    END
    ELSE
    BEGIN 
        PRINT('Eres menor de edad')
END;
GO

EXEC usp_persona_evaluar 22;
EXEC usp_persona_evaluar @edad = 55;
GO

CREATE OR ALTER PROC usp_valores_imprimir
    @n AS INT
AS
BEGIN 
    IF @n <= 0
    BEGIN 
        PRINT('ERROR: VALOR DE N NO VALIDO')
        RETURN; 
    END

    DECLARE @i AS INT;
    SET @i = 1;

    WHILE (@i<=@n)
    BEGIN
        PRINT CONCAT('Este es el número: ',@i);
        SET @i = @i+1;
    END
END;

EXEC usp_valores_imprimir -1;
EXEC usp_valores_imprimir 11;
GO

CREATE OR ALTER PROC usp_valores_tabla
    @n AS INT
AS
BEGIN 
    IF @n <= 0
    BEGIN 
        PRINT('ERROR: VALOR DE N NO VALIDO')
        RETURN; 
    END

    DECLARE @i AS INT;
    DECLARE @j INT=1;

    SET @i = 1;

    WHILE (@i<=@n)
    BEGIN
        WHILE (@j <=10)
        BEGIN
            PRINT CONCAT(@i,'*',@j,'= ',(@i*@j))
            SET @j =@j + 1; 
        END
        PRINT (CHAR(13)+ CHAR(10))--CHAR SALTO DE LINEA
         SET @i =@i + 1; 
          SET @j = 1; 
    END
END;

EXEC usp_valores_tabla 3;
GO
/*======================= CASE ==============================*/

--sirve para evaluar condiciones como un swich o un if multiple

CREATE OR ALTER PROC usp_calificacion_evaluar
    @calificacion INT
AS 
BEGIN
    SELECT 
    CASE 
        WHEN @calificacion >= 90 THEN 'EXELENTE'
        WHEN @calificacion >= 70 THEN 'APROVADO' 
        WHEN @calificacion >= 60 THEN 'REGULAR'
        ELSE 'NO ACREDITADO'
        END AS RESULTADO--ALIAS DE LA COLUMNA 
END; 
GO

EXEC usp_calificacion_evaluar 66;

USE NORTHWND;

SELECT 
    ProductName,
    UnitPrice,
    CASE
        WHEN UnitPrice >= 200 THEN 'CARO'
        WHEN UnitPrice > 50 THEN 'MEDIO'
        ELSE 'BARATO'
    END AS [CATEGORIAS]
FROM Products;
GO
--SP calcular comisiones utilizando un rango 

CREATE OR ALTER PROCEDURE usp_comision_ventas
 @idCliente AS NCHAR(10)
AS
BEGIN
    IF LEN(@idCliente)>5
    BEGIN
        PRINT('EL TAMAÑO DEL ID DEL CLIENTE DEBE DE SER DE 5')
        RETURN;
    END

    IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustomerID = @idCliente)
    BEGIN
        PRINT('EL CLIENTE NO EXISTE')
        RETURN;
    END

    DECLARE @comision DECIMAL(10,2);
    DECLARE @total MONEY

    SET @total = (SELECT UnitPrice*Quantity
                        FROM [Order Details] AS od
                        INNER JOIN Orders AS o
                        ON o.OrderID = od.OrderID
                        WHERE o.CustomerID = @idCliente);
    SET @comision =
        CASE 
            WHEN @total >= 19000 THEN 5000
            WHEN @total >= 15000 THEN 2000
            WHEN @total >= 10000 THEN 1000
            ELSE 500
    END;
    PRINT CONCAT( 'VENTAS TOTAL: ', @total, CHAR(13)+CHAR(10),' COMISIÓN: ',@comision,
    'VENTAS MÁS COMISIÓN: ', (@total+@comision))
END;
GO

EXEC usp_comision_ventas OLDWO;
GO

/*=================CRUD CON SP=========================*/

--ejemplo con instert
USE bdstored; 
/*CREATE TABLE productos
(
    id INT IDENTITY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);*/
GO 

/*SP PARA INSERT*/
CREATE OR ALTER PROC usp_InsertarCliente
@nombre VARCHAR(50),
@precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO productos(nombre,precio)
    VALUES (@nombre,@precio);
END;
GO
EXEC usp_InsertarCliente 'Tonayan','4523.22';
SELECT * FROM productos;
GO


--SP PARA UPDATE
CREATE OR ALTER PROC usp_actualizar_precio
    @id INT,
    @precio AS DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM productos WHERE id = @id)
    BEGIN
        UPDATE productos 
        SET precio = @precio
        WHERE id = @id;
        RETURN;
    END
    PRINT 'EL ID DEL PRODUCTO NO EXITE, NO SE REALIZO LA MODIFICACIÓN'
END;
GO

EXECUTE usp_actualizar_precio 12,78.9;--CONFIRMAR ELSE 

EXECUTE usp_actualizar_precio 1,12054.99;--CONFIRMAR EJECUCION 
GO

--SP PARA DELETE
CREATE OR ALTER PROCEDURE usp_eliminar_producto
    @id AS INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM productos WHERE id = @id)
    BEGIN
        DELETE productos
        WHERE id = @id
END
PRINT 'EL ID DEL PRODUCTO NO EXITE, NO SE REALIZO LA MODIFICACIÓN'
END;
GO

SELECT * FROM productos;
GO

/*===========================MANEJO DE ERRORES============================*/
--SIN MANEJO DE ERRORES
SELECT 10/0
--ESTO JENERA UN EEROR O UNA EXCEPCION Y DETIENE LA EJECUCION

BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'OCURRIO EL ERROR'
END CATCH;


BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'MENSAJE: '+ ERROR_MESSAGE();
    PRINT 'NÚMERO: '+ CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'LÍNEA: '+ CAST(ERROR_LINE() AS VARCHAR);
END CATCH;
GO

-- USO CON INSERT
--CREATE TABLE productos2
--(
  --  id INT PRIMARY KEY,
    --nombre VARCHAR(50),
    --precio DECIMAL(10,2)
--);


INSERT INTO productos2 
VALUES (1,'Pitufito',243.3)
GO

BEGIN TRY 
    INSERT INTO productos2
    VALUES(1,'Quemadita',53.33)
END TRY 
BEGIN CATCH
    PRINT 'EROR AL INSERTAR: ' + ERROR_MESSAGE();
    PRINT 'GRAVEDAD' + CAST(ERROR_SEVERITY() AS VARCHAR);
END CATCH;
GO 

SELECT * FROM productos2;

--ejemplo de uso de una transaccion

BEGIN TRANSACTION;

SELECT * FROM productos2;

INSERT INTO productos2
VALUES(2,'PITUFINA',223);

--ROLLBACK;--EL ROLLBACK cancela la transaccion, permite que la bd no quede inconsistente
COMMIT;--EL COMMIT confirma la transaccion por que todo fue atomico o se cumplio

/*================USO DE TRANSACCIÓNES=======================*/
--EJERCICIO PARA VERIFICAR EN DONDE EL TRY CATCH SE VUELVE PODEROSO

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES(3,'charro negro',123.33)

    INSERT INTO productos2
    VALUES(3,'pantera negra',113.33)

    COMMIT;
END TRY
BEGIN CATCH 
    ROLLBACK;
    PRINT 'SE REALIZO UN ERROR'
    PRINT 'ERROR ' + ERROR_MESSAGE()
 
END CATCH;

SELECT * FROM productos2;

--VALIDAR SI UNA TRANSACCION ESTA ACTIVA 

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO productos2
    VALUES(3,'charro negro',123.33)

    INSERT INTO productos2
    VALUES(3,'pantera negra',113.33)

    COMMIT;
END TRY
BEGIN CATCH 
    IF @@TRANCOUNT > 0
        ROLLBACK
    PRINT 'SE REALIZO UN ERROR'
    PRINT 'ERROR ' + ERROR_MESSAGE()
 
END CATCH;
