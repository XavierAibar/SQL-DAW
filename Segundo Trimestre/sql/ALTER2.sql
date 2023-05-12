CREATE TABLE ASIGNATURA
(
  codigo INT,
  nombre VARCHAR(20),
  CONSTRAINT pk_asignatura_codigo PRIMARY KEY(codigo),
);

CREATE TABLE DEPARTAMENTO
(
  cod INT,
  nombre VARCHAR(20),
  CONSTRAINT pk_departamento_cod PRIMARY KEY(cod),
);

CREATE TABLE PROFESOR
(
  dni VARCHAR(9),
  nombre VARCHAR(20),
  apellidos VARCHAR(40),
  edad INT, 
  departamento INT,
  CONSTRAINT pk_profesor_dni PRIMARY KEY(dni),
  CONSTRAINT fk_departamento_profesor FOREIGN KEY(departamento) REFERENCES DEPARTAMENTO(cod) ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE imparte 
(
  asignatura INT,
  profesor VARCHAR(9),
  CONSTRAINT pk_asig_profe_imparte PRIMARY KEY(asignatura, profesor),
  CONSTRAINT fk_asig_imparte FOREIGN KEY (asignatura) REFERENCES ASIGNATURA(codigo) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_profesor_imparte FOREIGN KEY (profesor) REFERENCES PROFESOR(dni) ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE CODIFICACION
(
  id INT,
  tipo VARCHAR(20),
  video INT,
  CONSTRAINT pk_codificacion PRIMARY KEY (id,video),
  CONSTRAINT fk_video FOREIGN KEY (video) REFERENCES VIDEO(id)
  

);


CREATE TABLE VIDEO
(
  id INT,
  titulo VARCHAR(20) NOT NULL,
  descripcion VARCHAR(20),
  CONSTRAINT pk_video PRIMARY KEY (id),
);


CREATE TABLE es_de
(
  profesor VARCHAR(9),
  video INT,
  CONSTRAINT pk_es_de PRIMARY KEY (profesor, video),
  CONSTRAINT fk_profesor_es_de FOREIGN KEY (profesor) REFERENCES PROFESOR(dni) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_video_es_de FOREIGN KEY (video) REFERENCES VIDEO(id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Introduce los siguientes valores. Si hay error en algún insert, explica en cual y justifica el porqué.

INSERT INTO DEPARTAMENTO (cod, nombre) VALUES (0, 'Informatica');
INSERT INTO DEPARTAMENTO (cod, nombre) VALUES (1, 'Ingles');
INSERT INTO DEPARTAMENTO (cod, nombre) VALUES (2, 'Castellano');

INSERT INTO ASIGNATURA (codigo, nombre) VALUES (0,'BBDD');
INSERT INTO ASIGNATURA (codigo, nombre) VALUES (1,'SISTEMAS');
INSERT INTO ASIGNATURA (codigo, nombre) VALUES (2,'READING');
INSERT INTO ASIGNATURA (codigo, nombre) VALUES (3,'LENGUA Y LITERATURA');
INSERT INTO ASIGNATURA (codigo, nombre) VALUES (4,'ANALISIS MORFOLOGICO');

INSERT INTO PROFESOR (dni, nombre, apellidos, edad, departamento) VALUES ('00000000A', 'JOSE', 'GARCÍA ROMERO', 37, 0);
INSERT INTO PROFESOR (dni, nombre, apellidos, edad, departamento) VALUES ('11111111B', 'MERCEDES', 'LÓPEZ MARTÍ', 37, 0);
INSERT INTO PROFESOR (dni, nombre, apellidos, edad, departamento) VALUES ('22222222C', 'JULIO', 'JORNET VIVES', 37, 1)
INSERT INTO PROFESOR (dni, nombre, apellidos, edad) VALUES ('33333333D', 'AMPARO', 'ESTEVE BLASCO', 33);
INSERT INTO PROFESOR (dni, nombre, apellidos, edad, departamento) VALUES ('33333333D', 'AMPARO', 'ESTEVE BLASCO', 33,5); --Mal, ya que repite la PK


INSERT INTO VIDEO (id, titulo, descripcion) VALUES (0, 'VIDEO 0', 'DESCRIPCIÓN 0');
INSERT INTO VIDEO (id, titulo, descripcion) VALUES (1, 'VIDEO 1', 'DESCRIPCIÓN 1');
INSERT INTO VIDEO (id, titulo, descripcion) VALUES (2, 'VIDEO 2', 'DESCRIPCIÓN 2');

INSERT INTO CODIFICACION (id, tipo, video) VALUES (0, 'MP4', 0);
INSERT INTO CODIFICACION (id, tipo, video) VALUES (1, 'MP4', 2);
INSERT INTO CODIFICACION (id, tipo, video) VALUES (2, 'MP4', 1);
INSERT INTO CODIFICACION (id, tipo, video) VALUES (3, 'MP4', 2);
INSERT INTO CODIFICACION (id, tipo, video) VALUES (1, 'MP4', 2); --Primary Key Repetida
INSERT INTO CODIFICACION (id, tipo, video) VALUES (4, 'MP123456789012345678012', 2); --Varchar Mayor de lo permitido 
INSERT INTO CODIFICACION (tipo, video) VALUES ('MP4', 0); --No hay id, que forma parte del Primary Key
                     
INSERT INTO es_de (profesor, video) VALUES ('00000000A',0);
INSERT INTO es_de (profesor, video) VALUES ('11111111B',1);
INSERT INTO es_de (profesor, video) VALUES ('22222222C',2);
INSERT INTO es_de (profesor, video) VALUES ('33333333D',1);
INSERT INTO es_de (profesor, video) VALUES ('33333333D',5); --No existe ningun video con el ID 5
INSERT INTO es_de (profesor, video) VALUES (4,1); --profesor no tiene un int como primary key si no un VARCHAR
INSERT INTO es_de (profesor, video) VALUES ('33333333D',1); --Primary key repetida.
                      
--c) Modifica las siguientes columnas de las tablas:

ALTER TABLE PROFESOR
ADD pago VARCHAR(20);

ALTER TABLE PROFESOR
ALTER COLUMN nombre VARCHAR(40);     
                      
ALTER TABLE PROFESOR
ALTER COLUMN apellidos VARCHAR(40);                  
                      
ALTER TABLE PROFESOR
ADD CONSTRAINT ck_edad_profesor CHECK(edad > 0);
                      
ALTER TABLE PROFESOR
DROP CONSTRAINT ck_edad_profesor;           
                      
ALTER TABLE PROFESOR
ADD CONSTRAINT ck_edad_profesor CHECK(edad  BETWEEN 16 AND 75);   
                      
/*Añade una relación entre las tablas para que un departamento tenga muchas asignaturas yuna asignatura sólo pueda pertenecer 
a un departamento (Tal vez tengas que añadir antes alguna columna).*/

ALTER TABLE DEPARTAMENTO
ADD asignatura INT;                      
                      
ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT fk_dep_asig FOREIGN KEY (asignatura) REFERENCES ASIGNATURA(codigo);
                                       
SELECT * FROM DEPARTAMENTO; --NULL
                      
INSERT INTO DEPARTAMENTO (cod, nombre, asignatura) VALUES (4,'iNFORMATICA',1);
                      
ALTER TABLE VIDEO
ADD CONSTRAINT df_video_descripcion DEFAULT 'El video no tiene descripción' FOR descripcion;

INSERT INTO VIDEO (id, titulo, descripcion) VALUES (3,'VIDEO 3', NULL);

INSERT INTO VIDEO (id, titulo) VALUES (4,'VIDEO 4'); --No se puede, ya que descripción es un varchar 20

ALTER TABLE VIDEO
ALTER COLUMN descripcion VARCHAR(40); --Con esto ya funcionaría

ALTER TABLE PROFESOR
ALTER COLUMN edad BIGINT; --No se altera ya que hay un check que depende de esa columna

ALTER TABLE PROFESOR
DROP CONSTRAINT ck_edad_profesor; --Ahora ya podemos.

ALTER TABLE PROFESOR
ADD CONSTRAINT ck_edad_profesor CHECK(edad  BETWEEN 16 AND 75);   --Volvemos a hacer el check.

ALTER TABLE ASIGNATURA
ALTER COLUMN codigo BIGINT; --No se puede ya que es el pk.

ALTER TABLE ASIGNATURA
DROP CONSTRAINT pk_asignatura_codigo;  --No se puede porque esta de fk en Departamento.

ALTER TABLE DEPARTAMENTO
DROP CONSTRAINT fk_dep_asig; --Sigue sin poderse ya que está tambien en imparte.

ALTER TABLE imparte
DROP CONSTRAINT fk_asig_imparte; --ahora si podemos eliminar la pk y hacerlo BIGINT

ALTER TABLE ASIGNATURA
ALTER COLUMN codigo BIGINT NOT NULL; --NN ya que si no es not null no se puede hacer pk

ALTER TABLE ASIGNATURA
ADD CONSTRAINT pk_asignatura_codigo PRIMARY KEY(codigo);

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT fk_dep_asig FOREIGN KEY (asignatura) REFERENCES ASIGNATURA(codigo); --No se puede ya que no tiene el mismo data type

ALTER TABLE DEPARTAMENTO
ALTER COLUMN asignatura BIGINT; --Ahora si se puede

ALTER TABLE imparte
ALTER COLUMN asignatura BIGINT; --No se puede es pk.

ALTER TABLE imparte
DROP CONSTRAINT pk_asig_profe_imparte;

ALTER TABLE imparte
ALTER COLUMN asignatura BIGINT NOT NULL;

ALTER TABLE imparte
ADD CONSTRAINT pk_asig_profe_imparte PRIMARY KEY(asignatura, profesor);

ALTER TABLE imparte
ADD CONSTRAINT fk_asig_imparte FOREIGN KEY (asignatura) REFERENCES ASIGNATURA(codigo) ON UPDATE CASCADE ON DELETE CASCADE;