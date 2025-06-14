USE SERV_TEC_DB
GO

INSERT INTO Estado (Descripcion) VALUES 
('RECIBIDO'),
('EN ANALISIS'),
('PRESUPUESTADO'),
('ASIGNADO'),
('EN PROCESO'),
('COMPLETADO');

GO

INSERT INTO CategoriaArticulo (DescripcionCat) VALUES 
('Smartphone'),
('Notebook'),
('PC de Escritorio'),
('Tablet');

GO

INSERT INTO Clientes (Nombre, CuilCuit, Telefono) VALUES 
('Liones Messi', '20333444558', '1133344455'),
('Lionel Scaloni', '27355667789', '1122233344'),
('Emiliano Martinez', '20999888770', '1155566677');

GO

INSERT INTO Empleados (Nombre, Apellido) VALUES 
('Luis', 'Fernandez'),
('Ana', 'Martinez');

GO

INSERT INTO Reparaciones (IDCliente, IDEmpleado, IDCat, IDEstado, FechaIngreso, Descripcion) VALUES 
(1, 1, 1, 1, '2025-06-01', 'Pantalla rota, no enciende'),
(2, 2, 2, 2, '2025-06-03', 'No inicia el sistema operativo'),
(3, NULL, 3, 1, '2025-06-05', 'Fuente dañada, necesita reemplazo');

GO

INSERT INTO Presupuestos (Descripcion, Precio, IDReparacion, Aceptado) VALUES 
('Reemplazo de pantalla y revisión general', 25000, 1000000, 0),
('Formateo completo y reinstalación de sistema', 15000, 1000001, 1),
('Cambio de fuente de alimentación ATX 600W', 18000, 1000002, 0);

GO

INSERT INTO Facturas (IDReparacion, FechaEmision, NumFactura) VALUES 
(1000001, '2025-06-10', 'FAC-0001'),
(1000002, '2025-06-12', 'FAC-0002');