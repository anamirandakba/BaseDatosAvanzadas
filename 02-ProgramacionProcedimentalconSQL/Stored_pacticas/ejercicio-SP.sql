

--se ocupa el id cliente y el producto y la cantidad a venter (3 datos)

CREATE DATABASE bd_Actividad;
GO
USE bd_Actividad; 
GO

CREATE TABLE cliente (
    idcliente NCHAR(5) PRIMARY KEY,
    nombre NVARCHAR(100),
    pais NVARCHAR(50),
    ciudad NVARCHAR(50)
);
GO

INSERT INTO bd_Actividad.dbo.cliente (idcliente, nombre,pais,ciudad)
SELECT [CustomerID], [CompanyName], [Country], [City]
FROM NORTHWND.dbo.customers;
GO

CREATE TABLE producto (
    idproducto INT PRIMARY KEY,
    nombre NVARCHAR(100),
    precio DECIMAL(10,2),
    existencia INT
);

INSERT INTO bd_Actividad.dbo.producto (idproducto, nombre, precio, existencia)
SELECT [ProductID], [ProductName], [UnitPrice], [UnitsInStock]
FROM NORTHWND.dbo.products;

CREATE TABLE venta (
    idventa INT PRIMARY KEY IDENTITY(1,1),
    idcliente NCHAR(5),
    fecha DATETIME,
    cliente NVARCHAR(100),
);


CREATE TABLE detalleventa (
    idventa INT,
    idproducto INT,
    cantidad INT,
    precioVenta DECIMAL(10,2),

    CONSTRAINT PK_detalleventa 
    PRIMARY KEY (idventa, idproducto)
);



ALTER TABLE venta
ADD CONSTRAINT FK_venta_cliente
FOREIGN KEY (idcliente)
REFERENCES cliente(idcliente);


ALTER TABLE detalleventa
ADD CONSTRAINT FK_detalle_producto
FOREIGN KEY (idproducto)
REFERENCES producto(idproducto);

ALTER TABLE detalleventa
ADD CONSTRAINT FK_detalle_venta
FOREIGN KEY (idventa)
REFERENCES venta(idventa);
GO


CREATE OR ALTER PROC usp_insertarVenta
    @idcliente NCHAR(5),
    @idproducto INT,
    @cantidad INT
AS
BEGIN

    IF LEN(@idcliente) > 5
    BEGIN
        PRINT 'ERROR: EL ID DEL CLIENTE DEBE SER DE 5 CARACTERES';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM cliente WHERE idcliente = @idcliente)
    BEGIN
        PRINT 'ERROR: EL CLIENTE NO EXISTE';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM producto WHERE idproducto = @idproducto)
    BEGIN
        PRINT 'ERROR: EL PRODUCTO NO EXISTE';
        RETURN;
    END

    DECLARE @existencia INT;
    DECLARE @precio DECIMAL(10,2);
    DECLARE @idventa INT;

    SELECT 
        @existencia = existencia,
        @precio = precio
    FROM producto
    WHERE idproducto = @idproducto;

    IF @existencia < @cantidad
    BEGIN
        PRINT 'ERROR: EXISTENCIA INSUFICIENTE';
        RETURN;
    END

    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO venta (idcliente, fecha)
        VALUES (@idcliente, GETDATE());

        SELECT @idventa = SCOPE_IDENTITY();

        SELECT SCOPE_IDENTITY() AS [UltimoId];

        INSERT INTO detalleventa (idventa, idproducto, cantidad, precioVenta)
        VALUES (@idventa, @idproducto, @cantidad, @precio);

        UPDATE producto
        SET existencia = existencia - @cantidad
        WHERE idproducto = @idproducto;

        COMMIT;

        PRINT 'VENTA REGISTRADA';

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK;

        PRINT 'ERROR EN LA TRANSACCIÓN';
        PRINT ERROR_MESSAGE();

    END CATCH
END;
GO

EXEC usp_insertarVenta  @idcliente = 'ALFKI', @idproducto = 1,@cantidad = 2;

EXEC usp_insertarVenta  @idcliente = 'PERIC', @idproducto = 22,@cantidad = 66;


EXEC usp_insertarVenta @idcliente = 'pepito', @idproducto = 1, @cantidad = 2;



SELECT * FROM venta;
SELECT * FROM detalleventa;
SELECT * FROM producto;
SELECT * FROM cliente;



/*--CREATE TABLE cliente 
CREATE OR ALTER PROC usp_insertarVenta 
@idcliente NCHAR(5),
@idproducto INT,
@cantidad 
AS
BEGIN
    DECLARE @existencia INT
    BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM clientes WHERE idcliente = @idcliente)
    BEGIN
        THROW 50001,  'el cliente no existe',1;
        END

            --validar si el producto existe
            
            --verificar el stock con la cantidad(verificar si es la hay la cantidad nececitada o solicitada)

        BEGIN TRANSACTION

        --INSERTAR VENTAS 
        --verificar el precio del producto
        --insertar en detallesventas
        --actualizar stock en productos

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        ROLLBACK;--solo tener un rollbach en el catch
        PRINT 'ERROR EN LA INSERCIÓN' + ERROR_MESSAGE();
    END CATCH
END;

todo el scrip para insertar , crear las tablas, las inserciones, insertar imagene de la bd 
para inseertar imagenes --->  ![''](direccion de la imagen)