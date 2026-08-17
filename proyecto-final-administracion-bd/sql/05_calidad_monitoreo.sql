-- Tamaño de la base

SELECT pg_size_pretty(pg_database_size('proyecto_bibliotecadb'));

-- Conexiones activas

SELECT * FROM pg_stat_activity;

-- EXPLAIN

EXPLAIN
SELECT *
FROM prestamos
WHERE id_usuario=3;

-- Problema 1: Correos duplicados (verifica que no existan usuarios repetidos)

SELECT correo,COUNT(*)
FROM usuarios
GROUP BY correo
HAVING COUNT(*)>1;

-- Problema 2: Formatos inválidos - categorías con capitalización inconsistente
-- (por ejemplo 'Terror' y 'terror' se consideran la misma categoría pero se
-- guardaron con formato distinto, lo que afecta filtros y reportes)

SELECT LOWER(categoria) AS categoria_normalizada, COUNT(DISTINCT categoria) AS variantes
FROM libros
GROUP BY LOWER(categoria)
HAVING COUNT(DISTINCT categoria) > 1;

-- Consulta de verificación: muestra el detalle de los libros afectados
-- para poder corregirlos manualmente

SELECT id_libro, titulo, categoria
FROM libros
WHERE LOWER(categoria) IN (
    SELECT LOWER(categoria)
    FROM libros
    GROUP BY LOWER(categoria)
    HAVING COUNT(DISTINCT categoria) > 1
)
ORDER BY LOWER(categoria);

-- Libros prestados actualmente

SELECT titulo
FROM libros
WHERE disponible=FALSE;