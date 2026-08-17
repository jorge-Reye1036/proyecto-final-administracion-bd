--  Todos los libros

SELECT * FROM libros;

-- Libros disponibles

SELECT titulo,autor
FROM libros
WHERE disponible = TRUE;

-- Buscar libros de Terror

SELECT *
FROM libros
WHERE categoria='Terror';

-- Historial de préstamos

SELECT *
FROM prestamos;

--  JOIN

SELECT
u.nombre,
u.apellido,
l.titulo,
p.fecha_prestamo,
p.fecha_devolucion
FROM prestamos p
INNER JOIN usuarios u
ON p.id_usuario=u.id_usuario
INNER JOIN libros l
ON p.id_libro=l.id_libro;