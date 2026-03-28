--D1)Empleado y su jefe 
SELECT 
	r.Nombre As [NOMBRE EMPLEADO],
	r.Jefe AS [JEFE],
	r.Puesto AS [PUESTO],
	r.Fecha_Contrato AS [FECHA DE CONTRATO]
FROM Representantes AS r
ORDER BY r.Nombre ASC;

--D2)Representante por puesto y ubicacion
SELECT 
	r.Nombre AS [REPRESENTANTE],
	r.Puesto AS [PUESTO],
	o.Ciudad AS [CIUDAD],
	o.Region AS [REGIÓN],
	r.Cuota AS [CUOTAS],
	o.Ventas AS [VENTAS]
FROM Representantes AS r 
INNER JOIN Oficinas AS o
ON r.Oficina_Rep = o.Oficina
WHERE r.Puesto = 'Representante' 
OR r.Puesto = 'VP Ventas';

--D3) Clientes con variedad de productos 
SELECT 
	COUNT(DISTINCT CONCAT(pe.Fab,po.Id_producto)) AS [ProductosDistintos],
	c.Num_Cli AS [NÚMERO DE CLIENTE],
	c.Empresa AS [EMPRESA]
FROM Clientes AS c
INNER JOIN Pedidos AS pe
ON c.Rep_Cli = pe.Rep
INNER JOIN Productos AS po
ON po.Id_fab = pe.Fab
GROUP BY c.Num_Cli,c.Empresa
ORDER BY c.Empresa ASC 
ORDER BY [ProductosDistintos] DESC;

--D4)PRODUCTO TIPO 'BRAZO' EN RANGO DE PRECIOS 
SELECT
	p.Id_fab AS [FABRICANTE],
	p.Id_fab AS [NÚMERO DE PRODUCTO],
	p.Descripcion AS [DESCRIPCÓN],
	p.Precio AS [PRECIO],
	p.Stock AS [STOCK]
FROM Productos AS p
WHERE p.Descripcion LIKE 'Brazo%' OR
(p.Precio BETWEEN 400 AND 2000)
ORDER BY p.Precio DESC;

--D5)PEDIDOS POR REGION 
SELECT 
	COUNT(p.Num_Pedido) AS [NUMERO DEL PEDIDO],
	SUM(p.Importe) AS [TOTAL IMPORTE],
	o.Region AS [REGIÓN]
FROM Pedidos AS p
INNER JOIN Representantes AS r
ON p.Rep = r.Num_Empl 
INNER JOIN Oficinas AS o
ON r.Num_Empl = o.Oficina 
GROUP BY o.Region
HAVING SUM(p.Importe) > 3000
ORDER BY [TOTAL IMPORTE]  DESC ; 

--D6)CUMPLIMIENTO DE CUOTAS 
SELECT 
	r.Num_Empl,
	r.Nombre,
	r.Cuota,
	r.Ventas,
	SUM((r.Ventas/r.Cuota)*100) AS [CUMPLIMINETO]
FROM Representantes AS r
GROUP BY r.Num_Empl,
	r.Nombre,
	r.Cuota,
	r.Ventas 
ORDER BY [CUMPLIMINETO] DESC


--D7)CUMPLIMINETO DE REPRESENTANTES
CREATE VIEW vw_CumplimientoRep_D
SELECT 
	r.Num_Empl AS [NUMERO DE EMPLEADO],
	r.Nombre AS [NOMBRE],
	r.Cuota,
	r.Ventas,
	SUM((r.Ventas/r.Cuota)*100) AS [CUMPLIMINETO]
FROM Representantes AS r
GROUP BY r.Num_Empl,
	r.Nombre ,
	r.Cuota,
	r.Ventas

--D8)PEDIDOSPOR CIUDAD
CREATE VIEW vw_PedidosPorCiudad_D
SELECT 
	o.Ciudad AS [CIUDAD],
	o.Region AS [REGIÓN],
	COUNT(p.Num_Pedido) AS [NUMPEDIDO],
	SUM(p.Importe) AS [TOTAL IMPORTE]
FROM Pedidos AS p
INNER JOIN Representantes AS r
ON p.Rep = r.Num_Empl 
INNER JOIN Oficinas AS o
ON p.Cliente = o.Oficina 
GROUP BY o.Ciudad,o.Region
HAVING SUM(p.Importe) >= 2 ; 



SELECT * FROM Pedidos
SELECT * FROM Productos
SELECT * FROM Clientes
SELECT * FROM Oficinas
SELECT * FROM Representantes