CREATE DATABASE db_triggers;
GO
USE db_triggers;
GO
/*CREATE TABLE Productos
(
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2)
);*/
GO

GO
--EJERCICIO 1 --> EVENTO INSERT (TRIGGER)
CREATE OR ALTER TRIGGER trg_test_insert --se crea el triger 
ON Productos--tabla a la que se asocia el trigger
AFTER INSERT--el evento con el que se va a dispirar
AS
BEGIN
    SELECT * FROM inserted;
    SELECT * FROM deleted;
    SELECT * FROM Productos;
END;
GO

--EVALUAR EL TRIGGER

INSERT INTO Productos (id,nombre,precio)
VALUES (1,'BACALAO',300);

INSERT INTO Productos (id,nombre,precio)
VALUES (2,'REYES',428);

INSERT INTO Productos (id,nombre,precio)
VALUES (3,'BUCAÑAS',5843);

INSERT INTO Productos (id,nombre,precio)
VALUES (4,'30X03',543),
       (5,'COSACO',999);

INSERT INTO Productos (id,nombre,precio)
VALUES (6,'Don Peter',110),
       (7,'PRESIMUERTE',97);

SELECT * FROM Productos;

GO
--EVENTO DELETE
CREATE OR ALTER TRIGGER trg_test_delete
ON Productos
AFTER DELETE
AS
BEGIN
    SELECT * FROM deleted;
    SELECT * FROM inserted;
    SELECT * FROM Productos;
END;
GO

DELETE FROM Productos WHERE id = 3; 
GO

--EVENTO UPDATE
CREATE OR ALTER TRIGGER trg_test_update
ON Productos
AFTER UPDATE
AS 
BEGIN
    SELECT * FROM inserted;--el dato nuevo
    SELECT * FROM deleted;--el dato viejo 
END;

UPDATE productos
SET precio = 600
WHERE id = 2;
GO

--CREATE TABLE Productos2
--(
    --id INT PRIMARY KEY,
    ---//nombre VARCHAR(50),
   --// precio DECIMAL(10,2)
--);
GO

--realizar un trigger que permita cancelar la operacion si se inserta 
--mas de un registro al mismo tiempo
CREATE OR ALTER TRIGGER trg_un_solo_registro
ON Productos2
AFTER INSERT
AS
BEGIN
    SELECT * FROM inserted;
    --contar el numero de registros insertados 
    IF(SELECT COUNT(*) FROM inserted) > 1
    BEGIN
        RAISERROR('SOLO SE PERMITENINSERTAR UN REGISTRO A LA VEZ',16,1);
        ROLLBACK TRANSACTION; 
    END;
END;

GO
INSERT INTO Productos2 (id,nombre,precio)
VALUES (1,'Don Peter',110),
       (2,'PRESIMUERTE',97);

INSERT INTO Productos2 (id,nombre,precio)
VALUES (1,'PRESIMUERTE',97);

INSERT INTO Productos2 (id,nombre,precio)
VALUES (2,'FOURLOCO',999);
GO

--REALIZAR UN TRIGGER QUE DETECTE UN CAMBIO EN EL PRECIO 
--Y MANDE UN MENSAJE DE QUE EL PRECIO SE CAMBIO 
CREATE OR ALTER TRIGGER trg_validar_cambio
ON Productos2
AFTER UPDATE
AS
BEGIN
    IF EXISTS( 
        SELECT 1 
        FROM inserted AS i
        INNER JOIN
        deleted AS d
        ON i.id = d.id
        WHERE i.precio <> d.precio)
    BEGIN 
        PRINT 'EL PRECIO SE ACTUALIZO'
    END;
END;
GO

--TRIGER QUE EVITE QUE CAMBIE EL PRECIO DE VENTA DE LA TABLA DETALLE DE VENTA Y DESPUES
--MODIFICARLA PARA QUE NO PUEDA CAMBIAR LA CANTIDAD DE VENTA  

/*CREATE OR ALTER TRIGGER tgr_evitar_cambios
ON Productos 
AFTER UPDATE
AS
BEGIN
END;