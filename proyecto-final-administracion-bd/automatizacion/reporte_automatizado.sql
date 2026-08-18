-- ============================================================
-- AUTOMATIZACIÓN DEL SISTEMA DE BIBLIOTECA
-- Proyecto: proyecto_bibliotecadb
-- Herramienta: DBeaver / PostgreSQL
--
-- Qué automatiza: guarda como objeto permanente de la base el
-- JOIN de prestamos + usuarios + libros, para no tener que
-- reescribirlo cada vez que se necesita el reporte de préstamos.
-- Ejecutar desde el SQL Editor de DBeaver, conectado a
-- proyecto_bibliotecadb (después de correr 01_creacion.sql y
-- 02_datos.sql).
-- ============================================================

-- Eliminar la vista si ya existe (permite volver a correr el script sin error)
DROP VIEW IF EXISTS reporte_prestamos;

-- Crear vista automatizada
CREATE VIEW reporte_prestamos AS
SELECT
    p.id_prestamo,
    u.id_usuario,
    u.nombre AS usuario,
    l.id_libro,
    l.titulo AS libro,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM prestamos p
INNER JOIN usuarios u
    ON p.id_usuario = u.id_usuario
INNER JOIN libros l
    ON p.id_libro = l.id_libro;

-- ============================================================
-- CONSULTA DEL REPORTE AUTOMATIZADO
-- ============================================================
SELECT *
FROM reporte_prestamos
ORDER BY fecha_prestamo DESC;
