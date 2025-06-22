CREATE OR ALTER FUNCTION dbo.fn_CantidadReparacionesEmpleadoXMes (@IDEmpleado BIGINT, @mes INT)
RETURNS INT
AS
BEGIN
    DECLARE @Cantidad INT;

    SELECT @Cantidad = COUNT(*)
    FROM Reparaciones AS R
    WHERE IDEmpleado = @IDEmpleado AND MONTH(R.FechaFinalizacion)= @mes;

    RETURN @Cantidad;
END;