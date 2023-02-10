CREATE TABLE persons 
(
  id BIGINT,
  name VARCHAR(64),
  gender CHAR,
  CONSTRAINT pk_persons PRIMARY KEY (id)
);
INSERT INTO persons (id, name, gender) VALUES (1, 'Ana', 'F');
INSERT into persons (id, name, gender) VALUES (2, 'Maria', 'F');
INSERT into persons (id, name, gender) VALUES (3, 'Robert', 'F');
INSERT INTO persons (id, name, gender) VALUES (4, 'Pepe', 'M');
INSERT into persons (id, name, gender) VALUES (5, 'Carlos', 'M');
INSERT INTO persons (id, name, gender) VALUES (6, 'Mateo', 'M');
INSERT INTO persons (id, name, gender) VALUES (7, 'Sofia', 'F');
INSERT INTO persons (id, name, gender) VALUES (8, 'Xavi', 'M');
INSERT INTO persons (id, name, gender) VALUES (9, 'Miguel', 'M');
INSERT INTO persons (id, name, gender) VALUES (10, 'Manuel', 'F');

--prueba
SELECT * FROM persons;

CREATE TABLE is_parent
(
  parent BIGINT,
  child BIGINT,
  CONSTRAINT pk_parent PRIMARY KEY (parent, child),
  CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_child FOREIGN KEY (child) REFERENCES persons(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);
INSERT INTO is_parent (parent, child) VALUES(2, 3);
INSERT INTO is_parent (parent, child) VALUES(4, 3);
INSERT INTO is_parent (parent, child) VALUES(2, 8);
INSERT INTO is_parent (parent, child) VALUES(4, 8);
INSERT INTO is_parent (parent, child) VALUES(2, 10);
INSERT INTO is_parent (parent, child) VALUES(4, 10);
INSERT INTO is_parent (parent, child) VALUES(8, 5);
INSERT INTO is_parent (parent, child) VALUES(7, 5);
INSERT INTO is_parent (parent, child) VALUES(3, 9);
INSERT INTO is_parent (parent, child) VALUES(1, 9);
INSERT INTO is_parent (parent, child) VALUES(3, 1);
INSERT INTO is_parent (parent, child) VALUES(3, 7);
INSERT INTO is_parent (parent, child) VALUES(7, 2);

--prueba
SELECT * FROM is_parent;

CREATE TABLE ofices
(
  id BIGINT,
  name VARCHAR(64),
  CONSTRAINT pk_ofices PRIMARY KEY (id)
);
INSERT INTO ofices (id, name) VALUES (1, 'Fontanero');
INSERT INTO ofices (id, name) VALUES (2, 'Programador');
INSERT INTO ofices (id, name) VALUES (3, 'Cajero');
INSERT INTO ofices (id, name) VALUES (4, 'Luchador');
INSERT INTO ofices (id, name) VALUES (5, 'Cazarecompensas');

--prueba
SELECT * FROM ofices;

CREATE TABLE works_in 
(
  person BIGINT,
  ofice BIGINT,
  since DATE,
  until DATE, 
  CONSTRAINT pk_works_in PRIMARY KEY (since, person, ofice),
  CONSTRAINT fk_works_in_person FOREIGN KEY (person) REFERENCES persons(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_works_in_ofice FOREIGN KEY (ofice) REFERENCES ofices(id) ON UPDATE CASCADE ON DELETE CASCADE
);
INSERT INTO works_in (person, ofice, since) VALUES (3, 2, '2018-12-02');
INSERT INTO works_in (person, ofice, since) VALUES (4, 5, '1978-02-26');
INSERT INTO works_in (person, ofice, since) VALUES (10, 2, '2015-11-23');
INSERT INTO works_in (person, ofice, since) VALUES (1, 3, '1988-01-01');
INSERT INTO works_in (person, ofice, since) VALUES (2, 1, '1967-05-21');
INSERT INTO works_in (person, ofice, since) VALUES (2, 3, '2001-01-13');
INSERT INTO works_in (person, ofice, since) VALUES (3, 1, '2009-09-11');
INSERT INTO works_in (person, ofice, since) VALUES (4, 3, '1997-04-12');
INSERT INTO works_in (person, ofice, since, until) VALUES (7, 2, '2006-12-29', '2016-10-14');
INSERT INTO works_in (person, ofice, since, until) VALUES (8, 5, '2003-09-29', '2018-03-02');
INSERT INTO works_in (person, ofice, since, until) VALUES (5, 1, '1967-05-21', '1996-01-01');
INSERT INTO works_in (person, ofice, since, until) VALUES (6, 1, '1967-05-21', '2013-05-04');
INSERT INTO works_in (person, ofice, since, until) VALUES (8, 3, '2022-12-01', '2023-01-02');
INSERT INTO works_in (person, ofice, since) VALUES (5, 1, '2000-01-01');
INSERT INTO works_in (person, ofice, since) VALUES (6, 5, '2018-01-24');

--prueba
SELECT * FROM works_in;

/*Ejercicio 1*/

SELECT name, gender
FROM persons;

/*Ejercicio 2*/

SELECT p.name as Trabajador, o.name as Trabajo
FROM persons as p INNER JOIN works_in as w on p.id = w.person 
INNER JOIN ofices as o on w.ofice = o.id;

/*Ejercicio 3*/

SELECT p.name as Trabajador, o.name as Trabajo
FROM persons as p LEFT JOIN works_in as w on p.id = w.person 
LEFT JOIN ofices as o on w.ofice = o.id;

/*Ejercicio 4*/
SELECT TOP 1 since
FROM works_in 
ORDER by since ASC

/*Ejercicio 5*/

SELECT TOP 1 p.name
FROM persons as p INNER JOIN works_in As w on p.id = w.person
ORDER by w.since ASC;

/*Ejercicio 6*/

SELECT TOP 3 p.name
FROM persons as p INNER JOIN works_in As w on p.id = w.person
WHERE until IS NULL
ORDER by w.since ASC;

/*Ejercicio 7*/

SELECT DISTINCT child.name as Nombre, COUNT(*) as NumeroDePadres
FROM persons as child INNER JOIN is_parent as i ON child.id = i.child
INNER JOIN persons as parent on parent.id = i.parent
GROUP BY child.id, child.name
HAVING COUNT(*) = 1;

/*Ejercicio 8*/

SELECT child.name
FROM persons as child INNER JOIN is_parent as i ON child.id = i.child
INNER JOIN persons as parent on parent.id = i.parent
WHERE parent.name LIKE 'Maria';

/*Ejercicio 9*/

SELECT p.name as Trabajador, o.name as Trabajo
FROM persons as p INNER JOIN works_in as w on p.id = w.person 
INNER JOIN ofices as o on w.ofice = o.id
WHERE until IS NULL;


/*Ejercicio 10*/

SELECT child.name, o.name
FROM  persons as maria INNER JOIN is_parent as i on maria.id = i.parent 
INNER JOIN persons as child ON i.child = child.id
INNER JOIN works_in as w on  child.id = w.person 
INNER JOIN ofices as o on w.ofice = o.id
WHERE maria.name LIKE 'Maria' AND w.until IS NULL;

/*Ejercicio 11*/

SELECT DISTINCT p.name
FROM persons as p INNER JOIN works_in as w ON p.id = w.person
WHERE until IS NOT NULL 

/*Ejercicio 12*/

SELECT COUNT (*) AS Padres
FROM persons as p INNER JOIN is_parent as i on p.id = i.parent
WHERE p.gender LIKE 'M';

/*Ejercicio 13 MAL*/

SELECT father.name as Padre, mother.name as Madre, child.name as hijo
FROM persons as father INNER JOIN is_parent AS i on father.id = i.parent INNER JOIN persons as child on i.child = child.id
INNER JOIN is_parent AS ip ON child.id = ip.parent INNER JOIN persons as mother on mother.id = ip.child
GROUP BY mother.id, father.id, child.id, father.name, mother.name, child.name;

/*Ejercicio 14 MAL*/

SELECT father.name as Padre, mother.name as Madre, COUNT(*)
FROM persons as father INNER JOIN is_parent AS i on father.id = i.parent INNER JOIN persons as child on i.child = child.id
INNER JOIN is_parent AS ip ON child.id = ip.parent INNER JOIN persons as mother on mother.id = ip.child
GROUP BY mother.id, father.id, father.name, mother.name


