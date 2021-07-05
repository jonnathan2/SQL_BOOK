----Capitulo 15. Bulk Importing Data

--Preparing to Import
CREATE TABLE rookery.clements_list_import
(id INT, change_type VARCHAR(255),
col2 CHAR(0), col3 CHAR(0),
scientific_name VARCHAR(255),
english_name VARCHAR(255),
col6 CHAR(0), `order` VARCHAR(255),
family VARCHAR(255),
col9 CHAR(0), col10 CHAR(0),
col11 CHAR(0), col12 CHAR(0),
col13 CHAR(0), col14 CHAR(0),
col15 CHAR(0), col16 CHAR(0), col17 CHAR(0));

--Loading Data Basics

--Watching for Warnings

SHOW WARNINGS;

SELECT * FROM rookery.clements_list_import LIMIT 2;

--Checking the Accuracy of the Import

SELECT id, change_type,
scientific_name, english_name,
`order`, family
FROM rookery.clements_list_import
WHERE change_type = 'new species' LIMIT 2;

--Selecting Imported Data

USE `rookery`;

CREATE TABLE rookery.birds_new
LIKE rookery.birds;

INSERT INTO birds_new
(scientific_name, common_name, family_id)
SELECT clements.scientific_name, english_name, bird_families.family_id
FROM clements_list_import AS clements
JOIN bird_families
ON bird_families.scientific_name =
SUBSTRING(family, 1, LOCATE(' (', family) )
WHERE change_type = 'new species';

SELECT birds_new.scientific_name,
common_name, family_id,
bird_families.scientific_name AS family
FROM birds_new
JOIN bird_families USING(family_id);

--Better loading
--Mapping Fields

DROP TABLE rookery.clements_list_import;
CREATE TABLE rookery.clements_list_import
(id INT, scientific_name VARCHAR(255),
english_name VARCHAR(255), family VARCHAR(255),
bird_order VARCHAR(255), change_type VARCHAR(255));

--Setting columns
-- More Field and Line Definitions
-- Starting, Terminating, and Escaping

CREATE TABLE birdwatchers.birdwatcher_prospects_import
(prospect_id INT AUTO_INCREMENT KEY,
prospect_name VARCHAR(255),
prospect_email VARCHAR(255) UNIQUE,
prospect_country VARCHAR(255));

--Bulk Exporting Data
SELECT birds.scientific_name,
IFNULL(common_name, ''),
bird_families.scientific_name
FROM rookery.birds
JOIN rookery.bird_families USING(family_id)
JOIN rookery.bird_orders USING(order_id)
WHERE bird_orders.scientific_name = 'Charadriiformes'
ORDER BY common_name;

( SELECT 'scientific name','common name','family name' )
UNION
( SELECT birds.scientific_name,
IFNULL(common_name, ''),
bird_families.scientific_name
FROM rookery.birds
JOIN rookery.bird_families USING(family_id)
JOIN rookery.bird_orders USING(order_id)
WHERE bird_orders.scientific_name = 'Charadriiformes'
ORDER BY common_name
INTO OUTFILE '/tmp/birds-list.csv'
FIELDS ENCLOSED BY '"' TERMINATED BY '|' ESCAPED BY '\\'
LINES TERMINATED BY '\n');
