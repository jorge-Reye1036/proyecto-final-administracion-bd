# Respaldo y Restauración

## Crear respaldo

```bash
pg_dump -U postgres -d proyecto_bibliotecadb -F c -f proyecto_bibliotecadb.backup
```

## Restaurar

Crear una nueva base:

```sql
CREATE DATABASE proyecto_bibliotecadb_restaurada;
```

Restaurar:

```bash
pg_restore -U postgres -d proyecto_bibliotecadb_restaurada proyecto_bibliotecadb.backup
```

El respaldo puede ejecutarse desde DBeaver utilizando la herramienta **Tools → Backup** siempre que esté configurado el cliente local de PostgreSQL (`pg_dump`).

## Verificación de la restauración

Para comprobar que la restauración fue exitosa, se compara el número de registros de la base original contra la base restaurada:

```sql
-- Ejecutar en proyecto_bibliotecadb y en proyecto_bibliotecadb_restaurada, y comparar resultados
SELECT
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM libros) AS total_libros,
    (SELECT COUNT(*) FROM prestamos) AS total_prestamos;
```

Si ambos resultados coinciden, la restauración se considera exitosa.