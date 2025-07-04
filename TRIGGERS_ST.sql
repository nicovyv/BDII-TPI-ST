CREATE TRIGGER TR_AsignarEmpleadoPresupuestoAceptado
ON PRESUPUESTOS

AFTER UPDATE
AS
BEGIN
	IF(SELECT COUNT(*) FROM INSERTED) = 1 -- VERIFICAR SI SOLO SE HIZO EL CAMBIO EN UNA SOLA FILA
	BEGIN
		IF EXISTS ( --VERIFICAR SI LA REPARACION NO TIENE TECNICO, TIENE EL PRESUPUESTO ACEPTADO Y EL ESTADO ESTA EN PRESUPUESTADO
		SELECT *
		FROM REPARACIONES R
		INNER JOIN INSERTED I ON R.IDREPARACION = I.IDREPARACION
		WHERE R.IDEMPLEADO IS NULL -- LA REPARACION NO TIENE QUE TENER TECNICO
		AND R.IDESTADO = 3 -- EL ESTADO TIENE QUE SER PRESUPUESTADO
		AND I.ACEPTADO = 1 -- EL PRESUPUESTO TIENE QUE ESTAR ACEPTADO
		)
		BEGIN 
			DECLARE @AsignarEmpleadoID BIGINT;

			SELECT TOP 1 @AsignarEmpleadoID = E.IDEMPLEADO -- BUSCAR EL TECNICO CON MENOS REPARACIONES ASIGNADAS
			FROM EMPLEADOS E
			LEFT JOIN REPARACIONES R ON E.IDEMPLEADO = R.IDEMPLEADO AND R.IDESTADO != 6
			WHERE E.ACTIVO != 0  EMPLEADO TIENE QUE ESTAR ACTIVO
			GROUP BY E.IDEMPLEADO --SE AGRUPA POR EMPLEADO
			ORDER BY COUNT(R.IDREPARACION); --SE ORDENA DE MENOR A MAYOR

			UPDATE REPARACIONES
			SET IDEMPLEADO = @AsignarEmpleadoID --ASIGNAR TECNICO
			FROM REPARACIONES R
			INNER JOIN INSERTED I ON R.IDREPARACION = I.IDREPARACION 
			WHERE R.IDEMPLEADO IS NULL
			AND R.IDESTADO = 3
			AND I.ACEPTADO = 1;

			PRINT 'PRESUPUESTO ACEPTADO, REPARACION ASIGNADA AL TECNICO CON MENOS REPARACIONES ASIGNADAS'
		END
	END
END;

GO

CREATE TRIGGER tr_Eliminar_Empleado ON Empleados
INSTEAD OF DELETE
AS
BEGIN
	UPDATE Empleados SET Activo = 0 WHERE IDEmpleado IN (SELECT IDEmpleado FROM deleted);
END;

GO



CREATE TRIGGER tr_Actualizar_Estado_Asignado ON Reparaciones -- DECLARACION TRIGGER
AFTER UPDATE -- AFTER UPDATE, SE DISPARA DESPUES DE ASIGNARSE UN EMPLEADO A LA TABLA REPARACIONES
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION -- INICIO TRANSACCION
			
			DECLARE @IDReparacion BIGINT --DECLARACION DE VARIABLES
			DECLARE @IDEstado INT
			DECLARE @IDEmpleado BIGINT

			SELECT @IDReparacion = I.IDReparacion, -- ASIGNACION DE VARIABLES CON LAS TABLAS INSERTED Y DELETED
					@IDEstado = I.IDEstado,
					@IDEmpleado = I.IDEmpleado
					FROM INSERTED I
					INNER JOIN DELETED D  ON I.IDReparacion = D.IDReparacion;

			   IF (@IDEmpleado IS NOT NULL AND @IDEstado <> 4) -- SI EL EMPLEADO YA NO ES NULL Y EL ESTADO ES DISTINTO DE 4 (ASIGNADO)
            BEGIN
                UPDATE Reparaciones  -- ACTUALIZACION DEL ESTADO EN EL IDREPARACION CORRESPONDIENTE
                SET IDEstado = 4
                WHERE IDReparacion = @IDReparacion;
            END
		COMMIT TRANSACTION   -- COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION -- ROLLBACK Y MENSAJE DE ERROR
			RAISERROR ('Ocurrio un error al cambiar de estado la reparación a ASIGNADO', 16, 1)
	END CATCH

END