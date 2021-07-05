----Capítulo 6. Inserting Data

--The Syntax
USE test;

DESCRIBE books;

INSERT INTO books
VALUES('The Big Sleep', 'Raymond Chandler', '1934');

INSERT INTO books
VALUES('The Thirty-Nine Steps', 'John Buchan', DEFAULT);

INSERT INTO books
(author, title)
VALUES('Evelyn Waugh','Brideshead Revisited');

INSERT INTO books
(title, author, year)
VALUES('Visitation of Spirits','Randall Kenan','1989'),
('Heart of Darkness','Joseph Conrad','1902'),
('The Idiot','Fyodor Dostoevsky','1871');

--Practical Examples
--The table for bird orders
USE rookery;

DESCRIBE bird_orders;

ALTER TABLE bird_orders
AUTO_INCREMENT = 100;

INSERT INTO bird_orders (scientific_name, brief_description)
VALUES('Anseriformes', "Waterfowl"),
('Galliformes', "Fowl"),
('Charadriiformes', "Gulls, Button Quails, Plovers"),
('Gaviiformes', "Loons"),
('Podicipediformes', "Grebes"),
('Procellariiformes', "Albatrosses, Petrels"),
('Sphenisciformes', "Penguins"),
('Pelecaniformes', "Pelicans"),
('Phaethontiformes', "Tropicbirds"),
('Ciconiiformes', "Storks"),
('Cathartiformes', "New-World Vultures"),
('Phoenicopteriformes', "Flamingos"),
('Falconiformes', "Falcons, Eagles, Hawks"),
('Gruiformes', "Cranes"),
('Pteroclidiformes', "Sandgrouse"),
('Columbiformes', "Doves and Pigeons"),
('Psittaciformes', "Parrots"),
('Cuculiformes', "Cuckoos and Turacos"),
('Opisthocomiformes', "Hoatzin"),
('Strigiformes', "Owls"),
('Struthioniformes', "Ostriches, Emus, Kiwis"),
('Tinamiformes', "Tinamous"),
('Caprimulgiformes', "Nightjars"),
('Apodiformes', "Swifts and Hummingbirds"),
('Coraciiformes', "Kingfishers"),
('Piciformes', "Woodpeckers"),
('Trogoniformes', "Trogons"),
('Coliiformes', "Mousebirds"),
('Passeriformes', "Passerines");

-- The Table for Bird Families

DESCRIBE bird_families;

SELECT order_id FROM bird_orders
WHERE scientific_name = 'Gaviiformes';

INSERT INTO bird_families
VALUES(100, 'Gaviidae',
"Loons or divers are aquatic birds found mainly in the Northern Hemisphere.",
103);

INSERT INTO bird_families
VALUES('Anatidae', "This family includes ducks, geese and swans.", NULL, 103);

SHOW WARNINGS;

SELECT * FROM bird_families ;

DELETE FROM bird_families
WHERE family_id = 101;

INSERT INTO bird_families
(scientific_name, order_id, brief_description)
VALUES('Anatidae', 103, "This family includes ducks, geese and swans.");

SELECT * FROM bird_families;

SELECT order_id, scientific_name FROM bird_orders;

INSERT INTO bird_families
(scientific_name, order_id)
VALUES('Charadriidae', 109),
('Laridae', 102),
('Sternidae', 102),
('Caprimulgidae', 122),
('Sittidae', 128),
('Picidae', 125),
('Accipitridae', 112),
('Tyrannidae', 128),
('Formicariidae', 128),
('Laniidae', 128);

SELECT family_id, scientific_name
FROM bird_families
ORDER BY scientific_name;

SHOW COLUMNS FROM birds;

SHOW COLUMNS FROM birds LIKE '%id';

-- The Table for Birds

SHOW DATABASES;

USE rookery;

DESCRIBE birds;

ALTER TABLE birds
CHANGE COLUMN conservation_status_id  conservation_status_id INT DEFAULT 0;

INSERT INTO birds
(common_name, scientific_name, family_id)
VALUES('Mountain Plover', 'Charadrius montanus', 103);

INSERT INTO birds
(common_name, scientific_name, family_id)
VALUES('Snowy Plover', 'Charadrius alexandrinus', 103),
('Black-bellied Plover', 'Pluvialis squatarola', 103),
('Pacific Golden Plover', 'Pluvialis fulva', 103);

SELECT common_name AS 'Bird',
birds.scientific_name AS 'Scientific Name',
bird_families.scientific_name AS 'Family',
bird_orders.scientific_name AS 'Order'
FROM birds,
bird_families,
bird_orders
WHERE birds.family_id = bird_families.family_id
AND bird_families.order_id = bird_orders.order_id;

-- Other possibilities
--Inserting Emphatically

INSERT INTO bird_families
SET scientific_name = 'Rallidae',
order_id = 113;

-- Inserting Data from Another Table

--Crearemos la tabla a partir de la descripción
CREATE TABLE cornell_birds_families_orders (
  fid int(11) NOT NULL AUTO_INCREMENT,
  bird_family varchar(255) COLLATE latin1_bin DEFAULT NULL,
  examples varchar(255) COLLATE latin1_bin DEFAULT NULL,
  bird_order varchar(255) COLLATE latin1_bin DEFAULT NULL,
  PRIMARY KEY (fid)
) ENGINE=MyISAM AUTO_INCREMENT=33364 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--A partir del enlace
--https://resources.oreilly.com/examples/0636920029175/raw/master/Archive/cornell_birds_families_orders.sql
--se puede obtener toda la información

DESCRIBE cornell_birds_families_orders;

SELECT * FROM cornell_birds_families_orders
LIMIT 1;

ALTER TABLE bird_families
ADD COLUMN cornell_bird_order VARCHAR(255);

INSERT IGNORE INTO bird_families
(scientific_name, brief_description, cornell_bird_order)
SELECT bird_family, examples, bird_order
FROM cornell_birds_families_orders;

SELECT * FROM bird_families
ORDER BY family_id DESC LIMIT 1;

--A Digression: Setting the Right ID

SELECT DISTINCT bird_orders.order_id,
cornell_bird_order AS "Cornell's Order",
bird_orders.scientific_name AS 'My Order'
FROM bird_families, bird_orders
WHERE bird_families.order_id IS NULL
AND cornell_bird_order = bird_orders.scientific_name
LIMIT 5;

UPDATE bird_families, bird_orders
SET bird_families.order_id = bird_orders.order_id
WHERE bird_families.order_id IS NULL
AND cornell_bird_order = bird_orders.scientific_name;

SELECT * FROM bird_families
ORDER BY family_id DESC LIMIT 4;

SELECT * FROM bird_orders
WHERE order_id = 128;

SELECT family_id, scientific_name, brief_description
FROM bird_families
WHERE order_id IS NULL;

UPDATE bird_families
SET order_id = 112
WHERE cornell_bird_order = 'Accipitriformes';

ALTER TABLE bird_families
DROP COLUMN cornell_bird_order;

DROP TABLE cornell_birds_families_orders;

-- Replacing Data

REPLACE INTO bird_families
(scientific_name, brief_description, order_id)
VALUES('Viduidae', 'Indigobirds & Whydahs', 128),
('Estrildidae', 'Waxbills, Weaver Finches, & Allies', 128),
('Ploceidae', 'Weavers, Malimbe, & Bishops', 128);

SELECT * FROM bird_families
WHERE scientific_name = 'Viduidae';
