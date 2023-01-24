CREATE TABLE services
(
  id BIGINT,
  name VARCHAR(64),
  description TEXT,
  CONSTRAINT pk_services PRIMARY KEY(id)
);
INSERT INTO services (id, name, description) VALUES (1, 'Servicio 1', 'A');
INSERT INTO services (id, name, description) VALUES (2, 'Servicio 2', 'B');
INSERT INTO services (id, name, description) VALUES (3, 'Servicio 3', 'C');
INSERT INTO services (id, name, description) VALUES (4, 'Servicio 4', 'D');
INSERT INTO services (id, name, description) VALUES (5, 'Servicio 5', 'E');
INSERT INTO services (id, name, description) VALUES (6, 'Servicio 6', 'F');
INSERT INTO services (id, name, description) VALUES (7, 'Servicio 7', 'G');
INSERT INTO services (id, name, description) VALUES (8, 'Servicio 8', 'H');
INSERT INTO services (id, name, description) VALUES (9, 'Servicio 9', 'I');
INSERT INTO services (id, name, description) VALUES (10, 'Servicio 10', 'J');
INSERT INTO services (id, name, description) VALUES (11, 'Servicio 11', 'K');
INSERT INTO services (id, name, description) VALUES (12, 'Servicio 12', 'L');
INSERT INTO services (id, name, description) VALUES (13, 'Servicio 13', 'M');
INSERT INTO services (id, name, description) VALUES (14, 'Servicio 14', 'N');
INSERT INTO services (id, name, description) VALUES (15, 'Servicio 15', 'O');


CREATE TABLE hotels
(
  id BIGINT,
  name VARCHAR(64),
  foundation_date DATE,
  CONSTRAINT pk_hotels PRIMARY KEY(id)
);
INSERT into hotels (id, name, foundation_date) VALUES (1, 'Hotel Jose', '2000-12-12');
INSERT into hotels (id, name, foundation_date) VALUES (2, 'Hotel Pepe', '2002-01-20');
INSERT into hotels (id, name, foundation_date) VALUES (3, 'Hotel Barrio', '2003-12-22');
INSERT into hotels (id, name, foundation_date) VALUES (4, 'Hotel Rojo', '2004-08-30');
INSERT into hotels (id, name, foundation_date) VALUES (5, 'Hotel Santa Pola', '2005-05-12');

CREATE TABLE offers
(
  service_id BIGINT,
  hotel_id BIGINT,
  CONSTRAINT pk_offers PRIMARY KEY(service_id, hotel_id),
  CONSTRAINT fk_offers_services FOREIGN KEy(service_id) REFERENCES services(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_offers_hotels FOREIGN KEY(hotel_id) REFERENCES hotels(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO offers (hotel_id, service_id)
VALUES (1, 2);
INSERT INTO offers (hotel_id, service_id)
VALUES (1, 3);
INSERT INTO offers (hotel_id, service_id)
VALUES (1, 4);
INSERT INTO offers (hotel_id, service_id)
VALUES (1, 5);
INSERT INTO offers (hotel_id, service_id)
VALUES (2, 6);
INSERT INTO offers (hotel_id, service_id)
VALUES (2, 7);
INSERT INTO offers (hotel_id, service_id)
VALUES (2, 8);
INSERT INTO offers (hotel_id, service_id)
VALUES (2, 9);
INSERT INTO offers (hotel_id, service_id)
VALUES (2, 10);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 1);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 2);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 3);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 5);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 7);
INSERT INTO offers (hotel_id, service_id)
VALUES (3, 9);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 1);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 2);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 3);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 4);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 5);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 11);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 12);
INSERT INTO offers (hotel_id, service_id)
VALUES (4, 13);
/*Ejercicio 1*/
SELECT services.name, description
FROM services;
/*Ejercicio 2*/
SELECT hotels.name, foundation_date
FROM hotels;
/*Ejercicio 3*/
SELECT hotels.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE foundation_date > '2003';
/*Ejercicio 4*/
SELECT hotels.name, services.name, description
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id;
/*Ejercicio 5*/
SELECT services.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE foundation_date > '2003-08-2';
/*Ejercicio 6*/
SELECT hotels.name, services.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE hotels.name LIKE '%A%' AND LEN(services.name) > 8;
/*Ejercicio 7*/
SELECT hotels.name
FROM hotels
WHERE hotels.id NOT IN (SELECT hotels FROM offers);