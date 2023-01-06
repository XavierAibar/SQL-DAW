CREATE TABLE model
(
cod BIGINT,
description VARCHAR(20),
type CHAR NOT NULL,
patent VARCHAR(16),
CONSTRAINT pk_model PRIMARY KEY (cod)
);
INSERT INTO model (cod, description, type, patent) VALUES (1, 'Seat Córdoba', 'T', 'QA12');
INSERT INTO model (cod, description, type, patent) VALUES (2, 'Seat León', 'T', 'QA12');
INSERT INTO model (cod, description, type, patent) VALUES (3, 'Ford Fiesta', 'T', 'QA12');
INSERT INTO model (cod, description, type) VALUES (4, 'Citroën C1', 'T');
INSERT INTO model (cod, description, type, patent) VALUES (5, 'Citröen C2', 'B', 'QA13');
INSERT INTO model (cod, type, patent) VALUES (6, 'B', 'QA13'); 
INSERT INTO model (cod, description, type, patent) VALUES (7, 'Citröen		C1', 'D', 'QA13');
INSERT INTO model (cod, description, type, patent) VALUES (8, 'Citröen C4', 'D', 'RAA14');
INSERT INTO model (cod, description, type) VALUES (9, 'Renault Clio', 'D');
INSERT INTO model (cod, description, type, patent) VALUES (10, 'Mercedes Clase A', 'D', 'AA14');
INSERT INTO model (cod, description, type, patent) VALUES (11, 'Mercedes Kompressor', 'D', 'AA14');
SELECT * FROM model;
/*Ejercicio 1*/
SELECT cod, description
FROM model;
/*Ejercicio 2*/
SELECT description
FROM model
WHERE type LIKE 'D';
/*Ejercicio 3*/
SELECT cod, description
FROM model
WHERE patent LIKE '%AA%';
/*Ejercicio 4*/
SELECT cod, description
FROM model
WHERE 3 < cod AND cod < 10;
/*Ejercicio 5*/
SELECT cod, description
FROM model
WHERE description LIKE '%Citröen%' 
OR description LIKE '%Ford%';
/*Ejercicio 6*/
SELECT cod, description
FROM model
WHERE type LIKE 'D'
ORDER BY description;
/*Ejercicio 7*/
SELECT cod, description
FROM model
WHERE patent IS NULL;
/*Ejercicio 8*/
SELECT COUNT(*)
FROM model;
/*Ejercicio 9*/
SELECT COUNT(*)
FROM model
WHERE type LIKE 'T';
/*Ejercicio 10*/
SELECT COUNT(*)
FROM model
WHERE patent IS NULL;
/*Ejercicio 11*/
SELECT DISTINCT type
FROM model;
/*Ejercicio 12*/
SELECT cod, description
FROM model
WHERE description
/*Ejercicio 13*/
SELECT cod, description
FROM model
WHERE description LIKE 'Citroën C1';
/*Ejercicio 14*/
SELECT MAX(cod)
FROM model;
