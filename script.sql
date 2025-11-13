# -------------- Creación de vistas --------------

CREATE VIEW detalle_personajes AS
SELECT p.id_personaje, p.nombre, p.apellido, r.nombre_raza, rg.nombre_region, p.titulo, c.nombre_clase, c.rol
FROM personajes p
JOIN clases c ON p.id_clase = c.id_clase
JOIN razas r ON p.id_raza = r.id_raza
JOIN regiones rg ON p.id_region = rg.id_region;

CREATE VIEW regiones_magos AS
SELECT r.id_region, r.nombre_region FROM regiones r
JOIN personajes p ON r.id_region = p.id_region
JOIN clases c ON c.id_clase = p.id_clase 
WHERE c.nombre_clase = "Mago";

CREATE VIEW tiene_dragon AS
SELECT p.id_personaje, p.nombre, p.apellido FROM personajes p
JOIN mascotas m ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE a.nombre = "Dragón";

CREATE VIEW mascotas_voladoras AS
SELECT m.id_mascota, m.nombre_mascota, p.nombre AS nombre_dueño, p.apellido AS apellido_dueño
FROM mascotas m
JOIN personajes p ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE puede_volar IS TRUE;

CREATE VIEW daños_con_montura AS
SELECT p.id_personaje, p.nombre, p.apellido, p.nombre_clase, m.nombre_mascota, a.nombre AS animal
FROM detalle_personajes p 
JOIN mascotas m ON p.id_personaje = m.id_personaje
JOIN animales a ON m.id_animal = a.id_animal
WHERE p.rol = "Daño";

# -------------- Creación de funciones --------------



# -------------- Creación de stored procedures --------------

DELIMITER //

CREATE PROCEDURE entrenar_ataque(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET ataque = ataque + 5
    WHERE id_personaje = p_id_personaje;
END //

CREATE PROCEDURE entrenar_defensa(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET defensa = defensa + 5
    WHERE id_personaje = p_id_personaje;
END //

CREATE PROCEDURE entrenar_salud(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET salud = salud + 5
    WHERE id_personaje = p_id_personaje;
END //

CREATE PROCEDURE entrenar_velocidad(p_id_personaje INT)
BEGIN
	UPDATE personajes
    SET velocidad = velocidad + 5
    WHERE id_personaje = p_id_personaje;
END //

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

# -------------- Creación de triggers --------------