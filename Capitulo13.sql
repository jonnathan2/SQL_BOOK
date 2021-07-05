----Capitulo 13. User Accounts and Privileges

--User Account Basics

CREATE USER 'lena_stankoska';

SHOW GRANTS FOR 'lena_stankoska';

GRANT ALL ON rookery.*
TO 'lena_stankoska'@'localhost';

SHOW GRANTS FOR 'lena_stankoska'@'localhost';

SELECT User, Host
FROM mysql.user
WHERE User LIKE 'lena_stankoska';

DROP USER 'lena_stankoska'@'localhost';
DROP USER 'lena_stankoska'@'%';

-- Restricting the Access of User Accounts
--Username and Host

CREATE USER 'lena_stankoska'@'localhost'
IDENTIFIED BY 'her_password_123';

GRANT USAGE ON *.* TO 'lena_stankoska'@'lena_stankoska_home'
IDENTIFIED BY 'her_password_123';

SHOW GRANTS FOR 'lena_stankoska'@'localhost';

SELECT PASSWORD('her_password_123');

--SQL Privileges
GRANT SELECT, INSERT, UPDATE ON rookery.*
TO 'lena_stankoska'@'localhost';

GRANT SELECT, INSERT, UPDATE ON birdwatchers.*
TO 'lena_stankoska'@'localhost';

SHOW GRANTS FOR 'lena_stankoska'@localhost;

GRANT DELETE ON rookery.*
TO 'lena_stankoska'@'localhost';

GRANT DELETE ON birdwatchers.*
TO 'lena_stankoska'@'localhost';

SHOW GRANTS FOR 'lena_stankoska'@localhost;

--Database Components and Privileges
GRANT USAGE ON rookery.*
TO 'lena_stankoska'@'lena_stankoska_home'
IDENTIFIED BY 'her_password_123';

SHOW GRANTS FOR 'lena_stankoska'@'lena_stankoska_home';

GRANT SELECT ON rookery.*
TO 'lena_stankoska'@'lena_stankoska_home';

SHOW GRANTS FOR 'lena_stankoska'@'lena_stankoska_home';

GRANT SELECT ON birdwatchers.bird_sightings
TO 'lena_stankoska'@'lena_stankoska_home';

SHOW GRANTS FOR 'lena_stankoska'@'lena_stankoska_home';

GRANT SELECT (human_id, formal_title, name_first,
name_last, membership_type)
ON birdwatchers.humans
TO 'lena_stankoska'@'lena_stankoska_home';

--Administrative User Accounts
--User Account for Making Backups

CREATE USER 'admin_backup'@'localhost'
IDENTIFIED BY 'its_password_123';

GRANT SELECT, LOCK TABLES
ON rookery.*

TO 'admin_backup'@'localhost';
GRANT SELECT, LOCK TABLES
ON birdwatchers.*
TO 'admin_backup'@'localhost';

--User Account for Restoring Backups
CREATE USER 'admin_restore'@'localhost'
IDENTIFIED BY 'different_pwd_456';

GRANT INSERT, LOCK TABLES, CREATE,
CREATE TEMPORARY TABLES, INDEX, ALTER
ON rookery.*
TO 'admin_restore'@'localhost';

GRANT INSERT, LOCK TABLES, CREATE,
CREATE TEMPORARY TABLES, INDEX, ALTER
ON birdwatchers.*
TO 'admin_restore'@'localhost';

--User Account for Bulk Importing
CREATE USER 'admin_import'@'localhost'
IDENTIFIED BY 'another_pwd_789';

GRANT FILE ON *.*
TO 'admin_import'@'localhost';

--User Account to Grant Privileges
GRANT ALL PRIVILEGES ON rookery.*
TO 'admin_granter'@'localhost'
IDENTIFIED BY 'avocet_123'
WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON birdwatchers.*
TO 'admin_granter'@'localhost'
IDENTIFIED BY 'avocet_123'
WITH GRANT OPTION;

GRANT CREATE USER ON *.*
TO 'admin_granter'@'localhost';

GRANT SELECT ON mysql.*
TO 'admin_granter'@'localhost';

SELECT CURRENT_USER() AS 'User Account';

CREATE USER 'bird_tester'@'localhost';

GRANT SELECT ON birdwatchers.*
TO 'bird_tester'@'localhost';

SHOW GRANTS FOR 'bird_tester'@'localhost';

DROP USER 'bird_tester'@'localhost';

--Revoking Privileges
REVOKE ALL PRIVILEGES
ON rookery.*
FROM 'michael_stone'@'localhost';

REVOKE ALL PRIVILEGES
ON birdwatchers.*
FROM 'michael_stone'@'localhost';

REVOKE ALTER
ON rookery.*
FROM 'admin_restore'@'localhost';

REVOKE ALTER
ON birdwatchers.*
FROM 'admin_restore'@'localhost';

--Deleting a User Account
DROP USER 'michael_stone'@'localhost';

SELECT User, Host
FROM mysql.user
WHERE User LIKE '%michael%'
OR User LIKE '%stone%';

DROP USER 'mstone'@'mstone_home';

SHOW PROCESSLIST;

KILL 11482;

--Changing Passwords and Names
--Setting a User Account Password

ALTER USER 'admin_granter'@'localhost' PASSWORD EXPIRE;

SET PASSWORD FOR 'admin_granter'@'localhost' = PASSWORD('some_pwd_123');

SET PASSWORD FOR 'admin_granter'@'localhost' =
'*D47F09D44BA0456F55A2F14DBD22C04821BCC07B';

--Renaming a user account
RENAME USER 'lena_stankoska'@'lena_stankoska_home'
TO 'lena'@'stankoskahouse.com';

SHOW GRANTS FOR 'lena'@'stankoskahouse.com';
