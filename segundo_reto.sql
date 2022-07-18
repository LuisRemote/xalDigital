-- Esta parte corresponde al reto de SQL
-- para ello he decidido apoyarme de SQLiteonline.com


-- Parte 1, creacion de tablas
CREATE TABLE aerolineas (
  id_aerolinea INTEGER NULL,
  nombre_aerolinea CHAR NULL
);


CREATE TABLE aeropuertos (
	id_aeropuerto INTEGER NULL,
    nombre_aerolinea CHAR NULL
);


CREATE TABLE movimientos (
  id_movimiento INTEGER NULL,
  descripcion CHAR NULL
);


CREATE TABLE vuelos (
  id_aerolinea INTEGER NULL,
  id_aeropuerto INTEGER NULL,
  id_movimiento INTEGER NULL,
  dia date NULL
);


-- Parte 2, ingreso de informacion
INSERT INTO aerolineas (id_aerolinea, nombre_aerolinea)
VALUES (1, 'Volaris'),
(2, 'Aeromar'),
(3, 'Interjet'),
(4, 'Aeromexico');


INSERT INTO aeropuertos (id_aeropuerto, nombre_aerolinea)
VALUES (1, 'Benito Juarez'),
(2, 'Guanajuato'),
(3, 'La paz'),
(4, 'Oaxaca');


INSERT INTO movimientos (id_movimiento, descripcion)
VALUES (1, 'Salida'), (2, 'Llegada');


INSERT INTO vuelos (id_aerolinea, id_aeropuerto, id_movimiento, dia)
VALUES (1, 1, 1, '2021-05-02'),
(2, 1, 1, '2021-05-02'),
(3, 2, 2, '2021-05-02'),
(4, 3, 2, '2021-05-02'),
(1, 3, 2, '2021-05-02'),
(2, 1, 1, '2021-05-02'),
(2, 3, 1, '2021-05-04'),
(3, 4, 1, '2021-05-04'),
(3, 4, 1, '2021-05-04');


-- Parte 3 Respuesta a preguntas
-- Para todas las preguntas me estoy apoyando de una CTE para obtener las respuestas
WITH resumen AS (
  SELECT a.nombre_aerolinea AS aerolinea, ap.nombre_aerolinea AS aeropuerto, m.descripcion, dia
FROM aerolineas a
INNER JOIN vuelos v
ON a.id_aerolinea = v.id_aerolinea
INNER JOIN aeropuertos ap
ON ap.id_aeropuerto = v.id_aeropuerto
INNER JOIN movimientos m
ON m.id_movimiento = v.id_movimiento
)


-- 3.1 Cual es el nombre del aeropuerto que ha tenido mayor movimiento durante el año?
-- He usado una clausula WHERE para apoyarme en la seleccion del año, en este caso usando
-- el valor 2021 como la informacion en la hoja del reto, pero podria ser cambiado por otro
SELECT aeropuerto, COUNT(*) eventos
FROM resumen
WHERE CAST(SUBSTR(dia, 1, 4) AS integer) = 2021
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
-- Respuesta: Aeropuerto 'La Paz' con 3 eventos al igual que 'Benito Juarez' con mismo numero
-- de eventos seguido de 'Oaxaca' con 2 eventos


-- 3.2 Cual es el nombre de la aerolinea que ha realizado mayor numero de vuelos durante el año
-- Esta pregunta puede responderse de forma similar a la anterior, en este caso
SELECT aerolinea, COUNT(*) eventos
FROM resumen
WHERE CAST(SUBSTR(dia, 1, 4) AS integer) = 2021
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
-- Respuesta: La aerolinea 'Interjet' con 3 eventos al igual que 'Aeromar' con el mismo numero de
-- vuelos, seguidos por 'Volaris' con 2 eventos

-- 3.3 En que dia se han tenido mayor numero de vuelos?
-- Para esta pregunta al igual que las anteriores podemos usar COUNT y agrupaciones por dia
SELECT dia, COUNT(*) eventos
FROM resumen
WHERE CAST(SUBSTR(dia, 1, 4) AS integer) = 2021
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
-- Respuesta: El mayor numero de vuelos se resgistro en el 2021-05-02 con 6 eventos

-- 3.4 Cuales son las aerolineas que tienen mas de 2 vuelos por dia?
-- Esta pregunta a pesar de tener una complejidad un poco mayor que las anteriores
-- se puede resolver facilmente haciendo una consulta a un subquery como el siguiente
SELECT *
FROM (
	SELECT aerolinea, dia, COUNT(*) eventos
	FROM resumen
	WHERE CAST(SUBSTR(dia, 1, 4) AS integer) = 2021
	GROUP BY 1, 2) sub
WHERE eventos >= 2;
-- Respuesta: Para este conjunto de datos, las 3 aerolineas que tienen mas de 2 vuelos
-- por dia son: 'Aeromar', 'Interjet', 'Volaris'.
