CREATE TABLE Dept
(
dept_no INT NOT NULL,
name VARCHAR(50),
location VARCHAR(50)
CONSTRAINT pk_dep PRIMARY KEY (dept_no)
);

CREATE TABLE Emp
(
emp_no INT NOT NULL,
surname VARCHAR(50),
office VARCHAR(50),
dir INT,
hiring_date SMALLDATETIME,
salary NUMERIC(9,2),
comission NUMERIC(9,2),
dept_no INT NOT NULL

);

CREATE TABLE Hospital
(
hospital_cod INT NOT NULL,
name VARCHAR(50),
address VARCHAR(50),
tf_number VARCHAR(50),
beds INT
);

CREATE TABLE Doctor
(
hospital_cod INT NOT NULL,
doctor_no INT NOT NULL,
surname VARCHAR(50),
speciality VARCHAR(50),
);

CREATE TABLE Sala
(
patient INT NOT NULL,
Sala_Cod INT NOT NULL,
name VARCHAR(50),
beds INT
);

CREATE TABLE Plantilla
(
hospital_Cod INT,
sala_Cod INT,
empleado_No INT,
surname VARCHAR(50),
performance VARCHAR(50),
T VARCHAR(15),
Salary NUMERIC(9,2)
);

CREATE TABLE Enfermo
(
inscription INT NOT NULL,
surname VARCHAR(50) NULL,
direction VARCHAR(50) NULL,
born_date VARCHAR(50) NULL,
S VARCHAR(2) NULL,
NSS INT NULL
);

INSERT INTO Dept(dept_No,name,location) VALUES(10,'CONTABILIDAD','ELCHE')
INSERT INTO Dept(dept_No,name,location) VALUES(20,'INVESTIGACION','MADRID')
INSERT INTO Dept(dept_No,name,location) VALUES(30,'VENTAS','BARCELONA')
INSERT INTO Dept(dept_No,name,location) VALUES(40,'PRODUCCION','SALAMANCA')
INSERT INTO Emp(emp_no, surname, office, dir, hiring_date, salary, comission, dept_no)
VALUES
(7369,'SANCHEZ','EMPLEADO',7902,'1980-12-17',10400,0,20),
(7499,'ARROYO','VENDEDOR',7698,'1981-02-22',208000,39000,30),
(7521,'SALA','VENDEDOR',689,'1981-02-22',162500,65000,30),
(7566,'JIMENEZ','DIRECTOR',7839,'1981-04-02',386750,0,20),
(7654,'MARTIN','VENDEDOR',7698,'1981-09-28',182000,182000,30),
(7698,'NEGRO','DIRECTOR',7839,'1981-05-01',370500,0,30),
(7782,'CEREZO','DIRECTOR',7839,'1981-06-09',318500,0,10),
(7788,'NINO','ANALISTA',7566,'1987-03-30',390000,0,20),
(7839,'REY','PRESIDENTE',0,'1981-11-17',650000,0,10),
(7844,'TOVAR','VENDEDOR',7698,'1981-09-08',195000,0,30),
(7876,'ALONSO','EMPLEADO',7788,'1987-05-03',143000,0,20),
(7900,'JIMENO','EMPLEADO',7698,'1981-12-03',123500,0,30),
(7902,'FERNANDEZ','ANALISTA',7566,'1981-12-03',390000,0,20),
(7934,'MUÑOZ','EMPLEADO',7782,'1982-06-23',169000,0,10),
(7119,'SERRA','DIRECTOR',7839,'1983-11-19',225000,39000,20),
(7322,'GARCIA','EMPLEADO',7119,'1982-10-12',129000,0,20)

INSERT INTO Hospital(Hospital_Cod,Nombre,Direccion,Telefono, Num_Cama) 
VALUES(19,'Provincial','O Donell 50','964-4256',502)

INSERT INTO Hospital(hospital_cod, name, address, tf_number, beds) 
VALUES(18,'General','Atocha s/n','595-3111',987)

INSERT INTO Hospital(hospital_cod, name, address, tf_number, beds) 
VALUES(22,'La Paz','Castellana 1000','923-5411',412)

INSERT INTO Hospital(hospital_cod, name, address, tf_number, beds) 
VALUES(45,'San Carlos','Ciudad Universitaria','597-1500',845)

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(22,386,'Cabeza D.','Psiquiatria');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(22,398,'Best D.','Urologia')

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(19,435,'Lopez A.','Cardiologia');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(22,453,'Galo D.','Pediatria');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(45,522,'Adams C.','Neurologia');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(18,585,'Miller G.','Ginecologia');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(45,607,'Chuki P.','Pediatria');

INSERT INTO Doctor(hospital_cod, doctor_no, surname, speciality) 
VALUES(18,982,'Cajal R.','Cardiologia');

INSERT INTO SALA VALUES(1,22,'Recuperacion',10)
INSERT INTO SALA VALUES(1,45,'Recuperacion',15)
INSERT INTO SALA VALUES(2,22,'Maternidad',34)
INSERT INTO SALA VALUES(2,45,'Maternidad',24)
INSERT INTO SALA VALUES(3,19,'Cuidados Intensivos',21)
INSERT INTO SALA VALUES(3,18,'Cuidados Intensivos',10)
INSERT INTO SALA VALUES(4,18,'Cardiologia',53)
INSERT INTO SALA VALUES(4,45,'Cardiologia',55)
INSERT INTO SALA VALUES(6,19,'Psiquiatricos',67)
INSERT INTO SALA VALUES(6,22,'Psiquiatricos',118)

INSERT INTO Plantilla(hospital_cod, sala_cod, empleado_no, surname, performance, T, salary)
VALUES
(22,6,1009,'Higueras D.','Enfermera','T',200500),
(45,4,1280,'Amigo R.','Interino','N',221000),
(19,6,3106,'Hernandez','Enfermero','T',275000),
(19,6,3754,'Diaz B.','Enfermera','T',226200),
(22,1,6065,'Rivera G.','Enfermera','N',162600),
(18,4,6357,'Karplus W.','Interino','T',337900),
(22,1,7379,'Carlos R.','Enfermera','T',211900),
(22,6,8422,'Bocina G.','Enfermero','M',183800),
(45,1,8526,'Frank H.','Enfermera','T',252200),
(22,2,9901,'Nandez C.','Interino','M',221000)

INSERT INTO Enfermo(inscription, surname, direction, born_date, S, NSS)
VALUES
(10995,'Laguia M.','Goya 20','16-may-56','M',280862422),
(14024,'Fernandez M.','Recoletos 50','21-may-60','F',284991452),
(18004,'Serrano V.','Alcala 12','23-jun-67','F',321790059),
(36658,'Domin S.','Mayor 71','01-ene-42','M',160654471),
(38702,'Neal R.','Orense 11','18-jun-40','F',380010217),
(39217,'Cervantes M.','Peran 38','29-feb-52','M',440294390),
(59076,'Miller B.','Lopez de Hoyos 2','16-sep-45','F',311969044),
(63827,'Ruiz P.','Ezquerdo 103','26-dic-80','M',100973253),
(64823,'Fraiser A.','Soto 3','10-jul-80','F',285201776),
(74835,'Benitez E.','Argentina','05-oct-57','M',154811767)
