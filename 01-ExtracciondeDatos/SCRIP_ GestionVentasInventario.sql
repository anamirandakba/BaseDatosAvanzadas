CREATE DATABASE GestionVentasInventario;
GO
USE GestionVentasInventario;
GO

/* CREACIÓN DE TABLAS */

-- CLIENTES
CREATE TABLE Clientes (
    idCliente INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    email NVARCHAR(100) NOT NULL UNIQUE, -- UNIQUE obligatorio
    fechaRegistro DATE NOT NULL DEFAULT GETDATE(),
    estatus NVARCHAR(20) NOT NULL 
        CHECK (estatus IN ('Activo','Inactivo'))
);

-- EMPLEADOS
CREATE TABLE Empleados (
    idEmpleado INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    puesto NVARCHAR(50) NOT NULL,
    fechaContratacion DATE NOT NULL,
    comisionPorc DECIMAL(5,2) NOT NULL 
        CHECK (comisionPorc >= 0)
);

-- CATEGORIAS
CREATE TABLE Categorias (
    idCategoria INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- PRODUCTOS
CREATE TABLE Productos (
    idProducto INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    idCategoria INT NOT NULL,
    precioVenta DECIMAL(10,2) NOT NULL CHECK (precioVenta > 0),
    costoBase DECIMAL(10,2) NOT NULL CHECK (costoBase > 0),
    estatus NVARCHAR(20) NOT NULL 
        CHECK (estatus IN ('Activo','Inactivo')),
    FOREIGN KEY (idCategoria) REFERENCES Categorias(idCategoria)
);

-- PROVEEDORES
CREATE TABLE Proveedores (
    idProveedor INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    email NVARCHAR(100)
);

-- ALMACENES
CREATE TABLE Almacenes (
    idAlmacen INT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    ubicacion NVARCHAR(150) NOT NULL
);

-- INVENTARIO
CREATE TABLE Inventario (
    idAlmacen INT,
    idProducto INT,
    stock INT NOT NULL CHECK (stock >= 0),
    stockMin INT NOT NULL CHECK (stockMin >= 0),
    PRIMARY KEY (idAlmacen, idProducto),
    FOREIGN KEY (idAlmacen) REFERENCES Almacenes(idAlmacen),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
);

-- COMPRAS
CREATE TABLE Compras (
    idCompra INT IDENTITY PRIMARY KEY,
    idProveedor INT NOT NULL,
    fechaCompra DATE NOT NULL,
    estatus NVARCHAR(20) NOT NULL 
        CHECK (estatus IN ('Registrada','Recibida','Cancelada')),
    FOREIGN KEY (idProveedor) REFERENCES Proveedores(idProveedor)
);

-- DETALLE COMPRA
CREATE TABLE DetalleCompra (
    idCompra INT,
    idProducto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0), -- CHECK obligatorio
    costoUnitario DECIMAL(10,2) NOT NULL CHECK (costoUnitario > 0),
    subtotalCalculado AS (cantidad * costoUnitario) PERSISTED,
    PRIMARY KEY (idCompra, idProducto),
    FOREIGN KEY (idCompra) REFERENCES Compras(idCompra),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
);

-- VENTAS
CREATE TABLE Ventas (
    idVenta INT IDENTITY PRIMARY KEY,
    idCliente INT NOT NULL,
    idEmpleado INT NOT NULL,
    fechaVenta DATE NOT NULL,
    estatus NVARCHAR(20) NOT NULL 
        CHECK (estatus IN ('Pendiente','Pagada','Cancelada')),
    FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente),
    FOREIGN KEY (idEmpleado) REFERENCES Empleados(idEmpleado)
);

-- DETALLE VENTA
CREATE TABLE DetalleVenta (
    idVenta INT,
    idProducto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precioUnitario DECIMAL(10,2) NOT NULL CHECK (precioUnitario > 0),
    descuentoPorc DECIMAL(5,2) 
        CHECK (descuentoPorc BETWEEN 0 AND 30),
    subtotalCalculado AS 
    (cantidad * precioUnitario * (1 - descuentoPorc/100.0)) PERSISTED,
    PRIMARY KEY (idVenta, idProducto),
    FOREIGN KEY (idVenta) REFERENCES Ventas(idVenta),
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
);

-- PAGOS VENTA
CREATE TABLE PagosVenta (
    idPago INT IDENTITY PRIMARY KEY,
    idVenta INT NOT NULL,
    fechaPago DATE NOT NULL,
    metodo NVARCHAR(50),
    monto DECIMAL(10,2) NOT NULL CHECK (monto > 0),
    FOREIGN KEY (idVenta) REFERENCES Ventas(idVenta)
);

/* INSERCIONES DE DATOS*/

-- CATEGORIAS
INSERT INTO Categorias(nombre) VALUES
('Electronica'),
('Computo'),
('Accesorios'),
('Oficina'),
('Hogar'),
('Redes');

-- PRODUCTOS
INSERT INTO Productos(nombre,idCategoria,precioVenta,costoBase,estatus) VALUES
('Laptop HP',2,15000,12000,'Activo'),
('Mouse Logitech',3,350,200,'Activo'),
('Teclado Mecanico',3,1200,800,'Activo'),
('Monitor 24',2,3200,2500,'Activo'),
('Impresora Epson',1,4200,3500,'Activo'),
('Router TPLink',6,1500,1000,'Activo'),
('Silla Oficina',4,2500,1800,'Activo'),
('Escritorio Ejecutivo',4,5000,3500,'Activo'),
('USB 64GB',3,250,100,'Activo'),
('SSD 1TB',2,2200,1700,'Activo'),
('WebCam HD',1,900,600,'Activo'),
('Switch 8 Puertos',6,1800,1300,'Activo'),
('Regulador',5,700,400,'Activo'),
('Tablet Samsung',1,6000,4500,'Activo'),
('Cable HDMI',3,180,80,'Activo');

SELECT * FROM Productos;

--CLIENTES
INSERT INTO Clientes(nombre,telefono,email,estatus) VALUES
('Ana Ruiz','7703853136','ana1@mail.com','Activo'),
('Luis Soto','772095668923','luis2@mail.com','Activo'),
('Maria Perez','77392455783','maria3@mail.com','Activo'),
('Carlos Lopez','5622069323','carlos4@mail.com','Activo'),
('Laura Diaz','5510593877','laura5@mail.com','Activo'),
('Pedro Gomez','56191817604','pedro6@mail.com','Activo'),
('Sofia Torres','7773019525','sofia7@mail.com','Activo'),
('Jorge Martinez','5633096817','jorge8@mail.com','Activo'),
('Daniela Cruz','7736348512','daniela9@mail.com','Activo'),
('Miguel Herrera','77114401853','miguel10@mail.com','Activo'),
('Fernanda Ortiz','7711313131','fernanda11@mail.com','Activo'),
('Ricardo Luna','7711414141','ricardo12@mail.com','Activo'),
('Valeria Campos','5501958244','valeria13@mail.com','Activo'),
('Hector Salas','77311952751','hector14@mail.com','Activo'),
('Andrea Molina','7711717171','andrea15@mail.com','Activo');

--  EMPLEADOS
INSERT INTO Empleados(nombre,puesto,fechaContratacion,comisionPorc) VALUES
('Jose Ramirez','Vendedor','2022-01-10',5),
('Laura Jimenez','Vendedor','2021-03-12',4),
('Mario Soto','Supervisor','2020-06-01',6),
('Paola Rios','Vendedor','2023-02-15',5),
('Andres Vega','Vendedor','2022-08-20',3),
('Sandra Mendez','Supervisor','2019-11-11',7);


-- PROVEEDORES
INSERT INTO Proveedores(nombre,telefono,email) VALUES
('Tech Distribuciones','5538600345','distribucionestech1@mail.com'),
('Electronica MX','7731590478','electprov234@mail.com'),
('Global Tech','5624038960','prov3@mail.com'),
('CompuPro','7730166295','provcompu@mail.com'),
('OfficeSupplies','7739021863','Supplies055@mail.com'),
('Redes SA','55090934765','prov6sa6@mail.com'),
('Importadora Norte','5505518742','norteprov7107@mail.com'),
('Digital World','5588888888','world1g@mail.com'),
('Hogar Plus','5599999999','provplussh4529@mail.com'),
('Accesorios Total','5500000000','accstotal11840@mail.com');

--  ALMACENES
INSERT INTO Almacenes(nombre,ubicacion) VALUES
('Almacen Central','Pachuca'),
('Almacen Norte','Tula');

-- INVENTARIO
INSERT INTO Inventario VALUES
(1,1,50,10),(1,2,50,10),(1,3,50,10),(1,4,50,10),(1,5,50,10),
(2,1,40,10),(2,2,40,10),(2,3,40,10),(2,4,40,10),(2,5,40,10);

/* VENTAS*/
SELECT * FROM Ventas;
INSERT INTO Ventas VALUES
(1,1,'2024-01-01','Pagada'),
(2,2,'2024-01-02','Pagada'),
(3,3,'2024-01-03','Pendiente'),
(4,4,'2024-01-04','Cancelada'),
(5,5,'2024-01-05','Pagada'),
(6,1,'2024-01-06','Pagada'),
(7,2,'2024-01-07','Pendiente'),
(8,3,'2024-01-08','Pagada'),
(9,4,'2024-01-09','Cancelada'),
(10,5,'2024-01-10','Pagada'),
(11,6,'2024-01-11','Pagada'),
(12,6,'2024-01-12','Pendiente'),
(13,5,'2024-01-13','Pagada'),
(14,5,'2024-01-14','Cancelada'),
(15,1,'2024-01-15','Pagada'),
(11,1,'2024-01-16','Pagada'),
(12,2,'2024-01-17','Pendiente'),
(13,3,'2024-01-18','Pagada'),
(14,4,'2024-01-19','Cancelada'),
(15,5,'2024-01-20','Pagada'),
(1,6,'2024-01-21','Pagada'),
(2,1,'2024-01-22','Pendiente'),
(3,2,'2024-01-23','Pagada'),
(4,3,'2024-01-24','Cancelada'),
(5,4,'2024-01-25','Pagada');

-- DETALLE VENTA 
SELECT * FROM DetalleVenta;
INSERT INTO DetalleVenta VALUES
(1,1,1,15000,5),(1,2,2,350,0),(1,3,1,1200,10),
(2,1,1,15000,0),(2,4,1,3200,5),(2,5,1,4200,0),
(3,2,3,350,0),(3,6,1,1500,0),(3,7,1,2500,5),
(4,8,1,5000,0),(4,9,5,250,0),(4,10,1,2200,10);


/*PAGOS PARCIALES*/

INSERT INTO PagosVenta VALUES
(1,'2024-01-02','Efectivo',5000),
(1,'2024-01-03','Transferencia',3000),
(2,'2024-01-03','Efectivo',4000),
(3,'2024-01-04','Efectivo',2000),
(5,'2024-01-06','Transferencia',6000),
(6,'2024-01-07','Efectivo',3000),
(8,'2024-01-09','Transferencia',2000),
(10,'2024-01-11','Efectivo',5000);

/* VISTAS */
---------------------------------------------------------------
-- 1) vw_VentaDetallada 
--    Venta + Cliente + Empleado + Producto + importes
---------------------------------------------------------------

CREATE VIEW vw_VentaDetallada AS
SELECT 
    v.idVenta AS [ID],
    v.fechaVenta AS [FECHA],
    c.nombre AS [CLIENTE],
    e.nombre AS [EMPLEADO],
    p.nombre AS [PRODUCTO],
    dv.cantidad AS [CANTIDAD],
    dv.precioUnitario AS [PRECIO],
    dv.descuentoPorc AS [DESCUENTO],
    dv.subtotalCalculado AS [SUBTOTAL]
FROM Ventas AS v
INNER JOIN Clientes AS c 
    ON v.idCliente = c.idCliente
INNER JOIN Empleados e 
    ON v.idEmpleado = e.idEmpleado
INNER JOIN DetalleVenta dv 
    ON v.idVenta = dv.idVenta
INNER JOIN Productos p 
    ON dv.idProducto = p.idProducto;



---------------------------------------------------------------
-- 2) vw_KPI_VentasMensual 
--    Indicadores mensuales
---------------------------------------------------------------

CREATE VIEW vw_KPI_VentasMensual AS
SELECT 
    YEAR(v.fechaVenta) AS [AÑO],
    MONTH(v.fechaVenta) AS [MES],
    COUNT(v.idVenta) AS [TOTAL DE VENTA],
    COUNT(vc.idVenta) AS [VENTAS CANCELADAS],
    ROUND(
        COUNT(vc.idVenta) * 100.0 / COUNT(v.idVenta),
        2
    ) AS [PORCENTAJE DE CANCELADAS]
FROM Ventas v
LEFT JOIN Ventas vc
    ON v.idVenta = vc.idVenta
    AND vc.estatus = 'Cancelada'
GROUP BY YEAR(v.fechaVenta), MONTH(v.fechaVenta);

---------------------------------------------------------------
-- 3) vw_InventarioCritico 
--    Productos con stock menor a stockMin
---------------------------------------------------------------

CREATE VIEW vw_InventarioCritico AS
SELECT 
    a.nombre AS [ALMACEN],
    p.nombre AS [PRODUCTO],
    i.stock AS [STOCK],
    i.stockMin AS [STOCK MINIMO]
FROM Inventario i
INNER JOIN Productos p 
    ON i.idProducto = p.idProducto
INNER JOIN Almacenes a 
    ON i.idAlmacen = a.idAlmacen
WHERE i.stock <= i.stockMin;


---------------------------------------------------------------
-- 4) vw_SaldoPorVenta 
--    Muestra total vendido, total pagado y saldo pendiente
---------------------------------------------------------------

CREATE VIEW vw_SaldoPorVenta AS
SELECT 
    v.idVenta [NUMERO DE VENTA],
    v.fechaVenta AS [FECHA],
    c.nombre AS [NOMBRE DEL CLIENTE],
    SUM(dv.subtotalCalculado) AS [TOTAL DE VENTA],
    ISNULL(SUM(pv.monto),0) AS [TOTAL PAGADO],
    SUM(dv.subtotalCalculado) - ISNULL(SUM(pv.monto),0) AS [SALDO PENDIENTE]
FROM Ventas v
INNER JOIN Clientes c 
    ON v.idCliente = c.idCliente
INNER JOIN DetalleVenta dv 
    ON v.idVenta = dv.idVenta
LEFT JOIN PagosVenta pv 
    ON v.idVenta = pv.idVenta
GROUP BY v.idVenta, v.fechaVenta, c.nombre;



---------------------------------------------------------------
-- 5) vw_UtilidadPorProducto
--    Calcula utilidad real por producto
---------------------------------------------------------------

CREATE VIEW vw_UtilidadPorProducto AS
SELECT 
    p.nombre AS [PRODUCTO],
    SUM(dv.subtotalCalculado) AS [TOTAL VENDIDO],
    SUM(dv.cantidad * p.costoBase) AS [COSTO TOTAL],
    SUM(dv.subtotalCalculado) 
        - SUM(dv.cantidad * p.costoBase) AS [UTILIDAD]
FROM DetalleVenta dv
INNER JOIN Productos p 
    ON dv.idProducto = p.idProducto
GROUP BY p.nombre;

/* INDICES*/
CREATE INDEX IX_Ventas_Fecha 
ON Ventas(fechaVenta);

CREATE INDEX IX_DetalleVenta_Producto 
ON DetalleVenta(idProducto);

CREATE INDEX IX_Inventario_Producto_Almacen
ON Inventario(idProducto,idAlmacen);

CREATE INDEX IX_Ventas_Cliente 
ON Ventas(idCliente);

CREATE INDEX IX_DetalleVenta_Venta 
ON DetalleVenta(idVenta);
