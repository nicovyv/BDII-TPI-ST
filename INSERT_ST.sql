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

INSERT INTO Clientes (Nombre, Apellido,CuilCuit, Telefono) VALUES 
('Liones', 'Messi', '20333444558', '1133344455'),
('Lionel','Scaloni', '27355667789', '1122233344'),
('Emiliano', 'Martinez', '20999888770', '1155566677'),
('Juan', 'Pérez', '20123456789', '1123456789'),
('Ana', 'Gómez', '27234567890', '1134567890'),
('Carlos', 'López', '20345678901', '1145678901'),
('Laura', 'Fernández', '27456789012', '1156789012'),
('Miguel', 'Torres', '20567890123', '1167890123'),
('Lucía','Ramos', '27678901234', '1178901234'),
('Roberto', 'Díaz', '20789012345', '1189012345'),
('Sofía', 'Méndez', '27890123456', '1190123456'),
('Diego', 'Suárez', '20901234567', '1101234567'),
('Florencia', 'Moreyra', '27123456780', '1112345678');

GO

INSERT INTO Empleados (Nombre, Apellido,Activo) VALUES 
('Luis', 'Fernandez',1),
('Ana', 'Martinez',0),
('Camila', 'Sánchez', 1),
('Andrés', 'Ruiz', 0),
('Valeria', 'Morales', 1),
('Nicolás', 'Herrera', 1),
('Paula', 'Romero', 1),
('Gonzalo', 'Pereyra', 1),
('Elena', 'Vega', 0),
('Tomás', 'Silva', 1);

GO

INSERT INTO Reparaciones (IDCliente, IDEmpleado, IDCat, IDEstado, FechaIngreso, Descripcion) VALUES 
(1, 1, 1, 1, '2025-06-01', 'Pantalla rota, no enciende'),
(2, 2, 2, 2, '2025-06-03', 'No inicia el sistema operativo'),
(3, NULL, 3, 1, '2025-06-05', 'Fuente da�ada, necesita reemplazo');

GO

INSERT INTO Presupuestos (Descripcion, Precio, IDReparacion, Aceptado) VALUES 
('Reemplazo de pantalla y revisi�n general', 25000, 1000000, 0),
('Formateo completo y reinstalaci�n de sistema', 15000, 1000001, 1),
('Cambio de fuente de alimentaci�n ATX 600W', 18000, 1000002, 0);

GO

INSERT INTO Facturas (IDReparacion, FechaEmision, NumFactura) VALUES 
(1000001, '2025-06-10', 'FAC-0001'),
(1000002, '2025-06-12', 'FAC-0002');

