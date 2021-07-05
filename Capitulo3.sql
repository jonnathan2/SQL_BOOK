---- Capítulo 3. The Basics and the mysql Client

--Starting to Explore Databases

SHOW DATABASES;

--  First SQL Commands

CREATE DATABASE test;
SHOW DATABASES;

CREATE TABLE test.books (book_id INT, title TEXT, status INT);
SHOW TABLES FROM test;

USE test;

SHOW TABLES;

DESCRIBE books;

-- Inserting and Manipulating Data

INSERT INTO books VALUES(100,'Heart of Darkness',0);
INSERT INTO books VALUES(101,'The Catcher of the Rye',1);
INSERT INTO books VALUES(102,'My Antonia',0);

SELECT * FROM books;
SELECT * FROM books WHERE status=1;
SELECT * FROM books WHERE status=0;

UPDATE books SET status=1 WHERE book_id=102; --Cambios en la información de las filas
SELECT * FROM books WHERE status=1;
UPDATE books SET status=0 WHERE book_id=101;
SELECT * FROM books WHERE status=0;

UPDATE books
SET title = 'The Catcher in the Rye', status=1
WHERE book_id=101; --Otra forma de hacerlo

SELECT * FROM books;

-- A little Complexity

CREATE TABLE status_names (status_id INT, status_name CHAR(8));
INSERT INTO status_names VALUES(0,'Inactive'),(1,'Active');
SELECT * FROM status_names;

SELECT book_id,title,status_name
FROM books JOIN status_names
WHERE status=status_id; -- Unir o combinar las dos tablas
