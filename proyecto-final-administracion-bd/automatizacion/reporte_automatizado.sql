-- ============================================================
-- AUTOMATIZACIÓN DEL SISTEMA DE BIBLIOTECA
-- PostgreSQL / DBeaver
-- ============================================================

-- 1. Tabla donde se guardarán los reportes generados
DROP TABLE IF EXISTS reporte_prestamos;

CREATE TABLE reporte_prestamos (
    id_reporte SERIAL PRIMARY KEY,
    fecha_generado TIMESTAMP DEFAULT NOW(),
    id_prestamo INT,
    usuario VARCHAR(100),
    libro VARCHAR(120),
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    estado VARCHAR(20)
);

-- 2. Función que genera y guarda el reporte
DROP FUNCTION IF EXISTS generar_reporte_prestamos();

CREATE FUNCTION generar_reporte_prestamos()
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN

    INSERT INTO reporte_prestamos
        (id_prestamo, usuario, libro, fecha_prestamo, fecha_devolucion, estado)
    SELECT
        p.id_prestamo,
        u.nombre || ' ' || u.apellido,
        l.titulo,
        p.fecha_prestamo,
        p.fecha_devolucion,
        CASE
            WHEN p.fecha_devolucion IS NULL THEN 'Pendiente'
            ELSE 'Devuelto'
        END
    FROM prestamos p
    JOIN usuarios u ON p.id_usuario = u.id_usuario
    JOIN libros l ON p.id_libro = l.id_libro;

    GET DIAGNOSTICS total = ROW_COUNT;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- 3. Ejecutar la automatización
SELECT generar_reporte_prestamos();

-- 4. Mostrar el reporte generado
SELECT *
FROM reporte_prestamos
ORDER BY fecha_generado DESC;
