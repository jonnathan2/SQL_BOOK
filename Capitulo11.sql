----Capítulo 11. Date and Time Functions

--Date and Time Data Types
--Current Date and Time
SELECT NOW( );

INSERT INTO bird_sightings
(bird_id, human_id, time_seen, location_gps)
VALUES (104, 34, NOW( ), '47.318875; 8.580119');

SELECT NOW(), SLEEP(4) AS 'Zzz', SYSDATE(), SLEEP(2) AS 'Zzz', SYSDATE();4

SELECT NOW( ), CURDATE( ), CURTIME( );

SELECT UNIX_TIMESTAMP( ), NOW( );

SELECT (2014 - 1970) AS 'Simple',
UNIX_TIMESTAMP( ) AS 'Seconds since Epoch',
ROUND(UNIX_TIMESTAMP( ) / 60 / 60 / 24 / 365.25) AS 'Complicated';

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
ROUND((UNIX_TIMESTAMP( ) - UNIX_TIMESTAMP(time_seen)) / 60 / 60 / 24)
AS 'Days Since Spotted'
FROM bird_sightings JOIN humans USING(human_id)
WHERE bird_id = 309;

-- Extracting Date and Time Components
SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, DATE(time_seen), TIME(time_seen)
FROM bird_sightings
JOIN humans USING(human_id);
WHERE bird_id = 309;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, HOUR(time_seen), MINUTE(time_seen), SECOND(time_seen)
FROM bird_sightings JOIN humans USING(human_id)
WHERE bird_id = 309;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
time_seen, YEAR(time_seen), MONTH(time_seen), DAY(time_seen),
MONTHNAME(time_seen), DAYNAME(time_seen)
FROM bird_sightings JOIN humans USING(human_id)
WHERE bird_id = 309;

SELECT common_name AS 'Endangered Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
CONCAT(DAYNAME(time_seen), ', ', MONTHNAME(time_seen), SPACE(1),
DAY(time_seen), ', ', YEAR(time_seen)) AS 'Date Spotted',
CONCAT(HOUR(time_seen), ':', MINUTE(time_seen),
IF(HOUR(time_seen) < 12, ' a.m.', ' p.m.')) AS 'Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id)
WHERE conservation_category = 'Threatened' LIMIT 3;

SELECT time_seen,
EXTRACT(YEAR_MONTH FROM time_seen) AS 'Year & Month',
EXTRACT(MONTH FROM time_seen) AS 'Month Only',
EXTRACT(HOUR_MINUTE FROM time_seen) AS 'Hour & Minute',
EXTRACT(HOUR FROM time_seen) AS 'Hour Only'
FROM bird_sightings JOIN humans USING(human_id)
LIMIT 3;

--Formatting Dates and Time
SELECT common_name AS 'Endangered Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
DATE_FORMAT(time_seen, '%W, %M %e, %Y') AS 'Date Spotted',
TIME_FORMAT(time_seen, '%l:%i %p') AS 'Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id)
WHERE conservation_category = 'Threatened' LIMIT 3;

--Adjusting to Standards and Time Zones
SELECT GET_FORMAT(DATE, 'USA');

SELECT GET_FORMAT(DATE, 'USA'), GET_FORMAT(TIME, 'USA');

SELECT DATE_FORMAT(CURDATE(), GET_FORMAT(DATE,'EUR'))
AS 'Date in Europe',
DATE_FORMAT(CURDATE(), GET_FORMAT(DATE,'USA'))
AS 'Date in U.S.',
REPLACE(DATE_FORMAT(CURDATE(), GET_FORMAT(DATE,'USA')), '.', '-')
AS 'Another Date in U.S.';

SHOW VARIABLES LIKE 'time_zone';

SELECT common_name AS 'Bird',
CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
DATE_FORMAT(time_seen, '%r') AS 'System Time Spotted',
DATE_FORMAT(CONVERT_TZ(time_seen, 'US/Eastern', 'Europe/Rome'), '%r')
AS 'Birder Time Spotted'
FROM bird_sightings
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
JOIN rookery.conservation_status USING(conservation_status_id) LIMIT 3;

--Adding and Subtracting Dates and Time
UPDATE humans
SET membership_expiration = DATE_ADD(membership_expiration, INTERVAL 3 MONTH)
WHERE country_id = 'uk'
AND membership_expiration > CURDATE( );

UPDATE humans
SET membership_expiration = DATE_SUB(membership_expiration, INTERVAL 1 YEAR)
WHERE CONCAT(name_first, SPACE(1), name_last) = 'Melissa Lee';

UPDATE humans
SET membership_expiration = DATE_ADD(membership_expiration, INTERVAL -1 YEAR)
WHERE CONCAT(name_first, SPACE(1), name_last) = 'Melissa Lee';

UPDATE bird_sightings
SET time_seen = DATE_ADD(time_seen, INTERVAL '1 2' DAY_HOUR)
WHERE sighting_id = 16;

SELECT TIME(NOW()),
TIME_TO_SEC(NOW()),
TIME_TO_SEC(NOW()) / 60 /60 AS 'Hours';

CREATE TABLE bird_identification_tests
(test_id INT AUTO_INCREMENT KEY,
human_id INT, bird_id INT,
id_start TIME,
id_end TIME);

INSERT INTO bird_identification_tests
VALUES(NULL, 16, 125, CURTIME(), NULL);

UPDATE bird_identification_tests
SET id_end = CURTIME();

SELECT CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
common_name AS 'Bird',
SEC_TO_TIME( TIME_TO_SEC(id_end) - TIME_TO_SEC(id_start) )
AS 'Time Elapsed'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id);

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
COUNT(time_seen) AS 'Sightings Recorded'
FROM bird_sightings
JOIN humans USING(human_id)
WHERE QUARTER(time_seen) = (QUARTER(CURDATE()) - 1)
AND YEAR(time_seen) = (YEAR(CURDATE( )) - 1)
GROUP BY human_id LIMIT 5;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
COUNT(time_seen) AS 'Sightings Recorded'
FROM bird_sightings
JOIN humans USING(human_id)
WHERE CONCAT(QUARTER(time_seen), YEAR(time_seen)) =
CONCAT(
QUARTER(
STR_TO_DATE(
PERIOD_ADD( EXTRACT(YEAR_MONTH FROM CURDATE()), -3),
'%Y%m') ),
YEAR(
STR_TO_DATE(
PERIOD_ADD( EXTRACT(YEAR_MONTH FROM CURDATE()), -3),
'%Y%m') ) )
GROUP BY human_id LIMIT 5;

--Comparing Dates and Times
SELECT CURDATE() AS 'Today',
DATE_FORMAT(membership_expiration, '%M %e, %Y')
AS 'Date Membership Expires',
DATEDIFF(membership_expiration, CURDATE())
AS 'Days Until Expiration'
FROM humans
WHERE human_id = 4;

CREATE TABLE birding_events
(event_id INT AUTO_INCREMENT KEY,
event_name VARCHAR(255),
event_description TEXT,
meeting_point VARCHAR(255),
event_date DATE,
start_time TIME);

INSERT INTO birding_events
VALUES (NULL, 'Sandpipers in San Diego',
"Birdwatching Outing in San Diego to look for Sandpipers,
Curlews, Godwits, Snipes and other shore birds.
Birders will walk the beaches and surrounding area in groups of six.
A light lunch will be provided.","Hotel del Coronado, the deck near the entrance to the restaurant.",
'2014-06-15', '09:00:00');

SELECT NOW(), event_date, start_time,
DATEDIFF(event_date, DATE(NOW())) AS 'Days to Event',
TIMEDIFF(start_time, TIME(NOW())) AS 'Time to Start'
FROM birding_events;

SELECT NOW(), event_date, start_time,
CONCAT(
DATEDIFF(event_date, DATE(NOW())), ' Days, ',
DATE_FORMAT(TIMEDIFF(start_time, TIME(NOW())), '%k hours, %i minutes'))
AS 'Time to Event'
FROM birding_events;

ALTER TABLE birding_events
ADD COLUMN event_datetime DATETIME;

UPDATE birding_events
SET event_datetime = CONCAT(event_date,SPACE(1), start_time);

SELECT event_date, start_time, event_datetime
FROM birding_events;

SELECT NOW(), event_datetime,
CONCAT(DATEDIFF(event_datetime, NOW() ), ' Days, ',
TIME_FORMAT( TIMEDIFF( TIME(event_datetime), CURTIME() ),
'%k hours, %i minutes') )
AS 'Time to Event'
FROM birding_events;

ALTER TABLE birding_events
DROP COLUMN event_date,
DROP COLUMN start_time;
