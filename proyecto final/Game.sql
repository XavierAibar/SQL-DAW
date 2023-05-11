CREATE TABLE shops
(
  id BIGINT,
  location VARCHAR(max) NOT NULL,
  CONSTRAINT pk_id_shop PRIMARY KEY (id)
);

CREATE TABLE workers
(
  id BIGINT,
  sales INT,
  name VARCHAR(max) NOT NULL,
  dni VARCHAR(max),
  age INT NOT NULL,
  born_date DATE NOT NULL,
  shop BIGINT,
  CONSTRAINT pk_id_workers PRIMARY KEY (id),
  CONSTRAINT uk_dni_workers UNIQUE(id),
  CONSTRAINT ck_age_workers CHECK ( age BETWEEN 16 AND 70),
  CONSTRAINT fk_shop_workers FOREIGN KEY (shop) REFERENCES shops(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE is_boss 
(
  employee BIGINT,
  boss BIGINT,
  CONSTRAINT pk_is_boss PRIMARY KEY (employee, boss),
  CONSTRAINT fk_emp_boss FOREIGN KEY (employee) REFERENCES workers(id),
  CONSTRAINT fk_boss_boss FOREIGN KEY (boss) REFERENCES workers(id),
);

CREATE TABLE ost
(
  id BIGINT,
  CONSTRAINT pk_ost PRIMARY KEY (id)
);

CREATE TABLE songs
(
  id BIGINT,
  name VARCHAR(max) NOT NULL,
  band VARCHAR(max) DEFAULT 'Anonymous',
  release_date DATE NOT NULL,
  minutes FLOAT NOT NULL,
  CONSTRAINT pk_songs PRIMARY KEY(id)
);

CREATE TABLE companies
(
  id BIGINT,
  name VARCHAR(max) NOT NULL,
  owner VARCHAR(max) NOT NULL,
  foundation_date DATE NOT NULL,
  CONSTRAINT pk_company PRIMARY KEY (id)
);

CREATE TABLE consoles
(
  id BIGINT,
  name VARCHAR(max) NOT NULL,
  stock INTEGER,
  release_date DATE NOT NULL,
  company BIGINT,
  CONSTRAINT pk_consoles PRIMARY KEY (id),
  CONSTRAINT fk_console_company FOREIGN KEY (company) REFERENCES companies(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE videogames
(
  
);
