CREATE SCHEMA rolMedievalBD;
USE rolMedievalBD;

CREATE TABLE personajes(
	id_personaje INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50),
    titulo VARCHAR(50),
    id_raza INT NOT NULL,
    id_clase INT NOT NULL,
    id_region INT NOT NULL
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


