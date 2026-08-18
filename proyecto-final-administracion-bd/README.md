# Proyecto Final - Administración de Bases de Datos

**Caso de estudio:** Biblioteca

## 1. Integrantes

- Jorge Antonio Reyes Reyes 

## 2. Descripción del caso y objetivo

El proyecto consiste en el diseño  de una base de datos PostgreSQL para una biblioteca. La
base de datos usa tres tablas relacionadas las cuales son usuarios prestamos y libros. tambien permite registrar a los usuarios que solicitan libros en préstamo, el catálogo de libros
disponibles y el historial de préstamos realizados, incluyendo datos como son sus fechas de entrega y devolución.

El objetivo del proyecto es aplicar los conocimientos vistos en la unidad de aministracion de base de datos en un estudio real en el cual se podran carga de datos, control de usuarios y permisos, respaldo y restauración, importación y
exportación de información, automatización de tareas, monitoreo y revisión de calidad de los datos.

## 3. Modelo relacional

```
usuarios (1) ──< prestamos >── (1) libros
```

- Un usuario puede tener muchos préstamos.
- Un libro puede tener muchos préstamos (a lo largo del tiempo).
- La tabla `prestamos` es la tabla intermedia que relaciona a ambas entidades.

| Tabla     | Llave primaria | Llaves foráneas                          |
|-----------|-----------------|-------------------------------------------|
| usuarios  | id_usuario       | —                                          |
| libros    | id_libro         | —                                          |
| prestamos | id_prestamo      | id_usuario → usuarios, id_libro → libros  |

## 4. Requisitos

- PostgreSQL 17
- DBeaver Community

## 5. Orden de ejecución

Todos los scripts se ejecutan desde el **SQL Editor de DBeaver**, conectado al servidor PostgreSQL local.

1. `sql/01_creacion.sql` — ejecutar primero solo la línea `CREATE DATABASE proyecto_bibliotecadb;`. Después, en
   DBeaver, cambiar el catálogo/base de datos activo del SQL Editor a `proyecto_bibliotecadb` y ejecutar el resto
   del script (creación de tablas, restricciones e índices).
2. `sql/02_datos.sql`
3. `sql/03_usuarios_permisos.sql`
4. `sql/04_consultas.sql`
5. `sql/05_calidad_monitoreo.sql`

## 6. Procedimientos de administración

| Procedimiento | Detalle |
|---|---|
| Respaldo y restauración | Se genera un respaldo con `pg_dump` y se restaura en una base distinta (`proyecto_bibliotecadb_restaurada`) con `pg_restore`. Ver [`respaldo_restauracion/procedimiento.md`](respaldo_restauracion/procedimiento.md). |
| Importación y exportación | Se exporta la tabla `libros` a `libros.csv` y se importa un archivo CSV nuevo con libros adicionales usando DBeaver. Ver [`importacion_exportacion/procedimiento.md`](importacion_exportacion/procedimiento.md). |
| Automatización |  El script [`automatizacion/reporte_automatizado.sql`](automatizacion/reporte_automatizado.sql) genera automáticamente un reporte de préstamos (con estado calculado) y lo guarda con fecha en la tabla `reporte_prestamos`, simulando una tarea programada. |
## 7. Pruebas de usuarios, monitoreo y calidad

**Usuarios y permisos** (`sql/03_usuarios_permisos.sql`): se crean dos roles con privilegio mínimo:
- `consulta`: solo puede leer datos (`SELECT`) de todas las tablas.
- `captura`: puede leer, insertar y actualizar (`SELECT`, `INSERT`, `UPDATE`) en `usuarios`, `libros` y
  `prestamos`, pero no puede eliminar registros.

Ambos roles se probaron creando una conexión nueva en DBeaver para cada uno (con su usuario y contraseña) y
verificando que solo pueden ejecutar las operaciones permitidas: `consulta` recibe un error al intentar un
`INSERT`, y `captura` puede insertar/actualizar pero no puede ejecutar `DELETE`.

**Monitoreo** (`sql/05_calidad_monitoreo.sql`): se revisa el tamaño de la base de datos con
`pg_size_pretty(pg_database_size(...))`, las conexiones activas con `pg_stat_activity`, y se usa `EXPLAIN`
sobre una consulta filtrada por `id_usuario` para comprobar que PostgreSQL utiliza un plan de ejecución
adecuado (búsqueda por índice cuando es posible en lugar de un recorrido completo de la tabla).

**Calidad de datos** (`sql/05_calidad_monitoreo.sql`): se detectaron y documentaron dos problemas posibles:
1. **Duplicados**: consulta que agrupa por correo electrónico para verificar que no existan usuarios
   repetidos.
2. **Formatos inválidos**: la tabla `libros` contenía la categoría "Terror" escrita también como "terror"
   (inconsistencia de mayúsculas/minúsculas). Se incluyó una consulta que normaliza el texto con `LOWER()`
   para detectar estas variantes, y una consulta de verificación que muestra los registros afectados para
   poder corregirlos.

## 8. Sección teórica de MongoDB

Ver [`teoria_mongodb/fundamentos.md`](teoria_mongodb/fundamentos.md).

## 9. Conclusiones

El desarrollo de este proyecto permitió practicar de forma integral las tareas más comunes en la
administración de una base de datos PostgreSQL: desde el diseño del esquema relacional y la carga de datos,
hasta la gestión de usuarios con diferentes privilegios, el respaldo y restauración, la automatización de tareas
y el monitoreo del rendimiento y la calidad de los datos. Comparar PostgreSQL con MongoDB fue una tarea superficila ya que en esta unnidad no se vio mongodb sin embargo ya se contaba con conocimientos previos de esta base de datos por lo tanto al comparar ambas  se puedo entender en qué escenarios conviene un modelo relacional  y en cuáles resulta más conveniente un modelo de documentos flexible.


## Fuentes consultadas

IBM. (2026, 1 junio). *¿Qué es MongoDB?* https://www.ibm.com/mx-es/think/topics/mongodb

MongoDB. (s. f.). *¿Qué es MongoDB?* https://www.mongodb.com/es/company/what-is-mongodb

MongoDB — Colecciones y documentos. (2024, 21 agosto). Medium. Recuperado el 16 de agosto de 2026, de
https://medium.com/@saranipeiris17/mongodb-collections-documents-62ebf2c7d202

*Relational Database vs. Document Database: What's the Difference?* (s. f.). EDB.
https://www.enterprisedb.com/blog/relational-vs-document-database


en la elaboracion del proyecto se utlilizaron herramientas IA como son Claude y chat gpt como apoyo al igual que como una erramienta de correcion de errores como son  de sintaxis y para revision en los scripts SQL.
