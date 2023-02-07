CREATE TABLE profesor 
(
  dni VARCHAR(9),
  name VARCHAR(20),
  surnames VARCHAR(50),
  age BIGINT,
  forma_de_pago VARCHAR(64),
  CONSTRAINT pk_table_dni PRIMARY KEY (dni),
);
ALTER TABLE profesor
ADD dispatch VARCHAR(20);

ALTER TABLE profesor
ADD language VARCHAR(20);

ALTER TABLE profesor
DROP COLUMN forma_de_pago;

ALTER TABLE profesor
ALTER COLUMN age INT;

/*Ejercicio 2*/

ALTER TABLE profesor
ALTER COLUMN age INT NOT NULL;

ALTER TABLE profesor
ADD CONSTRAINT uk_dispatch UNIQUE(dispatch);

ALTER TABLE profesor
ADD CONSTRAINT ck_age CHECK(age > 0);

ALTER TABLE profesor
ADD CONSTRAINT df_language DEFAULT 'Español' FOR language;

ALTER TABLE profesor
ALTER COLUMN age INT;

ALTER TABLE profesor
DROP CONSTRAINT uk_dispatch;
