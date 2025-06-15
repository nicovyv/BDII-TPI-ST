CREATE VIEW VW_ReparacionesEnCurso AS

SELECT
	R.IDReparacion,
	C.Nombre AS Cliente,
	R.Descripcion,
	R.FechaIngreso,
	P.Precio AS [Presupuesto Aceptado],
	Em.Nombre + ' ' + Em.Apellido AS [Empleado Asignado],
	Es.Descripcion as Estado,
	R.FechaFinalizacion

FROM Reparaciones R
INNER JOIN Clientes C ON R.IDCliente = C.IDCliente
INNER JOIN PRESUPUESTOS P ON P.IDReparacion = R.IDReparacion
INNER JOIN Estado Es ON ES.IDEstado = R.IDEstado
INNER JOIN Empleados Em ON EM.IDEmpleado = R.IDEmpleado
WHERE P.Aceptado = 1 and Es.Descripcion NOT LIKE 'COMPLETADO'


SELECT * FROM VW_ReparacionesEnCurso

CREATE VIEW VW_FacturacionPorCliente AS

SELECT F.NUMFACTURA AS 'N° FACTURA', C.NOMBRE AS 'NOMBRE CLIENTE',  F.FECHAEMISION AS 'FECHA DE EMISION', 
R.IDREPARACION AS 'ID REPARACION', P.PRECIO AS 'TOTAL FACTURADO'
FROM CLIENTES AS C
INNER JOIN REPARACIONES R ON C.IDCLIENTE = R.IDCLIENTE
INNER JOIN PRESUPUESTOS P ON R.IDREPARACION = P.IDREPARACION
INNER JOIN FACTURAS F ON R.IDREPARACION = F.IDREPARACION

SELECT * FROM VW_FacturacionPorCliente