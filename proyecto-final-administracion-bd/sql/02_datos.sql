
-- USUARIOS

INSERT INTO usuarios(nombre,apellido,correo,telefono) VALUES
('Juan','Pérez','juan@correo.com','6181111111'),
('María','López','maria@correo.com','6181111112'),
('Carlos','Ruiz','carlos@correo.com','6181111113'),
('Ana','Torres','ana@correo.com','6181111114'),
('Luis','Hernández','luis@correo.com','6181111115'),
('Sofía','Martínez','sofia@correo.com','6181111116'),
('Pedro','Ramírez','pedro@correo.com','6181111117'),
('Elena','Flores','elena@correo.com','6181111118'),
('Miguel','Castro','miguel@correo.com','6181111119'),
('Laura','Gómez','laura@correo.com','6181111120');

-- LIBROS

INSERT INTO libros(titulo,autor,categoria,anio,disponible) VALUES
('Cien años de soledad','Gabriel García Márquez','Novela',1967,FALSE),
('El principito','Antoine de Saint-Exupéry','Infantil',1943,TRUE),
('Don Quijote','Miguel de Cervantes','Clásico',1605,FALSE),
('1984','George Orwell','Ficción',1949,FALSE),
('Drácula','Bram Stoker','Terror',1897,TRUE),
('El Hobbit','J.R.R. Tolkien','Fantasía',1937,FALSE),
('La llamada de Cthulhu','H. P. Lovecraft','Terror',1926,TRUE),
('La Odisea','Homero','Épico',-700,TRUE),
('Frankenstein','Mary Shelley','Terror',1818,TRUE),
('IT','Stephen King','terror',1986,TRUE);

-- PRESTAMOS

INSERT INTO prestamos(id_usuario,id_libro,fecha_prestamo,fecha_devolucion) VALUES
(1,4,'2026-08-01','2026-08-10'),
(2,6,'2026-08-02',NULL),
(3,1,'2026-08-03','2026-08-12'),
(4,2,'2026-08-04','2026-08-08'),
(5,5,'2026-08-05',NULL),
(6,3,'2026-08-06','2026-08-15'),
(7,8,'2026-08-07',NULL),
(8,7,'2026-08-08','2026-08-13'),
(9,9,'2026-08-09',NULL),
(10,10,'2026-08-10',NULL);