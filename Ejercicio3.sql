CREATE TABLE model
(
 id BIGINT,
 name VARCHAR(16),
 year int NOT NULL,
 patent VARCHAR(16),
 CONSTRAINT pk_model PRIMARY KEY(id)
 CONSTRAINT unique_model UNIQUE(patent)
);
INSERT INTO model(id,name,year,patent) VALUES(1, 'Seat C1',  1998, 'C1') 
INSERT INTO model(id, name, year, patent) VALUES(2, 'Seat 800', 1999, 'C2')
INSERT INTO model(id, name, year, patent) VALUES(3, 'Citröen BZ', 2000, 'A2')
INSERT INTO model(id, name, year, patent) VALUES(4, 'Citröen XD', 2001, 'A3')
INSERT INTO model(id, name, year, patent) VALUES(5, 'Ford Fiesta', 2002, 'B1')
INSERT INTO model(id, name, year, patent) VALUES(6, 'Ford Focus', 2003, 'B2')

CREATE TABLE cars
(
  id BIGINT,
  plate VARCHAR(16),
  color VARCHAR(16),
  year INT NOT NULL,
  model BIGINT NOT NULL,
  CONSTRAINT pk_cars PRIMARY KEY(id)
  CONSTRAINT unique_cars UNIQUE(plate)
  CONSTRAINT fk_model FOREIGN KEY(model) REFERENCES model(id)
);
INSERT INTO cars(id, plate, color, year, model) VALUES (1, 'AA', 'Red', 1997, 1)  
INSERT INTO cars(id, plate, color, year, model) VALUES (2, 'BB', 'Blue', 1998, 2)
INSERT INTO cars(id, plate, color, year, model) VALUES (3, 'CC', 'Purple', 1999, 1)  
INSERT INTO cars(id, plate, color, year, model) VALUES (4, 'DD', 'White', 2000, 2) 
INSERT INTO cars(id, plate, color, year, model) VALUES (5, 'EE', 'Purple', 1999, 1)  
INSERT INTO cars(id, plate, color, year, model) VALUES (6, 'FF', 'Blue', 1999, 4)  
INSERT INTO cars(id, plate, color, year, model) VALUES (7, 'GG', 'Purple', 2001, 3)  
INSERT INTO cars(id, plate, color, year, model) VALUES (8, 'HH', 'Green', 2002, 3)
INSERT INTO cars(id, plate, color, year, model) VALUES (9, 'II', 'Black', 2003, 4)
INSERT INTO cars(id, plate, color, year, model) VALUES (10, 'JJ', 'Magenta', 2005, 5)
INSERT INTO cars(id, plate, color, year, model) VALUES (11, 'KK', 'Gray', 2005, 6)
INSERT INTO cars(id, plate, color, year, model) VALUES (12, 'LL', 'Purple', 2005, 5)
INSERT INTO cars(id, plate, color, year, model) VALUES (7, 'GG', 'Yellow', 2006, 6)

/*Ejercicio 1*/
SELECT plate, color
FROM cars;
/*Ejercicio 2*/
SELECT patent, name
FROM cars;

/*Ejercicio 3*/
/*Ejercicio 4*/
/*Ejercicio 5*/
/*Ejercicio 6*/
/*Ejercicio 7*/
/*Ejercicio 8*/
/*Ejercicio 9*/
/*Ejercicio 10*/
/*Ejercicio 11*/
/*Ejercicio 12*/
/*Ejercicio 13*/