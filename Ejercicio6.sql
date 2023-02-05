CREATE TABLE persons
(
  id BIGINT,
  name VARCHAR(64)	NOT NULL,
  civil_status VARCHAR(20) DEFAULT 'soltero',
  born_date DATE NOT NULL DEFAULT '1900-01-01',
  CONSTRAINT pk_persons_id PRIMARY KEY(id),
  CONSTRAINT ch_status_persons CHECK (civil_status IN ('soltero','casado','separado')),
);

INSERT INTO persons(id,name,civil_status,born_date) VALUES(1,'Javi','casado','2005-03-03');
INSERT INTO persons(id,name,born_date) VALUES(2,'Luisa','1934-04-23');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(3,'Robert','separado','1995-01-13');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(4,'Marcos','soltero','1935-03-12');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(5,'Lara','separado','1934-02-01');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(6,'Paula','casado','2010-03-25');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(7,'Pepa','casado','2012-11-13');
INSERT INTO persons(id,name,civil_status) VALUES(8,'Juan','separado');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(9,'Yo','casado','2005-03-03');
INSERT INTO persons(id,name,civil_status,born_date) VALUES(10,'Mama','casado','1973-12-23');

CREATE TABLE places
(
  id BIGINT,
  name VARCHAR(64) NOT NULL,
  area BIGINT, 
  container BIGINT,
  CONSTRAINT pk_places_id PRIMARY KEY(id),
  CONSTRAINT ch_places_area CHECK (area BETWEEN 1 AND 1000),
  CONSTRAINT fk_places_container FOREIGN KEY (container) REFERENCES places(id)
);

INSERT INTO places(id,name,area,container) VALUES (1,'Alicante',70,3);
INSERT INTO places(id,name,area,container) VALUES (2,'Getafe',20,4);
INSERT INTO places(id,name,area,container) VALUES (3,'Valencia',400,10);
INSERT INTO places(id,name,area,container) VALUES (4,'Madrid',500,10);
INSERT INTO places(id,name,area,container) VALUES (5,'Vallecas',10,4);
INSERT INTO places(id,name,area,container) VALUES (6,'Elche',10,3);
INSERT INTO places(id,name,area,container) VALUES (7,'Santa Pola',3,1);
INSERT INTO places(id,name,area,container) VALUES (8,'Gran Alacant',1,7);
INSERT INTO places(id,name,area,container) VALUES (9,'Jaen',60,10);
INSERT INTO places(id,name,area) VALUES (10,'España',1000);
SELECT * FROM places;
CREATE TABLE has_nacionality
(
  places BIGINT,
  persons BIGINT,
  dni VARCHAR(64),
  CONSTRAINT pk_has_nacionality PRIMARY KEY(places,persons),
  CONSTRAINT uk_dni_hn UNIQUE (dni),
  CONSTRAINT ch_dni_len CHECK (LEN(dni)>5),
  CONSTRAINT fk_places_hn FOREIGN KEY (places) REFERENCES places(id) on UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_persons_hn FOREIGN KEY (persons) REFERENCES persons(id) on UPDATE CASCADE ON DELETE CASCADE,
);
INSERT INTO has_nacionality(places,persons,dni) VALUES (1,2,'aaaaaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (2,1,'aaahjab');
INSERT INTO has_nacionality(places,persons,dni) VALUES (4,3,'aabaca');
INSERT INTO has_nacionality(places,persons,dni) VALUES (3,4,'vvbaaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (10,5,'aaayaaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (7,6,'aaaaabb');
INSERT INTO has_nacionality(places,persons,dni) VALUES (5,7,'aaaddaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (6,8,'aacvaaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (1,9,'aaaepaa');
INSERT INTO has_nacionality(places,persons,dni) VALUES (4,10,'aaayaa');

/*Ejercicio 1*/
SELECT name, civil_status
FROM persons;

/*Ejercicio 2*/
SELECT p.name, h.dni
FROM persons as p LEFT JOIN has_nacionality as h on p.id = h.persons;

/*Ejercicio 3*/
SELECT p.name, COUNT(*)
FROM persons AS p INNER JOIN has_nacionality as h ON p.id = h.persons
GROUP BY p.name, h.dni;
