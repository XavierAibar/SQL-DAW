DROP TABLE demo;
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




SELECT * FROM cars;