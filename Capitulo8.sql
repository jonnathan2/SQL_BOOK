----Capítulo 8. Updating and Deleting Data

--Updating Data
--Tomar la tabla de humans
DROP TABLE humans;

CREATE TABLE humans (
  human_id int(11) NOT NULL AUTO_INCREMENT,
  formal_title enum('Mr','Ms') DEFAULT NULL,
  name_first varchar(25) DEFAULT NULL,
  name_last varchar(25) DEFAULT NULL,
  email_address varchar(255) DEFAULT NULL,
  country_id char(2) DEFAULT NULL,
  membership_type enum('basic','premium') DEFAULT NULL,
  membership_expiration date DEFAULT NULL,
  better_birders_site tinyint(4) DEFAULT '0',
  possible_duplicate tinyint(4) DEFAULT '0',
  PRIMARY KEY (human_id),
  KEY human_names (name_last,name_first)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

INSERT INTO `humans` VALUES (1,'Mr','Russell','Dyer','russell@mysqlresources.com','us',NULL,NULL,0,0),(2,'Mr','Richard','Stringer','richard@mysqlresources.com','us',NULL,NULL,0,0),(3,'Ms','Rusty','Johnson','rusty@mysqlresources.com','us',NULL,NULL,0,0),(4,'Ms','Lexi','Hollar','alexandra@mysqlresources.com','us',NULL,NULL,0,1),(17,'Mr','Rusell','Dyer','russell@dyerhouse.com','us',NULL,NULL,0,0),(26,'Ms','Katerina','Smirnova','katya@mail.ru','ru',NULL,NULL,0,0),(27,'Ms','Anahit','Vanetsyan','anahit@gmail.com','ru',NULL,NULL,0,0),(28,'Ms','Marie','Dyer','marie@gmail.com','uk',NULL,NULL,0,0),(29,'Mr','Geoffrey','Dyer',NULL,'us',NULL,NULL,0,0),(30,'Ms','MICHAEL','STONE',NULL,NULL,NULL,NULL,0,0),(34,'Ms','Melissa','Lee',NULL,'us',NULL,NULL,0,0),(35,'Mr','andy','oram',NULL,NULL,NULL,NULL,0,0),(36,'Mr','Michael','Zabalaoui',NULL,'us',NULL,NULL,0,0),(40,'Mr','Jack','Bard','jack.bard@mysqlresources.com','uk',NULL,NULL,0,0),(41,'Mr','Oliver','Cromwell','ocrom@mysqlresources.com','uk',NULL,NULL,0,0),(42,'Mr','Sun','Tzu','mastersun@yahoo.com','ch',NULL,NULL,0,0),(43,'Mr','Joe','Samson','sam@mysqlresources.com','au',NULL,NULL,0,0),(44,'Ms','Elizabeth','Stewart','lizstew@yahoo.com','au',NULL,NULL,0,0),(45,'Mr','Barry','Pilson','barry@gomail.com',NULL,NULL,NULL,1,0),(46,'Ms','Lexi','Hollar','alexandra@mysqlresources.com',NULL,NULL,NULL,1,1),(47,'Mr','Ricky','Adams','ricky@gomail.com',NULL,NULL,NULL,1,0);


UPDATE birdwatchers.humans
SET country_id = 'us';
USE birdwatchers;

--Updating Specific Rows
SELECT human_id, name_first, name_last
FROM humans
WHERE name_first = 'Rusty'
AND name_last = 'Osborne';

UPDATE humans
SET name_last = 'Johnson'
WHERE human_id = 3;

SELECT human_id, name_first, name_last
FROM humans
WHERE human_id = 3;

UPDATE humans
SET formal_title = 'Ms.'
WHERE human_id IN(24, 32);

SHOW FULL COLUMNS
FROM humans
LIKE 'formal_title';

UPDATE humans
SET formal_title = 'Ms.'
WHERE formal_title IN('Miss','Mrs.');

ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr.','Ms.');

SHOW WARNINGS;

ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr.','Ms.','Mr','Ms');

UPDATE humans
SET formal_title = SUBSTRING(formal_title, 1, 2);

ALTER TABLE humans
CHANGE COLUMN formal_title formal_title ENUM('Mr','Ms');

-- Limiting Updates

CREATE TABLE prize_winners
(winner_id INT AUTO_INCREMENT PRIMARY KEY,
human_id INT,
winner_date DATE,
prize_chosen VARCHAR(255),
prize_sent DATE);

INSERT INTO prize_winners
(human_id)
SELECT human_id
FROM humans;

-- Ordering to make a difference
UPDATE prize_winners
SET winner_date = CURDATE()
WHERE winner_date IS NULL
ORDER BY RAND()
LIMIT 2;

SHOW WARNINGS;

--Updating multiple tables

UPDATE prize_winners, humans
SET winner_date = NULL,
prize_chosen = NULL,
prize_sent = NULL
WHERE country_id = 'uk'
AND prize_winners.human_id = humans.human_id;

UPDATE prize_winners, humans
SET winner_date = CURDATE()
WHERE winner_date IS NULL
AND country_id = 'uk'
AND prize_winners.human_id = humans.human_id
ORDER BY RAND()
LIMIT 2;

UPDATE prize_winners
SET winner_date = CURDATE()
WHERE winner_date IS NULL
AND human_id IN
(SELECT human_id
FROM humans
WHERE country_id = 'uk'
ORDER BY RAND())
LIMIT 2;

-- Handling Duplicates

ALTER TABLE humans
ADD COLUMN better_birders_site TINYINT DEFAULT 0;

INSERT INTO humans
(formal_title, name_first, name_last, email_address, better_birders_site)
VALUES('Mr','Barry','Pilson', 'barry@gomail.com', 1),
('Ms','Lexi','Hollar', 'alexandra@mysqlresources.com', 1),
('Mr','Ricky','Adams', 'ricky@gomail.com', 1)
ON DUPLICATE KEY
UPDATE better_birders_site = 2;

INSERT INTO prize_winners
(human_id)
SELECT human_id
FROM humans
WHERE better_birders_site = 1;

ALTER TABLE humans
ADD COLUMN possible_duplicate TINYINT DEFAULT 0;

CREATE TEMPORARY TABLE possible_duplicates
(name_1 varchar(25), name_2 varchar(25));

INSERT INTO possible_duplicates
SELECT name_first, name_last
FROM
(SELECT name_first, name_last, COUNT(*) AS nbr_entries
FROM humans
GROUP BY name_first, name_last) AS derived_table
WHERE nbr_entries > 1;

UPDATE humans, possible_duplicates
SET possible_duplicate = 1
WHERE name_first = name_1
AND name_last = name_2;

--Deleting Data

DELETE FROM humans
WHERE name_first = 'Elena'
AND name_last = 'Bokova'
AND email_address LIKE '%yahoo.com';

--Deleting in Multiple Tables

DELETE FROM humans, prize_winners
USING humans JOIN prize_winners
WHERE name_first = 'Elena'
AND name_last = 'Bokova'
AND email_address LIKE '%yahoo.com'
AND humans.human_id = prize_winners.human_id;
