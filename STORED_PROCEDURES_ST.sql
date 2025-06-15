--STORED PROCEDURES--
--Realizar un procedimiento almacenado llamado sp_Insertar_Factura que registre una factura.
--Solo se puede registrar una factura si la reparación fue realizada 
--El procedimiento debe recibir: el IDReparacion,FechaEmision,NumFactura.

--crear procedimiento 
CREATE PROCEDURE sp_Insertar_Factura
(@pIDReparacion BIGINT,
 @pFechaEmision DATE,
 @pNumFactura VARCHAR(255)
 )
AS
BEGIN

--Comenzamos con el manejo de errores
BEGIN TRY

--Declaramos variables
DECLARE @reparado VARCHAR(50)

--Le asignamos valores que provienen de una consulta SQL
--obtener  @reparado
SELECT @reparado=E.Descripcion
FROM Estados E
INNER JOIN Reparaciones R
ON E.IDEstado=R.IDEstado
WHERE R.IDReparacion=@pIDReparacion

-- Validar existencia de datos
IF @reparado IS NULL
BEGIN
RAISERROR ('No se encontró el estado de la reparación.', 16, 1)
RETURN
END
-- Verificamos si el estudiante tiene rol de ALUMNO
IF @reparado <> 'COMPLETADO' AND @reparado <> 'completado'
BEGIN
RAISERROR ('NO SE PUEDE REALIZAR LA OPERACIÓN, LA REPARACIÓN AÚN NO SE HA COMPLETADO.', 16, 1)
RETURN
END

 -- Insertar Factura
INSERT INTO Facturas(IDReparacion,FechaEmision,NumFactura)
VALUES(@pIDReparacion,@pFechaEmision,@pNumFactura)

PRINT 'Factura registrada exitosamente.'

END TRY
BEGIN CATCH
 PRINT ERROR_MESSAGE()
END CATCH

END
