/*===========================VARIABLELS==============================================*/
DECLARE @edad INT;--la variable no tiene un valor asignado
SET @edad = 30;--asignamos un valor a la variable
SELECT @edad AS Edad;--mostramos el valor de la variable y asi mismo se le asigna un alias 
PRINT @edad;--imprime el valor de la variable
PRINT CONCAT('La edad es: ',' ', @edad);--concatena el texto con el valor de la variable

/*===========================EJERCICIOS CON VARIABLES====================================*/
--Declarar una variable llamada precio 
-- asignarle el valor de 150
--calcular el iva del 16%
--mostrar el precio total con iva incluido

DECLARE @precio MONEY=150;--declaramos la variable precio y le asignamos el valor de 150
DECLARE @total MONEY;
SET @total = @precio *1.6;
SELECT @total AS [PrecioTotal];--mostramos el precio total con iva incluido

/*===========================IF ELSE====================================*/
DECLARE @edad2 INT;
SET @edad2 = 18;
IF @edad2 >= 18
BEGIN
    PRINT 'Eres mayor de edad';
    PRINT 'Puedes votar';
    PRINT 'Felicidades';
END
ELSE
    PRINT 'Eres menor de edad';
    PRINT 'Lo siento';

/*===========================EJERCICIOS CON IF/ELSE=====================================*/
--Crear una variable calificacion
--evaluar si es mayor a 70 imprimir aprobado sino reprobado
DECLARE @calificacion INT;
SET @calificacion = 85;
IF @calificacion >= 70
    PRINT 'Aprobado';
ELSE
    PRINT 'Reprobado';


/*===========================WHILE====================================*/

DECLARE @contador INT;
DECLARE @contador2 INT;
SET @contador = 1;
SET @contador2 = 3;

WHILE @contador <= 5

BEGIN
    WHILE @contador2 <= 5
    BEGIN
        PRINT CONCAT('Contador2: ','-', @contador2);
        SET @contador2 = @contador2 + 1;
    END;
    SET @contador2 = 1;
    SET @contador = @contador + 1;
END;
GO

--IMPRIME LOS NUMEROS DEL 10 AL 1
DECLARE @i INT;
SET @i = 10;

WHILE @i >= 1
BEGIN
    PRINT CONCAT('CONTADOR:', @i);
    SET @i = @i - 1;
END;
GO
/*=============STORED PROCEDURE================*/
CREATE OR ALTER  PROCEDURE usp_mensaje_saludar
AS 
BEGIN
    PRINT ('HOLA MUNDO Tansact_SQL');
END;
GO

--para ejecutarlo EXECUTE Ó EXEC

EXECUTE usp_mensaje_saludar;
GO
EXEC usp_mensaje_saludar;
GO

--ELIMINAR EL SP
DROP PROCEDURE usp_mensaje_saludar;
GO
--DROP PROC usp_mensaje_saludar;

/*=========EJERCICIOS CON STORED PROCEDURE=========*/

--Crear un SP que imprima la fecha actual
CREATE OR ALTER PROC usp_fecha_mostrar
AS 
BEGIN
    SELECT GETDATE() AS [Fecha Actual];
END;
GO
EXEC usp_fecha_mostrar;
GO

CREATE OR ALTER PROC usp_fecha_mostrar2
AS 
BEGIN
    PRINT CAST(GETDATE() AS DATE);
END;
GO

EXEC usp_fecha_mostrar2;
GO
--crear un Sp que muestre el nombre dela 
--bsd atualc
CREATE OR ALTER PROC usp_nombrebd_mostrar
AS 
BEGIN   
    SELECT DB_NAME() AS [Nombre_BD];
END;

EXEC usp_nombrebd_mostrar;