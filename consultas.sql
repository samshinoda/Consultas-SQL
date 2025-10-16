-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT
	f.title AS titulo_pelicula
FROM film f 
WHERE f.rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT 
	CONCAT(a."first_name", ' ', a.last_name) as nombre_actor
FROM actor a 
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original

SELECT
	f.title AS titulo_pelicula
FROM film f
WHERE f.original_language_id IS NULL
	OR f.original_language_id = f.language_id;

-- 5. Ordena las películas por duración de forma ascendente.

SELECT
	f.title AS titulo_pelicula,
	f.length AS duracion_minutos
FROM film f 
ORDER BY f.length;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a 
WHERE a.last_name = 'ALLEN';

/* 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” 
y muestra la clasificación junto con el recuento. */

SELECT 
	f.rating AS clasificacion,
	count(*) AS cantidad_total_peliculas
FROM film f 
GROUP BY f.rating;

/* 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film. */

SELECT
	f.title AS titulo_pelicula
FROM film f 
WHERE
	f.rating = 'PG-13' OR
	f.length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT
	VARIANCE(f.replacement_cost) AS varianza,
	STDDEV(f.replacement_cost) AS desviacion_estandar
FROM film f;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT
	MAX(f.length ) AS mayor_duracion,
	MIN(f.length ) AS menor_duracion
FROM film f;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT
	p.amount AS coste_alquiler,
    r.rental_date AS fecha_alquiler
FROM payment p 
INNER JOIN rental r 
	ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC, r.rental_id DESC
LIMIT 1 OFFSET 2; 
/* Usamos OFFSET 2 para saltar los dos primeros registros
   después de ordenar de forma descendente por fecha y ID, obteniendo así el antepenúltimo. */

/* 12. Encuentra el título de las películas en la tabla “film” que no sean 
 ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.*/

SELECT 
	f.title AS titulo_pelicula
FROM film f 
WHERE f.rating NOT IN ('NC-17','G');

/* 13. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración. */

SELECT 
	f.rating AS clasificacion,
	ROUND(AVG(f.length), 2) AS promedio_duracion
FROM film f
GROUP BY f.rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT 
	f.title AS titulo_pelicula
FROM film f 
WHERE f.length > 180

-- 15. ¿Cuánto dinero ha generado en total la empresa?

SELECT 
	SUM(p.amount) AS beneficios_totales
FROM payment p;

-- 16. Muestra los 10 clientes con mayor valor de id.

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente
FROM customer c 
ORDER BY c.customer_id DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON f.film_id = fa.film_id
WHERE f.title IN ('EGG IGBY');

-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT f.title AS nombre_pelicula
FROM film f;

/* 19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”. */

SELECT 
	f.title AS titulo_pelicula
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' 
	AND f.length > 180;

/* 20. Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración. */

SELECT 
	c.name AS categoria_pelicula,
	ROUND(AVG(f.length), 2) AS promedio_duracion
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(r.return_date - r.rental_date) AS duracion
FROM rental r;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT 
	COUNT(*) AS cantidad_alquiler,
	r.rental_date AS dia_alquiler
FROM rental r
GROUP BY r.rental_date
ORDER BY cantidad_alquiler DESC;

-- 24. Encuentra las películas con una duración superior al promedio.

SELECT
	f.title AS titulo_pelicula,
	f.length AS duracion
FROM film f
WHERE f.length > (
	SELECT AVG(f.length)
	FROM film f); -- se usa subconsulta en WHERE para comparar cada película con el promedio general.

-- 25. Averigua el número de alquileres registrados por mes.

SELECT 
	DATE_TRUNC('month', r.rental_date) AS mes,
	COUNT(*) AS numero_alquileres
FROM rental r
GROUP BY DATE_TRUNC('month', r.rental_date)
ORDER BY mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT
    AVG(p.amount) AS promedio,
    STDDEV(p.amount) AS desviacion_estandar,
    VARIANCE(p.amount) AS varianza
FROM payment p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?

SELECT DISTINCT
	f.title AS titulo_pelicula
FROM payment p 
JOIN rental r 
	ON p.rental_id = r.rental_id
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
JOIN film f 
	ON i.film_id = f.film_id
WHERE p.amount > (
	SELECT AVG(p.amount) 
	FROM payment p); /* subconsulta para calcular el precio
   medio de todos los alquileres y filtrar solo los superiores.*/

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT 
	a.actor_id
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id ) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT 
	f.title AS titulo_pelicula,	
	COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i 
	ON i.film_id = f.film_id
GROUP BY f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.

SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
	COUNT(fa.film_id) AS numero_peliculas
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

/* 31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados. */

SELECT 
	f.title AS titulo_pelicula, 
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM film f 
LEFT JOIN film_actor fa 
	ON f.film_id = fa.film_id
LEFT JOIN actor a
	ON fa.actor_id = a.actor_id
ORDER BY f.title; -- Uso de LEFT JOIN para incluir películas sin actores asociados.

/* 32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película. */

SELECT  
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
	f.title AS titulo_pelicula
FROM actor a
LEFT JOIN film_actor fa 
	ON fa.actor_id = a.actor_id
LEFT JOIN film f 
	ON fa.film_id = f.film_id
ORDER BY nombre_actor; /* LEFT JOIN con la tabla film_actor asegura que todos 
los actores aparezcan aunque no tengan películas. */

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT
	f.title AS titulo_pelicula,
	r.rental_date AS registro_alquiler
FROM film f 
LEFT JOIN inventory i 
	ON f.film_id = i.film_id
LEFT JOIN rental r 
	ON i.inventory_id = r.inventory_id;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
	SUM(p.amount) AS dinero_gastado
FROM customer c
JOIN payment p 
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY dinero_gastado DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a 
WHERE a.first_name IN ('JOHNNY');

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT 
	a.first_name AS Nombre,
	a.last_name AS Apellido
FROM actor a;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT 
	MIN(a.actor_id) AS id_menor,
	MAX(a.actor_id) AS id_mayor
FROM actor a;

-- 38. Cuenta cuántos actores hay en la tabla “actor”.

SELECT 
	COUNT(a.actor_id) AS numero_actores
FROM actor a;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT
	a.first_name AS nombre,
	a.last_name AS apellido
FROM actor a
ORDER BY a.last_name ASC;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.

SELECT 
	f.title
FROM film f
LIMIT 5;

/* 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido? */

SELECT
	a.first_name AS nombre,
	count(a.first_name) AS numero_veces_repetido
FROM actor a 
GROUP BY a.first_name 
ORDER BY numero_veces_repetido DESC;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT 
	r.rental_id AS id_alquiler,
	CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente
FROM rental r 
JOIN customer c 
	ON r.customer_id = c.customer_id;

/* 43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres. */

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
	r.rental_date AS fecha_alquiler
FROM customer c 
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
ORDER BY nombre_cliente;

/* 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación. */

SELECT *
FROM film f 
CROSS JOIN category c; /* En este caso concreto, el CROSS JOIN no aporta valor dado 
que lo que realiza son todas las combinaciones posibles entre las dos tablas, sin
ninguna condición que relacione las mismas. */

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
JOIN film_category fc
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c."name" = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
LEFT JOIN film_actor fa
	ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

/* 47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.*/

SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
	COUNT(f.film_id) AS cantidad_peliculas
FROM actor a 
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name;

/* 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado. */

CREATE VIEW actor_num_peliculas AS
SELECT
	CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor,
	COUNT(f.film_id) AS cantidad_peliculas
FROM actor a 
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- 49. Calcula el número total de alquileres realizados por cada cliente.

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
	COUNT(r.rental_id) AS numero_alquileres
FROM rental r
JOIN customer c 
	ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT
	SUM(f.length) AS duracion_total,
	c.name AS categoria
FROM film f 
JOIN film_category fc
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c."name" = 'Action'
GROUP BY c.name;

/* 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente.*/

CREATE TEMPORARY TABLE cliente_rentas_temporal AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
		COUNT(r.rental_id) AS numero_alquileres
	FROM rental r
	JOIN customer c 
		ON r.customer_id = c.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name
); /* La tabla temporal almacena el total de alquileres por cliente
   para consultas posteriores sin afectar a la tabla original. */

/* 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.*/

CREATE TEMPORARY TABLE peliculas_alquiladas AS (
	SELECT 
		f.title AS nombre_pelicula,
		COUNT(f.film_id) AS numero_alquileres
	FROM inventory i
	JOIN rental r
		ON i.inventory_id = r.inventory_id
	JOIN film f
		ON i.film_id = f.film_id
	GROUP BY f.film_id, f.title
	HAVING COUNT(f.film_id) >= 10
);

/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película. */

SELECT 
	f.title AS titulo_pelicula
FROM film f 
JOIN inventory i 
	ON f.film_id = i.film_id
JOIN rental r
	ON i.inventory_id = r.inventory_id
JOIN customer c 
	ON r.customer_id = c.customer_id
WHERE CONCAT(c.first_name, ' ', c.last_name) = 'TAMMY SANDERS' 
	AND r.return_date IS NULL
ORDER BY f.title ASC; -- Se aplica r.return_date IS NULL para identificar alquileres activos


/* 54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.*/

SELECT DISTINCT
	a.first_name AS nombre_actor,
	a.last_name AS apellido_actor
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name ASC;

/* 55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.*/

SELECT DISTINCT
	a.first_name AS nombre_actor,
	a.last_name AS apellido_actor
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
JOIN inventory i 
	ON f.film_id = i.film_id
JOIN rental r 
	ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 
    	ON r2.inventory_id = i2.inventory_id
    JOIN film f2 
   		ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name ASC; /*subconsulta para encontrar la
   fecha mínima de alquiler y filtrar actores en películas posteriores.*/
	
/* 56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.*/

SELECT 
	a.first_name AS nombre_actor,
	a.last_name AS apellido_actor
FROM actor a 
WHERE NOT EXISTS (
	SELECT 1
	FROM film_actor fa 
	JOIN film f 
		ON fa.film_id = f.film_id
	JOIN film_category fc 
		ON f.film_id = fc.film_id
	JOIN category c 
		ON fc.category_id = c.category_id
	WHERE fa.actor_id = a.actor_id
		AND c.name = 'Music'
); -- Subconsulta usando NOT EXISTS, que asegura que solo se seleccionen actores sin coincidencias.
		
-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT
    f.title AS titulo_pelicula
FROM film f
JOIN inventory i
	ON i.film_id = f.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
	AND r.return_date > r.rental_date + INTERVAL '8 days';
-- Uso de INTERVAL '8 days' para poder comparar fechas y filtrar.

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

SELECT
	f.title AS titulo_pelicula
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c.category_id = (
	SELECT category_id
	FROM category
	WHERE name = 'Animation'
); -- subconsulta para obtener el category_id de 'Animation' y filtrar todas las películas con ese ID.

/* 59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.*/

SELECT 
	f.title AS titulo_pelicula
FROM film f 
WHERE f.length = (
	SELECT length 
	FROM film
	WHERE title = 'DANCING FEVER'
)
ORDER BY f.title ASC;

/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido. */

SELECT 
	c.first_name AS nombre_cliente,
	c.last_name AS apellido_cliente
FROM customer c 
JOIN rental r 
	ON c.customer_id = r.customer_id
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name ASC; 
-- HAVING con COUNT DISTINCT filtra clientes según número de películas únicas alquiladas.

/* 61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres.*/

SELECT
	c.name AS categoria,
	COUNT(f.film_id) AS total_alquileres
FROM rental r
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON i.film_id = f.film_id
JOIN film_category fc
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
GROUP BY c.name;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT 
	c.name AS categoria,
	COUNT(f.film_id) AS numero_peliculas
FROM film f
JOIN film_category fc
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT *
FROM staff s 
CROSS JOIN store s2;

/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.*/

SELECT
	c.customer_id AS id_cliente,
	c.first_name AS nombre_cliente,
	c.last_name AS apellido_cliente,
	COUNT(f.film_id) AS peliculas_alquiladas
FROM customer c 
JOIN rental r 
	ON c.customer_id = r.customer_id
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
JOIN film f 
	ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;