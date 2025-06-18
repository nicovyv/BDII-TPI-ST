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

GO

---------------------------------------------------------------------------
--Realizar un procedimiento almacenado que llamado sp_Insertar_Presupuesto que se encargue de registrar presupuestos.
--El SP, recibe todos los datos necesarios para generar el presupuesto. Si se quiere registrar un presupuesto con "Aceptado = 1" 
-- y ya existe un presupuesto Aceptado para la reparacion especificada, se le asigna "Aceptado = 0" al Presupuesto actual y luego se asigna 
--el nuevo presupuesto a dicha reparacion. En caso de registrar un presupuesto con "Aceptado = 0", simplemente lo registra
--en la tabla Presupuestos. Ademas actualiza el estado de la reparacion a "Presupuestado (ID = 3)"

CREATE OR ALTER PROCEDURE sp_Insertar_Presupuesto (
    @Descripcion VARCHAR(255),
    @Precio MONEY,
    @Aceptado BIT,
    @IDReparacion BIGINT
)
AS
BEGIN

    IF NOT EXISTS(SELECT 1 FROM Reparaciones WHERE IDReparacion = @IDReparacion)
    BEGIN
        RAISERROR('ERROR: NO EXISTE UNA REPARACION CON ESE ID.', 16, 1)
        return;
    END

    IF(@Precio <= 0 OR @Precio IS NULL)
    BEGIN
        RAISERROR('ERROR: SE DEBE INGRESAR UN PRECIO VÁLIDO.', 16, 1);
        return;
    END

    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS(SELECT 1 FROM Presupuestos WHERE IDReparacion = @IDReparacion AND Aceptado = 1) AND @Aceptado = 1
            BEGIN
                UPDATE Presupuestos SET Aceptado = 0 WHERE IDReparacion = @IDReparacion AND Aceptado = 1
            END
            IF (@Aceptado = 1)
            BEGIN
                UPDATE Reparaciones SET IDEstado = 3 WHERE IDReparacion = @IDReparacion            
            END
            INSERT Presupuestos (Descripcion, Precio, Aceptado, IDReparacion) 
            VALUES (@Descripcion, @Precio, @Aceptado, @IDReparacion)
            PRINT 'PRESUPUESTO AGREGADO CORRECTAMENTE';
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT ERROR_MESSAGE();
    END CATCH
END