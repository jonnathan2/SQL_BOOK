----Capítulo 9. Joining and Subquerying Data

--Unifying Results

USE `rookery`;

SELECT 'Pelecanidae' AS 'Family',
    COUNT(*) AS 'Species'
    FROM birds, bird_families AS families
    WHERE birds.family_id = families.family_id
    AND families.scientific_name = 'Pelecanidae'
UNION
    SELECT 'Ardeidae',
        COUNT(*)
        FROM birds, bird_families AS families
        WHERE birds.family_id = families.family_id
        AND families.scientific_name = 'Ardeidae';

SELECT families.scientific_name AS 'Family',
COUNT(*) AS 'Species'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Pelecaniformes'
GROUP BY families.family_id
UNION
SELECT families.scientific_name, COUNT(*)
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Suliformes'
GROUP BY families.family_id;

SELECT * FROM
(
SELECT families.scientific_name AS 'Family',
COUNT(*) AS 'Species',
orders.scientific_name AS 'Order'
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Pelecaniformes'
GROUP BY families.family_id
UNION
SELECT families.scientific_name, COUNT(*), orders.scientific_name
FROM birds, bird_families AS families, bird_orders AS orders
WHERE birds.family_id = families.family_id
AND families.order_id = orders.order_id
AND orders.scientific_name = 'Suliformes'
GROUP BY families.family_id ) AS derived_1
ORDER BY Family;


--Joining tables
SHOW DATABASES;

USE test;

SELECT book_id, title, status_name
FROM books JOIN status_names
WHERE status = status_id;

SELECT book_id, title, status_name
FROM books
JOIN status_names ON(status = status_id);

SELECT book_id, title, status_name
FROM books
JOIN status_names USING(status_id);

--Selecting a basic join
USE rookery;

SELECT common_name, conservation_state
FROM birds
JOIN conservation_status
ON(birds.conservation_status_id = conservation_status.conservation_status_id)
WHERE conservation_category = 'Threatened'
AND common_name LIKE '%Goose%';

SELECT common_name, conservation_state
FROM birds
JOIN conservation_status
USING(conservation_status_id)
WHERE conservation_category = 'Threatened'
AND common_name LIKE '%Goose%';

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family', conservation_state AS 'Status'
FROM birds
JOIN conservation_status USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE conservation_category = 'Threatened'
AND common_name REGEXP 'Goose|Duck'
ORDER BY Status, Bird;

SELECT common_name AS 'Bird',
bird_families.scientific_name AS 'Family', conservation_state AS 'Status'
FROM birds, conservation_status, bird_families
WHERE birds.conservation_status_id = conservation_status.conservation_status_id
AND birds.family_id = bird_families.family_id
AND conservation_category = 'Threatened'
AND common_name REGEXP 'Goose|Duck'
ORDER BY Status, Bird;

SELECT common_name AS 'Bird from Anatidae',
conservation_state AS 'Conservation Status'
FROM birds
JOIN conservation_status AS states USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE conservation_category = 'Threatened'
AND bird_families.scientific_name = 'Anatidae'
ORDER BY states.conservation_status_id DESC, common_name ASC;

SELECT CONCAT(name_first, ' ', name_last) AS Birder,
common_name AS Bird, location_gps AS 'Location of Sighting'
FROM birdwatchers.humans
JOIN birdwatchers.bird_sightings USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.bird_families USING(family_id)
WHERE country_id = 'ru'
AND bird_families.scientific_name = 'Scolopacidae'
ORDER BY Birder;

SELECT common_name AS 'Bird',
conservation_state AS 'Status'
FROM birds
LEFT JOIN conservation_status USING(conservation_status_id)
WHERE common_name LIKE '%Egret%'
ORDER BY Status, Bird;

--Updating joined tables
SELECT common_name,
conservation_state
FROM birds
LEFT JOIN conservation_status USING(conservation_status_id)
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Ardeidae';

INSERT INTO conservation_status (conservation_state)
VALUES('Unknown');

SELECT LAST_INSERT_ID();

UPDATE birds
LEFT JOIN conservation_status USING(conservation_status_id)
JOIN bird_families USING(family_id)
SET birds.conservation_status_id = 9
WHERE bird_families.scientific_name = 'Ardeidae'
AND conservation_status.conservation_status_id IS NULL;

-- Deleting within joined tables
USE `birdwatchers`;

DELETE FROM humans, prize_winners
USING humans JOIN prize_winners
WHERE name_first = 'Elena'
AND name_last = 'Bokova'
AND email_address LIKE '%yahoo.com'
AND humans.human_id = prize_winners.human_id;

DELETE FROM humans, prize_winners
USING humans LEFT JOIN prize_winners
ON humans.human_id = prize_winners.human_id
WHERE name_first = 'Elena'
AND name_last = 'Bokova'
AND email_address LIKE '%yahoo.com';

DELETE FROM prize_winners
USING humans RIGHT JOIN prize_winners
ON humans.human_id = prize_winners.human_id
WHERE humans.human_id IS NULL;

--Subqueries
UPDATE table_1
SET col_5 = 1
WHERE col_id =
SELECT col_id
FROM table_2
WHERE col_1 = value;

SELECT column_a, column_1
FROM table_1
JOIN
(SELECT column_1, column_2
FROM table_2
WHERE column_2 = value) AS derived_table
USING(col_id);

--Scalar Subqueries

USE `rookery`;

SELECT scientific_name AS Family
FROM bird_families
WHERE order_id =
(SELECT order_id
FROM bird_orders
WHERE scientific_name = 'Galliformes');

USE `rookery`;

UPDATE humans
SET membership_type = 'premium',
membership_expiration = DATE_ADD(IFNULL(membership_expiration,
CURDATE()), INTERVAL 1 YEAR)
WHERE human_id =
(SELECT human_id
FROM
(SELECT human_id, COUNT(*) AS sightings, join_date
FROM birdwatchers.bird_sightings
JOIN birdwatchers.humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.bird_families USING(family_id)
WHERE country_id = 'ru'
AND bird_families.scientific_name = 'Scolopacidae'
GROUP BY human_id) AS derived_1
WHERE sightings > 5
ORDER BY join_date ASC
LIMIT 1);

--Column Subqueries
SELECT * FROM
(SELECT common_name AS 'Bird',
families.scientific_name AS 'Family'
FROM birds
JOIN bird_families AS families USING(family_id)
JOIN bird_orders AS orders USING(order_id)
WHERE common_name != ''
AND families.scientific_name IN
(SELECT DISTINCT families.scientific_name AS 'Family'
FROM bird_families AS families
JOIN bird_orders AS orders USING(order_id)
 WHERE orders.scientific_name = 'Galliformes'
ORDER BY Family)
ORDER BY RAND()) AS derived_1
GROUP BY (Family);

--Row Subqueries
INSERT INTO bird_sightings
(bird_id, human_id, time_seen, location_gps)
VALUES
(SELECT birds.bird_id, humans.human_id,
date_spotted, gps_coordinates
FROM
(SELECT personal_name, family_name, science_name, date_spotted,
CONCAT(latitude, '; ', longitude) AS gps_coordinates
FROM eastern_birders
JOIN eastern_birders_spottings USING(birder_id)
WHERE
(personal_name, family_name,
science_name, CONCAT(latitude, '; ', longitude) )
NOT IN
(SELECT name_first, name_last, scientific_name, location_gps
FROM humans
JOIN bird_sightings USING(human_id)
JOIN rookery.birds USING(bird_id) ) ) AS derived_1
JOIN humans
ON(personal_name = name_first
AND family_name = name_last)
JOIN rookery.birds
ON(scientific_name = science_name) );

--Table Subqueries
SELECT family AS 'Bird Family',
COUNT(*) AS 'Number of Birds'
FROM
(SELECT families.scientific_name AS family
FROM birds
JOIN bird_families AS families USING(family_id)
WHERE families.scientific_name IN('Pelecanidae','Ardeidae')) AS derived_1
GROUP BY family;
