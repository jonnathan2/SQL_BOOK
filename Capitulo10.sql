----Capitulo 10. String Functions

--Formatting Strings
--Concatenating Strings

SELECT CONCAT(formal_title, '. ', name_first, SPACE(1), name_last) AS Birder,
CONCAT(common_name, ' - ', birds.scientific_name) AS Bird,
time_seen AS 'When Spotted'
FROM birdwatchers.bird_sightings
JOIN birdwatchers.humans USING(human_id)
JOIN rookery.birds USING(bird_id)
GROUP BY human_id DESC
LIMIT 4;

--Setting Case and Quotes
SELECT LCASE(common_name) AS Species,
UCASE(bird_families.scientific_name) AS Family
FROM birds
JOIN bird_families USING(family_id)
WHERE common_name LIKE '%Wren%'
ORDER BY Species
LIMIT 5;

SELECT QUOTE(common_name)
FROM birds
WHERE common_name LIKE "%Prince%"
ORDER BY common_name;

--Trimming and Padding Strings
USE `birdwatchers`;

UPDATE humans
SET name_first = LTRIM(name_first),
name_last = LTRIM(name_last);

UPDATE humans
SET name_first = RTRIM(name_first),
name_last = RTRIM(name_last);

UPDATE humans
SET name_first = LTRIM( RTRIM(name_last) ),
name_last = LTRIM( RTRIM(name_last) );

UPDATE humans
SET name_first = TRIM(name_first),
name_last = TRIM(name_last);

USE `rookery`;

SELECT CONCAT(RPAD(common_name, 20, '.' ),
RPAD(Families.scientific_name, 15, '.'),
Orders.scientific_name) AS Birds
FROM birds
JOIN bird_families AS Families USING(family_id)
JOIN bird_orders AS Orders
WHERE common_name != ''
AND Orders.scientific_name = 'Ciconiiformes'
ORDER BY common_name LIMIT 3;

--Extracting text
SELECT prospect_name
FROM prospects LIMIT 4;

SELECT LEFT(prospect_name, 2) AS title,
MID(prospect_name, 5, 25) AS first_name,
RIGHT(prospect_name, 25) AS last_name
FROM prospects LIMIT 4;

SELECT SUBSTRING(prospect_name, 1, 2) AS title,
SUBSTRING(prospect_name FROM 5 FOR 25) AS first_name,
SUBSTRING(prospect_name, -25) AS last_name
FROM prospects LIMIT 3;

SELECT SUBSTRING_INDEX(prospect_name, '|', 1) AS title,
SUBSTRING_INDEX( SUBSTRING_INDEX(prospect_name, '|', 2), '|', -1) AS first_name,
SUBSTRING_INDEX(prospect_name, '|', -1) AS last_name
FROM prospects WHERE prospect_id = 7;

--Searching Strings and Using Lengths
--Locating Text Within a String

SELECT common_name AS 'Avocet'
FROM birds
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Recurvirostridae'
AND birds.common_name LIKE '%Avocet%';

SELECT
SUBSTRING(common_name, 1, LOCATE(' Avocet', common_name) ) AS 'Avocet'
FROM birds
JOIN bird_families USING(family_id)
WHERE bird_families.scientific_name = 'Recurvirostridae'
AND birds.common_name LIKE '%Avocet%';

USE `birdwatchers`;

SELECT human_id,
CONCAT(name_first, SPACE(1), name_last) AS Name, join_date
FROM humans
WHERE country_id = 'ru'
ORDER BY join_date;

SELECT FIND_IN_SET('Anahit Vanetsyan', Names) AS Position
FROM
(SELECT GROUP_CONCAT(Name ORDER BY join_date) AS Names
FROM
( SELECT CONCAT(name_first, SPACE(1), name_last) AS Name,
join_date
FROM humans
WHERE country_id = 'ru')
AS derived_1 )
AS derived_2;

--String Lengths
SELECT IF(CHAR_LENGTH(comments) > 100), 'long', 'short')
FROM bird_sightings
WHERE sighting_id = 2;

SELECT sighting_id
FROM bird_sightings
WHERE CHARACTER_LENGTH(comments) != LENGTH(comments);

--Comparing and Searching Strings
CREATE TABLE possible_duplicate_email
(human_id INT,
email_address1 VARCHAR(255),
email_address2 VARCHAR(255),
entry_date datetime );

INSERT IGNORE INTO possible_duplicate_email
(human_id, email_address_1, email_address_2, entry_date)
VALUES(LAST_INSERT_ID(), 'bobyfischer@mymail.com', 'bobbyfischer@mymail.com')
WHERE ABS( STRCMP('bobbyrobin@mymail.com', 'bobyrobin@mymail.com') ) = 1 ;

CREATE FULLTEXT INDEX comment_index
ON bird_sightings (comments);

-- Replacing and Inserting into Strings

USE `rookery`;

SELECT INSERT(common_name, 6, 0, ' (i.e., Smallest)')
AS 'Smallest Birds'
FROM birds
WHERE common_name LIKE 'Least %' LIMIT 1;

SELECT common_name AS Original,
INSERT(common_name, LOCATE('Gt.', common_name), 3, 'Great') AS Adjusted
FROM birds
WHERE common_name REGEXP 'Gt.' LIMIT 1;

UPDATE birds
SET common_name = INSERT(common_name, LOCATE('Gt.', common_name), 3, 'Great')
WHERE common_name REGEXP 'Gt.';

SELECT common_name AS Original,
REPLACE(common_name, 'Gt.', 'Great') AS Replaced
FROM birds
WHERE common_name REGEXP 'Gt.' LIMIT 1;

UPDATE birds
SET common_name = REPLACE(common_name, 'Gt.', 'Great');

--Converting string types
SELECT sorting_id, bird_name, bird_image
FROM bird_images
ORDER BY sorting_id
LIMIT 5;

SELECT sorting_id, bird_name, bird_image
FROM bird_images ORDER BY CAST(sorting_id AS INT) LIMIT 5;

SELECT bird_name, gender_age, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY gender_age
LIMIT 5;

SELECT bird_name, gender_age, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY CONVERT(gender_age, CHAR)
LIMIT 5;

SELECT bird_name, gender_age, bird_image
FROM bird_images
WHERE bird_name LIKE '%Plover%'
ORDER BY CONVERT(gender_age USING utf8)
LIMIT 5;

--Compressing Strings
USE `birdwatchers`;

INSERT INTO humans
(formal_title, name_first, name_last, join_date, birding_background)
VALUES('Ms', 'Melissa', 'Lee', CURDATE(), COMPRESS("lengthy background..."));

SELECT UNCOMPRESS(birding_background) AS Background
FROM humans
WHERE name_first = 'Melissa' AND name_last = 'Lee';
