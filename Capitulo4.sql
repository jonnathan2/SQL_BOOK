----Capítulo 4. Creating Databases and Tables

--Creating a Database

CREATE DATABASE rookery;

DROP DATABASE rookery; -- Elimina la base de datos
CREATE DATABASE rookery
CHARACTER SET latin1 -- configuración de caracteres
COLLATE latin1_bin;

SHOW DATABASES;

USE rookery;

-- Creating Tables

CREATE TABLE birds(
bird_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
common_name VARCHAR(50),
family_id INT,
description TEXT);  --donde:
-- bird_id es la llave primaria, la instrucción AUTO_INCREMENT va aumentando de a uno en uno, aunque puede decirle que inicie desde otro número.
-- scientific_name es el nombre científico, que puede ser latín o griego. VARCHAR indica el máximo número de caracteres.
-- TEXT indica que es una columna de ancho variable.

DESCRIBE birds;

--Inserting Data

INSERT INTO birds (scientific_name, common_name)
VALUES ('Charadrius vociferus','Killdeer'),
('Gavia immer', 'Great Northern Loon'),
('Aix sponsa', 'Wood Duck'),
('Chordeiles minor', 'Common Nighthawk'),
('Sitta carolinensis', ' White-breasted Nuthatch'),
('Apteryx mantelli', 'North Island Brown Kiwi');

SELECT * FROM birds;

CREATE DATABASE birdwatchers;

CREATE TABLE birdwatchers.humans
(human_id INT AUTO_INCREMENT PRIMARY KEY,
formal_title VARCHAR(25),
name_first VARCHAR(25),
name_last VARCHAR(25),
email_address VARCHAR(255));

INSERT INTO birdwatchers.humans
(name_first,name_last,email_address)
VALUES
('Mr.', 'Russell', 'Dyer', 'russell@mysqlresources.com'),
('Mr.', 'Richard', 'Stringer', 'richard@mysqlresources.com'),
('Ms.', 'Rusty', 'Osborne', 'rusty@mysqlresources.com'),
('Ms.', 'Lexi', 'Hollar', 'alexandra@mysqlresources.com');

--More perspectives on tables

CREATE TABLE bird_families (
family_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
brief_description VARCHAR(255) );

DESCRIBE bird_families;

CREATE TABLE bird_orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
brief_description VARCHAR(255),
order_image BLOB
) DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
