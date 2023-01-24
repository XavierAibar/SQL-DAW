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