CREATE TABLE services
(
  id BIGINT,
  name VARCHAR(64),
  description TEXT,
  CONSTRAINT pk_services PRIMARY KEY(id)
);
--Create
CREATE TABLE hotels
(
  id BIGINT,
  name VARCHAR(64),
  foundation_date DATE,
  CONSTRAINT pk_hotels PRIMARY KEY(id)
);
--Tabla offers
CREATE TABLE offers
(
  service_id BIGINT,
  hotel_id BIGINT,
  CONSTRAINT pk_offers PRIMARY KEY(service_id, hotel_id),
  CONSTRAINT fk_offers_services FOREIGN KEy(service_id) REFERENCES services(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_offers_hotels FOREIGN KEY(hotel_id) REFERENCES hotels(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO services (id, name, description)
VALUES (1, 'Servicio1', 'Descripción 1');
INSERT INTO services (id, name, description)
VALUES (2, 'Servicio2', 'Descripción 2');
INSERT INTO services (id, name, description)
VALUES (3, 'Servicio3', 'Descripción 3');
INSERT INTO services (id, name, description)
VALUES (4, 'Servicio4', 'Descripción 4');
INSERT INTO services (id, name, description)
VALUES (5, 'Servicio5', 'Descripción 5');
INSERT INTO services (id, name, description)
VALUES (6, 'Servicio6', 'Descripción 6');
INSERT INTO services (id, name, description)
VALUES (7, 'Servicio7', 'Descripción 7');
INSERT INTO services (id, name, description)
VALUES (8, 'Servicio8', 'Descripción 8');
INSERT INTO services (id, name, description)
VALUES (9, 'Servicio9', 'Descripción 9');
INSERT INTO services (id, name, description)
VALUES (10, 'Servicio10', 'Descripción 10');
INSERT INTO services (id, name, description)
VALUES (11, 'Servicio11', 'Descripción 11');
INSERT INTO services (id, name, description)
VALUES (12, 'Servicio12', 'Descripción 12');
INSERT INTO services (id, name, description)
VALUES (13, 'Servicio13', 'Descripción 13');
INSERT INTO services (id, name, description)
VALUES (14, 'Servicio14', 'Descripción 14');
INSERT INTO services (id, name, description)
VALUES (15, 'Servicio15', 'Descripción 15');
SELECT * FROM services;
--Insetar hoteles 
INSERT into hotels (id, name, foundation_date)
VALUES (1, 'Hotel1', '2000-10-20');
INSERT into hotels (id, name, foundation_date)
VALUES (2, 'Hotel2', '2001-11-11');
INSERT into hotels (id, name, foundation_date)
VALUES (3, 'Hotel3', '2002-12-22');
INSERT into hotels (id, name, foundation_date)
VALUES (4, 'Hotel4', '2003-08-01');
INSERT into hotels (id, name, foundation_date)
VALUES (5, 'Hotel5', '2004-07-02');
SELECT * FROM hotels; 
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
--1
SELECT services.name, description
FROM services;
--2
SELECT hotels.name, foundation_date
FROM hotels;
--3
SELECT hotels.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE foundation_date > '2003';
--4
SELECT hotels.name, services.name, description
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id;
--5 NO SALE
SELECT services.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE foundation_date > '2003-08-2';
--6
SELECT hotels.name, services.name
FROM services INNER JOIN offers ON services.id = service_id INNER JOIN hotels ON hotel_id = hotels.id
WHERE hotels.name LIKE '%A%' AND LEN(services.name) > 8;
--7
SELECT hotels.name
FROM hotels
WHERE hotels.id NOT IN (SELECT hotels FROM offers);