CREATE TABLE cars
(
id BIGINT,
  plate VARCHAR(16),
  year INT,
  color INT,
  CONSTRAINT pk_cars PRIMARY KEY(id)
);
INSERT INTO cars(id, plate, year, color) VALUES(1, 'AA', 1990, 9001);
INSERT INTO cars(id, plate, color) VALUES(3, 'CC', 9001);
INSERT INTO cars(id, plate, year, color) VALUES(2, 'BB', 1990, 5000);
INSERT INTO cars(id, plate, year) VALUES(4, 'DD', 1990);
INSERT INTO cars(id, plate, year, color) VALUES(5, 'EE', 1991, 9001);
INSERT INTO cars(id, year, color) VALUES(6, 1992, 9001);
INSERT INTO cars(id, plate, year, color) VALUES(7, 'FF', 1990, 9001);
INSERT INTO cars(id, year, color) VALUES(8, 1990, 9001);
INSERT INTO cars(id, year) VALUES(9, 1992);
INSERT INTO cars(id, plate, year, color) VALUES(10, 'ANA', 1990, 5000);
INSERT INTO cars(id, plate, color) VALUES(11, 'PEDRO', 5000);
/*Ejercicio 1*/
SELECT id, plate
FROM cars;
/*Ejercicio 2*/
SELECT plate 
FROM cars 
WHERE year >= 1991;
/*Ejercicio 3*/
SELECT plate, color
FROM cars
WHERE year = 1992;
/*Ejercicio 4*/
SELECT plate
FROM cars
WHERE year IS NULL;
/*Ejercicio 5*/
SELECT plate
FROM cars
WHERE year IS NOT NULL;
/*Ejercicio 6*/
SELECT DISTINCT color
FROM cars 
WHERE year = 1990;
/*Ejercicio 7*/
SELECT color
FROM cars
WHERE plate IS NULL;
/*Ejercicio 8*/
SELECT DISTINCT color
FROM cars
WHERE plate IS NOT NULL;
/*Ejercicio 9*/
SELECT COUNT(*)
FROM cars;
/*Ejercicio 10*/
SELECT COUNT(*)
FROM cars
WHERE color = 9001;
/*Ejercicio 11*/
SELECT AVG (year)
FROM cars;
/*Ejercicio 12*/
SELECT *
FROM cars
WHERE plate LIKE 'EE';
/*Ejercicio 13*/
SELECT *
FROM cars
WHERE year = 1990
AND color = 5000
ORDER BY plate;
/*Ejercicio 14*/
SELECT *
FROM cars
WHERE year = 1990
AND color = 8000; 
/*Ejercicio 15*/
SELECT *
FROM cars
WHERE plate LIKE '%A%';
