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