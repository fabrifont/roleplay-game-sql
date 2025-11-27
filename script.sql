# -------------- Creación de funciones --------------

DELIMITER //

# Recibe la primary key de un registro de la tabla personajes y devuelve el promedio de sus
# cuatro estadísticas: Ataque, Defensa, Salud y Velocidad.
CREATE FUNCTION promedio_estadisticas(p_id_personaje INT)
RETURNS DECIMAL(2)
DETERMINISTIC
BEGIN
	DECLARE a INT;
    DECLARE d INT;
    DECLARE s INT;
    DECLARE v INT;
	SELECT ataque, defensa, salud, velocidad
	INTO a, d, s, v
	FROM personajes
	WHERE id_personaje = p_id_personaje;
    RETURN (a + d + s + v) / 4;
END //

# Recibe la primary key de un registro de la tabla clases y devuelve la cantidad de personajes
# que hay de esa clase.
CREATE FUNCTION cantidad_clase(p_id_clase INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE cantidad INT;
    SELECT COUNT(id_personaje)
    INTO cantidad
    FROM personajes
    WHERE id_clase = p_id_clase;
	RETURN cantidad;
END
//

DELIMITER ;

# -------------- Creación de vistas --------------

# Permite visualizar más fácilmente la información de los personajes, incluyendo su clase,
# región y raza. Muestra datos de las tablas personajes, razas, regiones y clases.
CREATE VIEW detalle_personajes AS
SELECT p.id_personaje, p.nombre, p.apellido, r.nombre_raza, rg.nombre_region, p.titulo, c.nombre_clase, c.rol
FROM personajes p
JOIN clases c ON p.id_clase = c.id_clase
JOIN razas r ON p.id_raza = r.id_raza
JOIN regiones rg ON p.id_region = rg.id_region;

# Sirve para ver un listado de las regiones de donde provienen los personajes que son magos
# en la base de datos. Muestra datos de la tabla regiones, trabaja con registros de las tablas
# personajes y clases.
CREATE VIEW regiones_magos AS
SELECT r.id_region, r.nombre_region FROM regiones r
JOIN personajes p ON r.id_region = p.id_region
JOIN clases c ON c.id_clase = p.id_clase 
WHERE c.nombre_clase = "Mago";

# Permite ver una lista de nombres y apellidos de los personajes que tienen un dragón como
# mascota. Muestra campos de personajes, trabaja también con mascotas y animales.
CREATE VIEW tiene_dragon AS
SELECT p.id_personaje, p.nombre, p.apellido FROM personajes p
JOIN mascotas m ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE a.nombre = "Dragon";

# Sirve para ver un listado de las mascotas que pueden volar, y sus respectivos dueños.
# Muestra datos de las tablas personajes y mascotas, trabaja también con animales.
CREATE VIEW mascotas_voladoras AS
SELECT m.id_mascota, m.nombre_mascota, p.nombre AS nombre_dueño, p.apellido AS apellido_dueño
FROM mascotas m
JOIN personajes p ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE puede_volar IS TRUE;

# Permite ver una lista de los personajes cuyo rol es de Daño y tienen una mascota, trabaja
# con las tablas personajes, mascotas y animales
CREATE VIEW danios_con_montura AS
SELECT p.id_personaje, p.nombre, p.apellido, p.nombre_clase, m.nombre_mascota, a.nombre AS animal
FROM detalle_personajes p 
JOIN mascotas m ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE p.rol = "Danio";

# Muestra una lista de los personajes junto a su puntuación (promedio de las cuatro
# estadísticas), y ordena los registros en función de ese campo, de manera descendente.
# Trabaja con las tablas personajes y clases, y utiliza la función
# promedio_estadisticas(p_id_personaje INT).
CREATE VIEW clasificacion_personajes AS
SELECT p.id_personaje, p.nombre, p.apellido, c.nombre_clase, promedio_estadisticas(p.id_personaje) AS puntuacion
FROM personajes p
JOIN clases c ON p.id_clase = c.id_clase
ORDER BY puntuacion DESC;

# Muestra los inventarios, pero con nombres de personajes y objetos
CREATE VIEW inventarios_extendido AS
SELECT p.nombre, o.nombre_objeto, i.cantidad FROM personajes p 
JOIN inventarios i ON p.id_personaje = i.id_personaje_duenio
JOIN objetos o ON o.id_objeto = i.id_objeto
ORDER BY p.nombre ASC;

# -------------- Creación de stored procedures --------------

DELIMITER //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística de
# ataque en 5.
CREATE PROCEDURE entrenar_ataque(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET ataque = ataque + 5
    WHERE id_personaje = p_id_personaje;
END //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística de
# defensa en 5.
CREATE PROCEDURE entrenar_defensa(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET defensa = defensa + 5
    WHERE id_personaje = p_id_personaje;
END //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística de
# salud en 5
CREATE PROCEDURE entrenar_salud(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET salud = salud + 5
    WHERE id_personaje = p_id_personaje;
END //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística de
# velocidad en 5.
CREATE PROCEDURE entrenar_velocidad(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET velocidad = velocidad + 5
    WHERE id_personaje = p_id_personaje;
END //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística más
# alta en 5.
CREATE PROCEDURE entrenar_fortaleza(IN p_id_personaje INT)
BEGIN
  DECLARE a INT; DECLARE d INT; DECLARE s INT; DECLARE v INT;
  
  SELECT ataque, defensa, salud, velocidad
    INTO a, d, s, v
  FROM personajes
  WHERE id_personaje = p_id_personaje
  FOR UPDATE;

  IF a >= d AND a >= s AND a >= v THEN
    CALL entrenar_ataque(p_id_personaje);
  ELSEIF d >= a AND d >= s AND d >= v THEN
    CALL entrenar_defensa(p_id_personaje);
  ELSEIF s >= a AND s >= d AND s >= v THEN
    CALL entrenar_salud(p_id_personaje);
  ELSE
    CALL entrenar_velocidad(p_id_personaje);
  END IF;
END //

# Recibe la primary key de un registro de la tabla personajes y aumenta su estadística más
# baja en 5.
CREATE PROCEDURE entrenar_debilidad(p_id_personaje INT)
BEGIN
DECLARE a INT; DECLARE d INT; DECLARE s INT; DECLARE v INT;
  
  SELECT ataque, defensa, salud, velocidad
    INTO a, d, s, v
  FROM personajes
  WHERE id_personaje = p_id_personaje
  FOR UPDATE;

  IF a <= d AND a <= s AND a <= v THEN
    CALL entrenar_ataque(p_id_personaje);
  ELSEIF d <= a AND d <= s AND d <= v THEN
    CALL entrenar_defensa(p_id_personaje);
  ELSEIF s <= a AND s <= d AND s <= v THEN
    CALL entrenar_salud(p_id_personaje);
  ELSE
    CALL entrenar_velocidad(p_id_personaje);
  END IF;
END //

# Muestra el inventario del personaje con el ID recibido como parámetro
CREATE PROCEDURE ver_inventario(p_id_personaje INT)
BEGIN
  SELECT o.nombre_objeto, i.cantidad
  FROM inventarios i JOIN objetos o ON i.id_objeto = o.id_objeto
  WHERE i.id_personaje_duenio = p_id_personaje;
END //

# Muestra las misiones disponibles en la taberna con el ID recibido como parámetro
CREATE PROCEDURE ver_misiones(p_id_taberna INT)
BEGIN
  SELECT m.nombre_mision FROM misiones_por_taberna t
  JOIN misiones m ON p_id_taberna = t.id_taberna
  WHERE m.id_mision = t.id_mision;
END //

# Recibe un log de inventario, un personaje destino y una cantidad.
# Si es posible, envía esa cantidad de objetos al personaje destino.
CREATE PROCEDURE enviar_objetos(p_id_log_inventario INT, p_id_personaje_destino INT, p_cantidad INT)
BEGIN
  DECLARE cantidad_actual INT;
  DECLARE objeto_a_enviar INT;
  DECLARE cantidad_destino INT;
  START TRANSACTION;

  SELECT cantidad, id_objeto INTO cantidad_actual, objeto_a_enviar FROM inventarios
  WHERE p_id_log_inventario = id_log_inventario
  FOR UPDATE;

  SELECT cantidad INTO cantidad_destino FROM inventarios
  WHERE p_id_personaje_destino = id_personaje_duenio AND
  id_objeto = objeto_a_enviar
  FOR UPDATE;

  IF p_cantidad > cantidad_actual THEN
    ROLLBACK;
  ELSEIF p_cantidad = cantidad_actual THEN
    DELETE FROM inventarios WHERE id_log_inventario = p_id_log_inventario;
  ELSE
    UPDATE inventarios SET cantidad = cantidad_actual - p_cantidad
    WHERE p_id_log_inventario = id_log_inventario;
    
  END IF;
  INSERT INTO inventarios (id_log_inventario, id_personaje_duenio, id_objeto, cantidad)
  VALUES (NULL, p_id_personaje_destino, objeto_a_enviar, p_cantidad)
  ON DUPLICATE KEY UPDATE cantidad = cantidad + VALUES(cantidad);
  COMMIT;
END //

# -------------- Creación de triggers --------------

# Cada vez que se modifica una estadística de un personaje, se logea la modificación en la
# tabla log_entrenamiento.
CREATE TRIGGER log_cambio_estadistica
BEFORE UPDATE ON personajes
FOR EACH ROW
BEGIN
	IF OLD.ataque <> NEW.ataque THEN
		INSERT INTO log_entrenamiento (id_personaje, campo_modificado, valor_anterior, valor_nuevo)
		VALUES (OLD.id_personaje, 'ataque', OLD.ataque, NEW.ataque);
	END IF;
	IF OLD.defensa <> NEW.defensa THEN
		INSERT INTO log_entrenamiento (id_personaje, campo_modificado, valor_anterior, valor_nuevo)
		VALUES (OLD.id_personaje, 'defensa', OLD.defensa, NEW.defensa);
	END IF;
	IF OLD.salud <> NEW.salud THEN
		INSERT INTO log_entrenamiento (id_personaje, campo_modificado, valor_anterior, valor_nuevo)
		VALUES (OLD.id_personaje, 'salud', OLD.salud, NEW.salud);
	END IF;
	IF OLD.velocidad <> NEW.velocidad THEN
		INSERT INTO log_entrenamiento (id_personaje, campo_modificado, valor_anterior, valor_nuevo)
		VALUES (OLD.id_personaje, 'velocidad', OLD.velocidad, NEW.velocidad);
	END IF;
END //

# Cada vez que se modifica una estadística de un personaje, se verifica que esta no haya
# superado el número 100, puesto que es el máximo que se puede obtener por estadística.
CREATE TRIGGER estadistica_max
BEFORE UPDATE ON personajes
FOR EACH ROW
BEGIN
	IF NEW.ataque > 100 THEN
		SET NEW.ataque = 100;
	END IF;
	IF NEW.defensa > 100 THEN
		SET NEW.defensa = 100;
	END IF;
	IF NEW.salud > 100 THEN
		SET NEW.salud = 100;
	END IF;
	IF NEW.velocidad > 100 THEN
		SET NEW.velocidad = 100;
	END IF;
END //

CREATE TRIGGER limpiar_registros_vacios_inventario
AFTER UPDATE ON inventarios
FOR EACH ROW
BEGIN
  IF NEW.cantidad < 1 THEN
    DELETE FROM inventarios WHERE id_log_inventario = NEW.id_log_inventario;
  END IF;
END //