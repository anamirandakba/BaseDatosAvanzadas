/*UNA VISTA O BIEN (VIEW) ES UNA TABLA VISTUAL BASADA EN UNA CONSULTA 
SIRVE PARA REUTILIZAR LOGICA, SIMPLIFICAR CONSULTAS Y CONTROLAR ACCESO
EXISTEN DOS TIPOS DE VIEWS; LAS ALMACENADAS Y LAS MATERIALIZADAS 

-VISTAS ALMACENADAS
.VISTAS MATERIALIZAZDAS(SQL SERVER LLAMADAS VISTAS INDEXADAS)

SINTAXIS

CREATE OR ALTER VIEW vw_NOMBRE DE LA VISTA /vw PARA PODER INDENTIFICARLAS
AS
DEFINICIÓN DE LA VISTA 
*/

--seleccionar todas las ventas por cliente 
--fecha  de venta y rstado

--Buenas practicas 
--nombre de las vistas vw_
--evitar el select * dentro de la vista 
--si se necesita ordenar hazlo al consultar la vista 

CREATE VIEW vw_ventas_totales--crear la vista 
AS 
SELECT --consulta
	v.VentaId,
	v.ClienteId,
	v.FechaVenta,
	v.Estado,
	SUM(dv.Cantidad* dv.PrecioUnit *(1-dv.Descuento/100)) AS [Total]
FROM Ventas AS v
INNER JOIN DetalleVenta AS dv
ON v.VentaId = dv.VentaId
GROUP BY
	v.VentaId,
	v.ClienteId,
	v.FechaVenta,
	v.Estado;

--trabajar con la vista 
SELECT
	vt.VentaId ,
	c.ClienteId,
	c.Nombre,
	Total,
	DATEPART(MONTH,FechaVenta) AS [MES]
FROM vw_ventas_totales AS vt
INNER JOIN Clientes AS c
ON vt.ClienteId = c.ClienteId
WHERE DATEPART(MONTH,FechaVenta) = 1
AND Total >= 3130;

--realizar una vista que se llame vw_detalle_extendido
--que muestre la venta id, el cliente(nombre), producto
--categoria(nombre), cantidad vendida, precio unitario de la venta
--descuento y el total de cada  liena(transaccion)

CREATE VIEW vw_detalles_extendidos
AS

SELECT 
	c.Nombre,
FROM Clientes AS c
INNER JOIN

SELECT *
FROM Productos
SELECT *
FROM C

--en la vista seleccionar 50 lineas ordenadas por la venta id de forma ASC













