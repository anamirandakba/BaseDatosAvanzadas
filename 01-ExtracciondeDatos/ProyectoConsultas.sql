USE GestionVentasInventario;
GO

-- Listado de ventas ordenado por fecha
SELECT 
    v.fechaVenta,
    c.nombre AS Cliente,
    e.nombre AS Empleado,
    SUM(dv.subtotalCalculado) AS TotalVenta
FROM Ventas v
INNER JOIN Clientes c ON v.idCliente = c.idCliente
INNER JOIN Empleados e ON v.idEmpleado = e.idEmpleado
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
GROUP BY v.fechaVenta, c.nombre, e.nombre
ORDER BY v.fechaVenta DESC;
GO

-- Detalle de una venta especifica
SELECT 
    p.nombre AS Producto,
    dv.cantidad,
    dv.descuentoPorc,
    dv.subtotalCalculado
FROM DetalleVenta dv
INNER JOIN Productos p ON dv.idProducto = p.idProducto
WHERE dv.idVenta = 1;
GO

-- Top productos mas vendidos
SELECT TOP 10
    p.nombre,
    SUM(dv.cantidad) AS TotalCantidadVendida,
    SUM(dv.subtotalCalculado) AS TotalIngresos
FROM DetalleVenta dv
INNER JOIN Productos p ON dv.idProducto = p.idProducto
GROUP BY p.nombre
ORDER BY TotalCantidadVendida DESC;
GO

-- Top categorias por ingreso
SELECT TOP 5
    c.nombre AS Categoria,
    SUM(dv.subtotalCalculado) AS TotalIngresos
FROM DetalleVenta dv
INNER JOIN Productos p ON dv.idProducto = p.idProducto
INNER JOIN Categorias c ON p.idCategoria = c.idCategoria
GROUP BY c.nombre
ORDER BY TotalIngresos DESC;
GO

-- Clientes frecuentes
SELECT 
    c.nombre,
    COUNT(v.idVenta) AS TotalVentas,
    SUM(dv.subtotalCalculado) AS GastoTotal
FROM Clientes c
INNER JOIN Ventas v ON c.idCliente = v.idCliente
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
GROUP BY c.nombre
HAVING COUNT(v.idVenta) > 3 
   AND SUM(dv.subtotalCalculado) > 10000;
GO

-- Empleados con ventas mayores al promedio mensual
SELECT 
    e.nombre,
    SUM(dv.subtotalCalculado) AS TotalVentas
FROM Empleados e
INNER JOIN Ventas v ON e.idEmpleado = v.idEmpleado
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
GROUP BY e.nombre
HAVING SUM(dv.subtotalCalculado) >
(
    SELECT AVG(TotalMes)
    FROM (
        SELECT SUM(dv2.subtotalCalculado) AS TotalMes
        FROM Ventas v2
        INNER JOIN DetalleVenta dv2 ON v2.idVenta = dv2.idVenta
        GROUP BY MONTH(v2.fechaVenta)
    ) AS Promedios
);
GO

-- Ventas canceladas por mes
SELECT 
    MONTH(fechaVenta) AS Mes,
    COUNT(*) AS TotalCanceladas,
    COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM Ventas) AS Porcentaje
FROM Ventas
WHERE estatus = 'Cancelada'
GROUP BY MONTH(fechaVenta);
GO

-- Saldo por venta mayor a cero
SELECT 
    v.idVenta,
    SUM(dv.subtotalCalculado) AS TotalVenta,
    ISNULL(SUM(pv.monto),0) AS TotalPagado,
    SUM(dv.subtotalCalculado) - ISNULL(SUM(pv.monto),0) AS Saldo
FROM Ventas v
INNER JOIN DetalleVenta dv ON v.idVenta = dv.idVenta
LEFT JOIN PagosVenta pv ON v.idVenta = pv.idVenta
GROUP BY v.idVenta
HAVING SUM(dv.subtotalCalculado) - ISNULL(SUM(pv.monto),0) > 0;
GO

-- Inventario critico por almacen
SELECT 
    a.nombre AS Almacen,
    p.nombre AS Producto,
    i.stock,
    i.stockMin
FROM Inventario i
INNER JOIN Productos p ON i.idProducto = p.idProducto
INNER JOIN Almacenes a ON i.idAlmacen = a.idAlmacen
WHERE i.stock <= i.stockMin;
GO

-- Productos nunca vendidos
SELECT p.nombre
FROM Productos p
LEFT JOIN DetalleVenta dv ON p.idProducto = dv.idProducto
WHERE dv.idProducto IS NULL;
GO

-- KPI ventas mensual filtrado por año
SELECT *
FROM vw_KPI_VentasMensual
WHERE YEAR(fechaVenta) = 2024;
GO

-- Venta detallada por rango y empleado
SELECT *
FROM vw_VentaDetallada
WHERE fechaVenta BETWEEN '2024-01-01' AND '2024-12-31'
AND Empleado = 'Jose Ramirez';
GO