-- crear vista reparaciones en curso
USE SERV_TEC_DB

ALTER VIEW VW_ReparacionesEnCurso AS

SELECT
	R.IDReparacion,
	C.Nombre AS Cliente,
	R.Descripcion,
	R.FechaIngreso,
	P.Precio AS [Presupuesto Aceptado],
	Em.Nombre + ' ' + Em.Apellido AS [Empleado Asignado],
	Es.Descripcion as Estado

FROM Reparaciones R
INNER JOIN Clientes C ON R.IDCliente = C.IDCliente
INNER JOIN PRESUPUESTOS P ON P.IDReparacion = R.IDReparacion
INNER JOIN Estado Es ON ES.IDEstado = R.IDEstado
INNER JOIN Empleados Em ON EM.IDEmpleado = R.IDEmpleado
WHERE P.Aceptado = 1 and Es.Descripcion NOT LIKE 'COMPLETADO'
GO
--consultar vista reparaciones en curso
SELECT * FROM VW_ReparacionesEnCurso
GO

--crear vista de facturación por cliente
CREATE VIEW VW_FacturacionPorCliente AS

SELECT F.NUMFACTURA AS 'N° FACTURA',
C.NOMBRE + ' ' + C.APELLIDO AS 'CLIENTE',
F.FECHAEMISION AS 'FECHA DE EMISION', 
R.IDREPARACION AS 'ID REPARACION',
P.PRECIO AS 'TOTAL FACTURADO'
FROM CLIENTES AS C
INNER JOIN REPARACIONES R ON C.IDCLIENTE = R.IDCLIENTE
INNER JOIN PRESUPUESTOS P ON R.IDREPARACION = P.IDREPARACION
INNER JOIN FACTURAS F ON R.IDREPARACION = F.IDREPARACION
GO
--consultar vista facturacion por cliente
SELECT * FROM VW_FacturacionPorCliente
GO

--crear vista Reparaciones sin empleado asignado.
CREATE VIEW VW_Reparaciones_SinEmpleado
AS
SELECT 
    R.IDReparacion Id,
    R.Descripcion,
    CA.DescripcionCat Categoria, 
    C.Nombre + ' ' + C.APELLIDO Cliente, 
    C.Telefono 'Tel. cliente', 
    CASE 
        WHEN E.IDEmpleado IS NULL THEN 'SIN ASIGNAR'
        ELSE CONCAT(E.Nombre, ' ', E.Apellido)
    END AS Empleado, 
    ES.Descripcion Estado, 
    R.FechaIngreso, 
    R.FechaFinalizacion, 
    E.Nombre
FROM Reparaciones R
INNER JOIN Presupuestos P ON R.IDReparacion = P.IDReparacion
INNER JOIN Clientes C ON R.IDCliente = C.IDCliente
LEFT JOIN Empleados E ON R.IDEmpleado = E.IDEmpleado
INNER JOIN CategoriaArticulo CA ON R.IDCat = CA.IDCat
INNER JOIN Estado ES ON R.IDEstado = ES.IDEstado
WHERE R.IDEmpleado IS NULL;
GO

--consultar vista Reparaciones sin empleado asignado
SELECT * FROM vw_Reparaciones_SinEmpleado;
GO

--CREAR VISTA PARA GENERAR REPORTE DE LAS REPARACIONES QUE LLEVA UN EMPLEADO EN EL MES
CREATE OR ALTER VIEW VW_ReparacionesEmpleadoDelMes
AS
SELECT
NOMBRE,
APELLIDO,
dbo.FN_CantidadReparacionesEmpleadoXMes(E.IDEmpleado,MONTH(GETDATE()))AS ReparacionesXEmpleadoXMes
FROM Empleados AS E
GO
--CREAR VISTA PARA GENERAR REPORTE CON NOMBRE Y APELLIDO DEL EMPLEADO,
-- CANTIDAD DE REPARACIONES EN ESTADO 'COMPLETADO' Y EL MES
CREATE VIEW VW_CantidadReparacionesXMesDelEmpleado
AS
SELECT E.NOMBRE,E.APELLIDO,
COUNT(R.IDReparacion) AS CANT_REPARACIONES,
MONTH(R.FechaIngreso) AS MES
FROM Empleados E
INNER JOIN Reparaciones R
ON E.IDEmpleado=R.IDEmpleado
INNER JOIN Estado ES 
ON R.IDEstado=ES.IDEstado
WHERE E.Activo=1 AND ES.Descripcion='COMPLETADO'
GROUP BY E.Nombre,E.Apellido,MONTH(R.FechaIngreso);
GO