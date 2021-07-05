----Capítulo 16. Application Programming Interfaces

--Creating API User Accounts

CREATE USER 'public_api'@'localhost'
IDENTIFIED BY 'pwd_123';

GRANT SELECT
ON rookery.*
TO 'public_api'@'localhost';

GRANT SELECT
ON birdwatchers.*
TO 'public_api'@'localhost';

CREATE USER 'admin_members'@'localhost'
IDENTIFIED BY 'doc_killdeer_123';

GRANT SELECT, UPDATE, DELETE
ON birdwatchers.*
TO 'admin_members'@'localhost';

--C API
--SQL Injection

SELECT common_name, scientific_name FROM birds
WHERE common_name LIKE '%';
GRANT ALL PRIVILEGES ON *.* TO 'bad_guy'@'%';
'%';

SELECT common_name, scientific_name FROM birds
WHERE common_name LIKE '%\';
GRANT ALL PRIVILEGES ON *.* TO \'bad_guy\'@\'%\';
%';
