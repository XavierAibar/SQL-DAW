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
INSERT INTO offers (hotel_id, service_id) VALUES (1, 2);
INSERT INTO offers (hotel_id, service_id) VALUES (1, 3);
INSERT INTO offers (hotel_id, service_id) VALUES (1, 4);
INSERT INTO offers (hotel_id, service_id) VALUES (1, 5);
INSERT INTO offers (hotel_id, service_id) VALUES (2, 6);
INSERT INTO offers (hotel_id, service_id) VALUES (2, 7);
INSERT INTO offers (hotel_id, service_id) VALUES (2, 8);
INSERT INTO offers (hotel_id, service_id) VALUES (2, 9);
INSERT INTO offers (hotel_id, service_id) VALUES (2, 10);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 1);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 2);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 3);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 5);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 7);
INSERT INTO offers (hotel_id, service_id) VALUES (3, 9);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 1);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 2);
INSERT INTO offers (hotel_id, service_id) vALUES (4, 3);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 4);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 5);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 11);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 12);
INSERT INTO offers (hotel_id, service_id) VALUES (4, 13);
/*Ejercicio 1*/
SELECT s.name, s.description
FROM services as s;
/*Ejercicio 2*/
SELECT h.name, foundation_date
FROM hotels AS h;
/*Ejercicio 3*/
SELECT h.name
FROM services AS s INNER JOIN offers ON s.id = service_id INNER JOIN hotels AS h ON hotel_id = h.id
WHERE foundation_date > '2003';
/*Ejercicio 4*/
SELECT h.name as Hotel, s.name as Service, s.description
FROM services as s INNER JOIN offers as o ON s.id = service_id INNER JOIN hotels as h ON hotel_id = h.id;
/*Ejercicio 5*/
SELECT s.name
FROM services as s INNER JOIN offers as o ON s.id = service_id INNER JOIN hotels as h ON hotel_id = h.id
WHERE foundation_date > '2003-08-2';
/*Ejercicio 6*/
SELECT h.name as hotel, s.name as service
FROM services as s INNER JOIN offers as o ON s.id = service_id INNER JOIN hotels as h ON hotel_id = h.id
WHERE h.name LIKE '%A%' AND LEN(s.name) > 8;
/*Ejercicio 7*/
SELECT h.name
FROM hotels as h
WHERE h.id NOT IN 
(
SELECT o.hotel_id 
FROM offers as o
);
/*Ejercicio 8*/
SELECT s.name
FROM services as s
WHERE s.id NOT IN
(
SELECT o.service_id
FROM offers as o
);
/*Ejercicio 9*/
SELECT h.name, COUNT (h.name) AS Services
FROM hotels as h INNER JOIN offers as o ON h.id = hotel_id
GROUP BY h.id, h.name;
/*Ejercicio 10*/
SELECT h.name, COUNT(*) as Services
FROM hotels as h INNER JOIN offers as o ON hotel_id = h.id
GROUP BY h.id, h.name
HAVING COUNT(*) > 6;