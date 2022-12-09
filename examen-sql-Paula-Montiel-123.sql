create database "examen-Paula-Montiel-123";

\c examen-Paula-Montiel-123;

--1.Crea el modelo 
CREATE TABLE IF NOT EXISTS peliculas(
    id integer,
    nombre character varying(255),
    anno integer,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tags(
    id integer,
    tag character varying(32),
    PRIMARY KEY (id)
);
7
CREATE TABLE IF NOT EXISTS peliculas_tags_relation(
    peli_id integer REFERENCES peliculas,
    tag_id integer REFERENCES tags,
    PRIMARY KEY (peli_id, tag_id)
);

ALTER TABLE
    IF EXISTS peliculas_tags_relation
ADD
    FOREIGN KEY (peli_id) REFERENCES peliculas (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION NOT VALID;

ALTER TABLE
    IF EXISTS peliculas_tags_relation
ADD
    FOREIGN KEY (tag_id) REFERENCES tags (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION NOT VALID;

--2. Inserta 5 películas y 5 tags 
INSERT INTO
    peliculas(id, nombre, anno)
VALUES
    (1, 'Harry Potter', 2002),
    (2, 'Moana', 2016),
    (3, 'Pokemon', 1998),
    (4, 'twilight', 2008),
    (5, 'Batman', 2008);

INSERT INTO
    tags (id, tag)
VALUES
    (1, 'fantasía'),
    (2, 'acción'),
    (3, 'aventura'),
    (4, 'romance'),
    (5, 'infantil');

-- La primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados.
INSERT INTO
    peliculas_tags_relation(peli_id, tag_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 3);

--3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT
    id,
    nombre,
    COUNT(tag_id)
FROM
    peliculas FULL
    OUTER JOIN peliculas_tags_relation ON id = peli_id
GROUP BY
    id;

--4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos dedatos.
CREATE TABLE IF NOT EXISTS preguntas (
    id integer,
    pregunta character varying(255),
    respuesta_correcta character varying,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usuarios (
    id integer,
    nombre character varying(255),
    edad integer,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS respuestas (
    id integer,
    respuesta character varying(255),
    usuario_id integer,
    pregunta_id integer,
    PRIMARY KEY (id)
);

ALTER TABLE
    IF EXISTS respuestas
ADD
    FOREIGN KEY (pregunta_id) REFERENCES preguntas (id) MATCH SIMPLE ON DELETE CASCADE;

ALTER TABLE
    IF EXISTS respuestas
ADD
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id) MATCH SIMPLE ON DELETE CASCADE;

--5. Agrega datos, 5 usuarios y 5 preguntas,
INSERT INTO
    usuarios (id, nombre, edad)
VALUES
    (1, 'Andres', 24),
    (2, 'Alonso', 35),
    (3, 'Angel', 27),
    (4, 'Amanda', 18),
    (5, 'Amelie', 31);

INSERT INTO
    preguntas (id, pregunta, respuesta_correcta)
VALUES
    (
        1,
        '¿Qué actor trabaja como Guasón en Batman The Dark Knigth',
        'Heath Ledger'
    ),
    (
        2,
        '¿Cómo se llamaba el dragon de Mulán?',
        'Mushu'
    ),
    (
        3,
        '¿Quién es el antagonista de Harry Potter?',
        'Lord Voldemort'
    ),
    (
        4,
        '¿Qué ser irrumpe en el castillo de Hogwarts en la cena?',
        'Troll'
    ),
    (
        5,
        '¿Quién acompaña como primer pokemón a Ash Ketshum?',
        'Pikachu'
    );

-- La primera pregunta debe estar contestada dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
INSERT INTO
    respuestas (id, respuesta, usuario_id, pregunta_id)
VALUES
    (1, 'Heath Ledger', 1, 1),
    (2, 'Heath Ledger', 2, 1),
    (3, 'Mushu', 1, 2),
    (4, 'Colagusano', 3, 3),
    (5, 'Dragón', 4, 4);

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT
    c.nombre,
    COUNT(pregunta_id)
FROM
    preguntas AS a
    INNER JOIN respuestas AS b ON a.respuesta_correcta = b.respuesta
    AND a.id = b.pregunta_id
    LEFT JOIN usuarios AS c ON c.id = b.usuario_id
GROUP BY
    nombre;

--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.
SELECT
    pregunta,
    COUNT(pregunta_id)
FROM
    preguntas AS a
    INNER JOIN respuestas AS b ON a.respuesta_correcta = b.respuesta
    AND a.id = b.pregunta_id
    LEFT JOIN usuarios AS c ON c.id = b.usuario_id
GROUP BY
    pregunta;

--8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.
-- Se implemento al principio en la definicion de las tablas
DELETE FROM
    usuarios
WHERE
    id = 1;

--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE
    "usuarios"
ADD
    CONSTRAINT restriccionUsuarioEdad CHECK(edad > 17);

--Validar restricción
INSERT INTO
    usuarios (id, nombre, edad)
VALUES
    (9, 'Juanito', 17);

--10. Altera la tabla existente de usuarios agregando el campo email con la restricción de único.
-- Crear campo email
ALTER TABLE
    "usuarios"
ADD
    email varchar(50);

-- Crear Restricción
ALTER TABLE
    "usuarios"
ADD
    CONSTRAINT restriccionEmail UNIQUE (email);