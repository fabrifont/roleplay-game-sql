CREATE SCHEMA stormforge_kingdoms;
USE stormforge_kingdoms;

CREATE TABLE personajes(
	id_personaje INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50),
    titulo VARCHAR(50),
    id_raza INT NOT NULL,
    id_clase INT NOT NULL,
    id_region INT NOT NULL,
    ataque INT NOT NULL,
    defensa INT NOT NULL,
    salud INT NOT NULL,
    velocidad INT NOT NULL
);

CREATE TABLE clases(
	id_clase INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_clase VARCHAR(50) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    habilidad VARCHAR(50) NOT NULL
);

CREATE TABLE mascotas(
	id_mascota INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_personaje INT NOT NULL UNIQUE,
    nombre_mascota VARCHAR(50) NOT NULL
);

CREATE TABLE animales(
	id_animal INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    piernas INT NOT NULL,
    puede_volar BOOL NOT NULL,
    puede_bucear BOOL NOT NULL
);

CREATE TABLE regiones(
	id_region INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_region VARCHAR(50) NOT NULL,
    clima VARCHAR(50) NOT NULL
);

CREATE TABLE razas(
	id_raza INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_raza VARCHAR(50) NOT NULL,
    resistencia VARCHAR(50) NOT NULL
);

CREATE TABLE log_entrenamiento (
  id_log INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  id_personaje INT NOT NULL,
  campo_modificado VARCHAR(50),
  valor_anterior INT,
  valor_nuevo INT,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# --------------------------------- Entrega final ---------------------------------

CREATE TABLE jugadores (
    id_jugador INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    clave VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    id_personaje INT NOT NULL
);

CREATE TABLE misiones (
    id_mision INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_mision VARCHAR(100) NOT NULL,
    nivel_minimo INT,
    id_objeto_recompensa INT,
    cantidad_recompensa INT
);

CREATE TABLE registro_misiones (
    id_registro_mision INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_mision INT NOT NULL,
    id_personaje INT NOT NULL,
    fecha_completada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE objetos (
    id_objeto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_objeto VARCHAR(100) NOT NULL,
    descripcion_objeto VARCHAR(150),
    consumible BOOLEAN NOT NULL,
    valor INT NOT NULL
);

CREATE TABLE inventarios (
    id_log_inventario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_personaje_duenio INT NOT NULL,
    id_objeto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0)
);

CREATE TABLE tabernas (
    id_taberna INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_taberna VARCHAR(100) NOT NULL,
    id_region INT NOT NULL
);

CREATE TABLE misiones_por_taberna (
    id_log_mision_taberna INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_taberna INT NOT NULL,
    id_mision INT NOT NULL
);

CREATE TABLE gremios (
    id_gremio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_gremio VARCHAR(50) NOT NULL UNIQUE,
    id_jugador_propietario INT NOT NULL
);

CREATE TABLE miembros_gremios (
    id_membresia INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_jugador INT NOT NULL,
    id_gremio INT NOT NULL,
    fecha_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE personajes
ADD CONSTRAINT fk_personaje_raza
FOREIGN KEY (id_raza) REFERENCES razas (id_raza);

ALTER TABLE personajes
ADD CONSTRAINT fk_personaje_clase
FOREIGN KEY (id_clase) REFERENCES clases (id_clase);

ALTER TABLE personajes
ADD CONSTRAINT fk_personaje_region
FOREIGN KEY (id_region) REFERENCES regiones (id_region);

ALTER TABLE mascotas
ADD CONSTRAINT fk_mascota_animal
FOREIGN KEY (id_animal) REFERENCES animales (id_animal);

ALTER TABLE mascotas
ADD CONSTRAINT fk_mascota_personaje
FOREIGN KEY (id_personaje) REFERENCES personajes (id_personaje);

ALTER TABLE log_entrenamiento
ADD CONSTRAINT fk_personaje_log
FOREIGN KEY (id_personaje) REFERENCES personajes (id_personaje);

ALTER TABLE jugadores
ADD CONSTRAINT fk_jugador_personaje
FOREIGN KEY (id_personaje) REFERENCES personajes (id_personaje);

ALTER TABLE misiones
ADD CONSTRAINT fk_mision_objeto_recompensa
FOREIGN KEY (id_objeto_recompensa) REFERENCES objetos (id_objeto);

ALTER TABLE registro_misiones
ADD CONSTRAINT fk_registro_mision
FOREIGN KEY (id_mision) REFERENCES misiones (id_mision);

ALTER TABLE registro_misiones
ADD CONSTRAINT fk_registro_personaje
FOREIGN KEY (id_personaje) REFERENCES personajes (id_personaje);

ALTER TABLE inventarios
ADD CONSTRAINT fk_inventario_personaje_duenio
FOREIGN KEY (id_personaje_duenio) REFERENCES personajes (id_personaje);

ALTER TABLE inventarios
ADD CONSTRAINT fk_inventario_objeto
FOREIGN KEY (id_objeto) REFERENCES objetos (id_objeto);

ALTER TABLE inventarios
ADD UNIQUE KEY ux_persona_objeto (id_personaje_duenio, id_objeto);

ALTER TABLE tabernas
ADD CONSTRAINT fk_taberna_region
FOREIGN KEY (id_region) REFERENCES regiones (id_region);

ALTER TABLE misiones_por_taberna
ADD CONSTRAINT fk_taberna_registro_misiones_por_taberna
FOREIGN KEY (id_taberna) REFERENCES tabernas (id_taberna);

ALTER TABLE misiones_por_taberna
ADD CONSTRAINT fk_mision_registro_misiones_por_taberna
FOREIGN KEY (id_mision) REFERENCES misiones (id_mision);

ALTER TABLE gremios
ADD CONSTRAINT fk_jugador_propietario_gremio
FOREIGN KEY (id_jugador_propietario) REFERENCES jugadores (id_jugador);

ALTER TABLE miembros_gremios
ADD CONSTRAINT fk_jugador_miembro
FOREIGN KEY (id_jugador) REFERENCES jugadores (id_jugador);

ALTER TABLE miembros_gremios
ADD CONSTRAINT fk_gremio_miembro
FOREIGN KEY (id_gremio) REFERENCES gremios (id_gremio);

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

# Cada vez que se modifica un registro de la tabla inventarios, revisa si el campo
# cantidad del mismo es igual a 0. Si es el caso, elimina el registro de la tabla,
# ya que no puede haber registros de inventario con cantidades nulas
CREATE TRIGGER limpiar_registros_vacios_inventario
AFTER UPDATE ON inventarios
FOR EACH ROW
BEGIN
  IF NEW.cantidad < 1 THEN
    DELETE FROM inventarios WHERE id_log_inventario = NEW.id_log_inventario;
  END IF;
END //

DELIMITER ;

# Usuarios de la base de datos

# visitante: sólo tiene acceso de lectura a las tablas de la base de datos
CREATE USER 'visitante'@'localhost' IDENTIFIED BY 'visitante';
GRANT SELECT ON stormforge_kingdoms.* TO 'visitante'@'localhost';

# moderador: tiene acceso de lectura, inserción y actualización de datos en las tablas, no puede borrar nada
CREATE USER 'moderador'@'localhost' IDENTIFIED BY 'moderador!321321';
GRANT SELECT, INSERT, UPDATE ON stormforge_kingdoms.* TO 'moderador'@'localhost';

# administrador: tiene acceso irrestricto a todas las tablas de la base de datos
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'administrador!98323';
GRANT ALL ON stormforge_kingdoms.* TO 'administrador'@'localhost';
