# Respaldo y Restauración

Existen dos formas de hacer esto: **desde la interfaz gráfica de DBeaver** (recomendada para el
proyecto, ya que es la herramienta que se usa en todo el resto del trabajo) y **por línea de
comandos** con `pg_dump`/`pg_restore` (lo que DBeaver ejecuta internamente). Se documentan ambas.

## 0. Requisito previo: configurar el cliente local de PostgreSQL en DBeaver

DBeaver no trae `pg_dump`/`pg_restore` integrados; usa los que vienen con la instalación de
PostgreSQL en el equipo. Antes de usar Tools → Backup/Restore hay que indicarle la ruta:

1. **Window → Preferences → Database → PostgreSQL → Local client**.
2. Seleccionar la carpeta `bin` de la instalación de PostgreSQL, por ejemplo:
   `C:\Program Files\PostgreSQL\17\bin`
3. Aceptar. Si esta ruta no está configurada, las opciones **Tools → Backup** y
   **Tools → Restore** aparecen deshabilitadas o fallan al ejecutarse.

## 1. Crear respaldo

### Opción A — Desde DBeaver (GUI)

1. En el **Database Navigator**, clic derecho sobre la base `proyecto_bibliotecadb`.
2. **Tools → Backup**.
3. Formato: **Custom** (equivalente a `-F c`, permite restauración selectiva y queda comprimido).
4. Output file: elegir carpeta y nombre, por ejemplo `proyecto_bibliotecadb.backup`.
5. En la pestaña **General**, dejar marcadas todas las tablas (`usuarios`, `libros`, `prestamos`).
6. Clic en **Start**. DBeaver muestra el progreso y un log; al terminar debe decir
   `Backup completed successfully` (o similar).

### Opción B — Línea de comandos

```bash
pg_dump -U postgres -d proyecto_bibliotecadb -F c -f proyecto_bibliotecadb.backup
```

- Si `pg_dump` no se reconoce como comando, es porque la carpeta `bin` de PostgreSQL no está en el
  `PATH` del sistema. Se puede usar la ruta completa en su lugar, por ejemplo en Windows:
  ```bash
  "C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -d proyecto_bibliotecadb -F c -f proyecto_bibliotecadb.backup
  ```
- Pedirá la contraseña del usuario `postgres` de forma interactiva (a menos que exista un
  `pgpass.conf` configurado, ver `automatizacion/explicacion.md`).
- `-F c`: formato *custom* (comprimido, permite restauración selectiva). Es el mismo formato que usa
  la Opción A al elegir "Custom" en DBeaver — ambas rutas producen un archivo equivalente.

## 2. Restaurar

Se restaura en una base **distinta** a la original (`proyecto_bibliotecadb_restaurada`) para no
sobrescribir los datos existentes y poder comparar ambas.

### Crear la base destino (necesario para ambas opciones)

En el SQL Editor de DBeaver, conectado al servidor (no a `proyecto_bibliotecadb`):

```sql
CREATE DATABASE proyecto_bibliotecadb_restaurada;
```

Después, en el Database Navigator, actualizar la conexión (clic derecho → **Refresh**, o F5) para
que `proyecto_bibliotecadb_restaurada` aparezca en la lista de bases.

### Opción A — Desde DBeaver (GUI)

1. Clic derecho sobre `proyecto_bibliotecadb_restaurada` (la base recién creada, vacía) en el
   Database Navigator.
2. **Tools → Restore**.
3. Input file: seleccionar `proyecto_bibliotecadb.backup` generado en el paso 1.
4. Clic en **Start**.
5. Al terminar, clic derecho sobre `proyecto_bibliotecadb_restaurada` → **Refresh** para que
   DBeaver muestre las tablas ya restauradas (`usuarios`, `libros`, `prestamos`) en el navegador.

### Opción B — Línea de comandos

```bash
pg_restore -U postgres -d proyecto_bibliotecadb_restaurada proyecto_bibliotecadb.backup
```

- No lleva `-F c`: `pg_restore` detecta automáticamente el formato del archivo (a diferencia de
  `pg_dump`, donde sí hay que indicar el formato de salida con `-F`).
- Si aparece un error como `role "postgres" already exists` o similar sobre objetos de rol/esquema,
  se puede ignorar si las tablas y los datos sí se restauraron correctamente (ver verificación
  abajo); ese tipo de aviso ocurre porque el rol `postgres` ya existe en el servidor destino, lo cual
  es normal y no afecta los datos.

## 3. Verificación de la restauración

Para comprobar que la restauración fue exitosa, se compara el número de registros de la base
original contra la base restaurada:

```sql
-- Ejecutar en proyecto_bibliotecadb y en proyecto_bibliotecadb_restaurada, y comparar resultados
SELECT
    (SELECT COUNT(*) FROM usuarios) AS total_usuarios,
    (SELECT COUNT(*) FROM libros) AS total_libros,
    (SELECT COUNT(*) FROM prestamos) AS total_prestamos;
```

En DBeaver, esto se hace fácilmente abriendo dos pestañas de SQL Editor, una conectada a cada base
(el catálogo activo se cambia en la barra superior del editor), y ejecutando la misma consulta en
cada una. Si ambos resultados coinciden (10 usuarios, 10 libros, 10 préstamos según los datos de
`sql/02_datos.sql`), la restauración se considera exitosa.

## Errores comunes y cómo resolverlos

| Error | Causa probable | Solución |
|---|---|---|
| `pg_dump: command not found` / `no se reconoce como comando` | La carpeta `bin` de PostgreSQL no está en el `PATH` | Usar la ruta completa al ejecutable, o configurar el "Local client" en DBeaver (paso 0) |
| Tools → Backup/Restore aparece deshabilitado en DBeaver | No se configuró el cliente local de PostgreSQL | Repetir el paso 0 |
| `database "proyecto_bibliotecadb_restaurada" already exists` | Ya se corrió este procedimiento antes y la base sigue existiendo | Eliminar la base restaurada anterior (`DROP DATABASE proyecto_bibliotecadb_restaurada;`) antes de volver a crearla, o usar otro nombre |
| `pg_restore: error: could not execute query: ERROR: relation "usuarios" already exists` | Se intentó restaurar sobre una base que ya tenía tablas cargadas | Restaurar siempre sobre una base recién creada y vacía |
| Pide contraseña y el proceso "se cuelga" en la terminal | `pg_dump`/`pg_restore` esperan que se teclee la contraseña de forma interactiva | Escribir la contraseña cuando la terminal la solicite, o configurar `pgpass.conf` para evitar el prompt |
