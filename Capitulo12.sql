----Capitulo 12. Aggregate and Numeric Functions

--Aggregate functions
--Counting Values
USE `rookery`;

SELECT COUNT(*)
FROM birds;

UPDATE birds
SET common_name = NULL
WHERE common_name = '';
SELECT COUNT(common_name)
FROM birds;

SELECT COUNT(*) FROM birds
WHERE common_name IS NULL;

SELECT COUNT(*) FROM birds
WHERE common_name IS NOT NULL;

SELECT COUNT(*)
FROM birds
GROUP BY family_id;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds JOIN bird_families USING(family_id)
GROUP BY birds.family_id;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY birds.family_id;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds LEFT JOIN bird_families USING(family_id)
GROUP BY bird_families.scientific_name;

SELECT bird_families.scientific_name AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds JOIN bird_families USING(family_id)
GROUP BY bird_families.scientific_name WITH ROLLUP;

SELECT IFNULL( bird_orders.scientific_name, '') AS 'Bird Order',
IFNULL( bird_families.scientific_name, 'Total:') AS 'Bird Family',
COUNT(*) AS 'Number of Species'
FROM birds
JOIN bird_families USING(family_id)
JOIN bird_orders USING(order_id)
GROUP BY bird_orders.scientific_name, bird_families.scientific_name
WITH ROLLUP;

--Calculating a Group of Values
USE `birdwatchers`;

SELECT common_name AS 'Bird',
TIME_TO_SEC( TIMEDIFF(id_end, id_start) )
AS 'Seconds to Identify'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE name_first = 'Ricky' AND name_last = 'Adams';

SELECT CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
SUM(TIME_TO_SEC( TIMEDIFF(id_end, id_start) ) )
AS 'Total Seconds for Identifications'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE name_first = 'Ricky' AND name_last = 'Adams';

SELECT Identifications, Seconds,
(Seconds / Identifications) AS 'Avg. Seconds/Identification'
FROM
( SELECT human_id, COUNT(*) AS 'Identifications'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE name_first = 'Ricky' AND name_last = 'Adams')
AS row_count
JOIN
( SELECT human_id, CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
SUM(TIME_TO_SEC(TIMEDIFF(id_end, id_start)))
AS 'Seconds'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id) )
AS second_count
USING(human_id);

SELECT CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
AVG( TIME_TO_SEC( TIMEDIFF(id_end, id_start)) )
AS 'Avg. Seconds per Identification'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE name_first = 'Ricky' AND name_last = 'Adams';

SELECT CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
COUNT(*) AS 'Birds',
TIME_FORMAT(
SEC_TO_TIME(AVG( TIME_TO_SEC( TIMEDIFF(id_end, id_start)))),
'%i:%s' )
AS 'Avg. Time'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
GROUP BY human_id LIMIT 3;

SELECT Birdwatcher, avg_time AS 'Avg. Time'
FROM
(SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
COUNT(*) AS 'Birds',
TIME_FORMAT( SEC_TO_TIME( AVG(
TIME_TO_SEC( TIMEDIFF(id_end, id_start)))
),'%i:%s' ) AS 'avg_time'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
GROUP BY human_id) AS average_times
ORDER BY avg_time;

SELECT MIN(avg_time) AS 'Minimum Avg. Time',
MAX(avg_time) AS 'Maximum Avg. Time'
FROM humans
JOIN
(SELECT human_id, COUNT(*) AS 'Birds',
TIME_FORMAT(
SEC_TO_TIME( AVG(
TIME_TO_SEC( TIMEDIFF(id_end, id_start)))
), '%i:%s' ) AS 'avg_time'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
GROUP BY human_id ) AS average_times;

SELECT CONCAT(name_first, SPACE(1), name_last) AS 'Birdwatcher',
TIME_FORMAT(SEC_TO_TIME(
MIN(TIME_TO_SEC( TIMEDIFF(id_end, id_start)))
),%i:%s ) AS 'Minimum Time',
TIME_FORMAT(SEC_TO_TIME(
MAX(TIME_TO_SEC( TIMEDIFF(id_end, id_start)))
), '%i:%s' ) AS 'Maximum Time'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
GROUP BY Birdwatcher;

SELECT common_name AS 'Bird',
MAX(SUBSTRING(location_gps, 1, 11)) AS 'Furthest North',
MIN(SUBSTRING(location_gps, 1, 11)) AS 'Furthest South'
FROM birdwatchers.bird_sightings
JOIN rookery.birds USING(bird_id)
WHERE location_gps IS NOT NULL
GROUP BY bird_id LIMIT 3;

--Concatenating a group

SELECT bird_orders.scientific_name AS 'Bird Order',
GROUP_CONCAT(bird_families.scientific_name)
AS 'Bird Families in Order'
FROM rookery.bird_families
JOIN rookery.bird_orders USING(order_id)
WHERE bird_orders.scientific_name = 'Charadriiformes'
GROUP BY order_id;

SELECT bird_orders.scientific_name AS 'Bird Order',
GROUP_CONCAT(bird_families.scientific_name SEPARATOR ', ')
AS 'Bird Families in Order'
FROM rookery.bird_families
JOIN rookery.bird_orders USING(order_id)
GROUP BY order_id;

--Numeric Functions

--Rounding Numbers

SELECT IFNULL(COLUMN_GET(choices, answer AS CHAR), 'total')
AS 'Birding Site', COUNT(*) AS 'Votes'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer WITH ROLLUP;

SET @fav_site_total =
(SELECT COUNT(*)
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1);

SELECT @fav_site_total;

SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
(COUNT(*) / @fav_site_total) AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
CONCAT( ROUND( (COUNT(*) / @fav_site_total) * 100), '%')
AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
CONCAT( ROUND( (COUNT(*) / @fav_site_total) * 100, 1), '%') AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

-- Rounding Only Down or Up

SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
CONCAT( FLOOR( (COUNT(*) / @fav_site_total) * 100), '%')
AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
CONCAT( CEILING( (COUNT(*) / @fav_site_total) * 100), '%') AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

-- Truncating numbers
SELECT COLUMN_GET(choices, answer AS CHAR)
AS 'Birding Site',
COUNT(*) AS 'Votes',
CONCAT( TRUNCATE( (COUNT(*) / @fav_site_total) * 100, 1), '%')
AS 'Percent'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer;

--Eliminating Negative Numbers
SELECT
SUM( TIME_TO_SEC( TIMEDIFF(id_start, id_end) ) )
AS 'Total Seconds for All',
ABS( SUM( TIME_TO_SEC( TIMEDIFF(id_start, id_end) ) ) )
AS 'Absolute Total'
FROM bird_identification_tests;

SET @min_avg_time =
(SELECT MIN(avg_time) FROM
(SELECT AVG( TIME_TO_SEC( TIMEDIFF(id_end, id_start)))
AS 'avg_time'
FROM bird_identification_tests
GROUP BY human_id) AS average_times);

SELECT @min_avg_time;

SELECT CONCAT(name_first, SPACE(1), name_last)
AS 'Birdwatcher',
common_name AS 'Bird',
ROUND(@min_avg_time - TIME_TO_SEC( TIMEDIFF(id_end, id_start) ) )
AS 'Seconds Less than Average'
FROM bird_identification_tests
JOIN humans USING(human_id)
JOIN rookery.birds USING(bird_id)
WHERE SIGN( TIME_TO_SEC( TIMEDIFF(id_end, id_start) - @min_avg_time)) = -1;
