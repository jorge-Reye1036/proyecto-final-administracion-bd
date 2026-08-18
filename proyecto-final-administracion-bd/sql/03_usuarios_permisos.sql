-- Usuario solo lectura

CREATE ROLE consulta LOGIN PASSWORD 'consulta123';

GRANT CONNECT ON DATABASE proyecto_bibliotecadb TO consulta;
GRANT USAGE ON SCHEMA public TO consulta;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO consulta;

-- Usuario captura

CREATE ROLE captura LOGIN PASSWORD 'captura123';

GRANT CONNECT ON DATABASE proyecto_bibliotecadb TO captura;
GRANT USAGE ON SCHEMA public TO captura;

GRANT SELECT,INSERT,UPDATE
ON usuarios,libros,prestamos
TO captura;

GRANT USAGE,SELECT
ON ALL SEQUENCES IN SCHEMA public
TO captura;
