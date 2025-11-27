LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1_razas.csv'
INTO TABLE razas
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_raza, nombre_raza, resistencia);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2_clases.csv'
INTO TABLE clases
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_clase, nombre_clase, rol, habilidad);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/3_regiones.csv'
INTO TABLE regiones
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_region, nombre_region, clima);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/4_animales.csv'
INTO TABLE animales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_animal, nombre, piernas, puede_volar, puede_bucear);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/5_personajes.csv'
INTO TABLE personajes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_personaje, nombre, apellido, titulo, id_raza, id_clase, id_region, ataque, defensa, salud, velocidad);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/6_mascotas.csv'
INTO TABLE mascotas
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_mascota, id_animal, id_personaje, nombre_mascota);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/7_objetos.csv'
INTO TABLE objetos
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_objeto, nombre_objeto, descripcion_objeto, consumible, valor);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/8_misiones.csv'
INTO TABLE misiones
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_mision, nombre_mision, nivel_minimo, id_objeto_recompensa, cantidad_recompensa);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/9_tabernas.csv'
INTO TABLE tabernas
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_taberna, nombre_taberna, id_region);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/10_misiones_por_taberna.csv'
INTO TABLE misiones_por_taberna
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_log_mision_taberna, id_taberna, id_mision);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/11_jugadores.csv'
INTO TABLE jugadores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_jugador, username, clave, email, id_personaje);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/12_gremios.csv'
INTO TABLE gremios
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_gremio, nombre_gremio, id_jugador_propietario);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/13_miembros_gremios.csv'
INTO TABLE miembros_gremios
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_membresia, id_jugador, id_gremio, fecha_union);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/14_registro_misiones.csv'
INTO TABLE registro_misiones
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_registro_mision, id_mision, id_personaje, fecha_completada);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/15_inventarios.csv'
INTO TABLE inventarios
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_log_inventario, id_personaje_duenio, id_objeto, cantidad);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/16_log_entrenamiento.csv'
INTO TABLE log_entrenamiento
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_log, id_personaje, campo_modificado, valor_anterior, valor_nuevo, fecha);