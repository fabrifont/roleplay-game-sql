CREATE SCHEMA rolMedievalBD;
USE rolMedievalBD;

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
    nombre_taberna VARCHAR(100),
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