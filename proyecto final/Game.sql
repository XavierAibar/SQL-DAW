--Tablas
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
  id BIGINT,
  gendre VARCHAR(max) NOT NULL,
  name VARCHAR(max) NOT NULL,
  multiplayer BIT NOT NULL,
  release_date DATE NOT NULL,
  pegi VARCHAR(2) NOT NULL,
  ost BIGINT,
  company BIGINT,
  CONSTRAINT pk_videogames PRIMARY KEY (id),
  CONSTRAINT ck_videogames_pegi CHECK (pegi = '3' OR pegi = '7' OR pegi = '12' OR pegi = '16' OR pegi = '18'),
  CONSTRAINT fk_videogames_ost FOREIGN KEY (ost) REFERENCES ost(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_videogame_company FOREIGN KEY (company) REFERENCES companies(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE characters
(
  id BIGINT,
  name VARCHAR(max) NOT NULL,
  age INTEGER NOT NULL,
  is_main BIT NOT NULL,
  is_alive BIT NOT NULL,
  CONSTRAINT pk_character PRIMARY KEY (id),
);

CREATE TABLE is_in
(
  videogame BIGINT,
  console BIGINT,
  CONSTRAINT pk_is_in PRIMARY KEY (videogame, console),
  CONSTRAINT fk_console_is_in FOREIGN KEY (console) REFERENCES consoles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_videogame_is_in FOREIGN KEY (videogame) REFERENCES videogames(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE has_characters
(
  videogame BIGINT,
  character BIGINT,
  CONSTRAINT pk_has_char PRIMARY KEY (videogame, character),
  CONSTRAINT fk_character_has FOREIGN KEY (character) REFERENCES characters(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_videogame_has FOREIGN KEY (videogame) REFERENCES videogames(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE uses_ost
(
  ost BIGINT,
  song BIGINT,
  CONSTRAINT pk_uses_ost PRIMARY KEY (ost, song),
  CONSTRAINT fk_ost_uses FOREIGN KEY (ost) REFERENCES ost(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_music_from_ost FOREIGN KEY (song) REFERENCES songs(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sells_consoles
(
  shop BIGINT,
  console BIGINT,
  worker BIGINT,
  CONSTRAINT pk_sells_consoles PRIMARY KEY (shop, console, worker),
  CONSTRAINT fk_shop_sells_console FOREIGN KEY (shop) REFERENCES shops (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_console_is_sold FOREIGN KEY (console) REFERENCES consoles (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_worker_sells_console FOREIGN KEY (worker) REFERENCES workers (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sells_videogames
(
  shop BIGINT,
  videogame BIGINT,
  worker BIGINT,
  CONSTRAINT pk_sells_videogame PRIMARY KEY (shop, videogame, worker),
  CONSTRAINT fk_shop_sells_videogame FOREIGN KEY (shop) REFERENCES shops (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_videogame_is_sold FOREIGN KEY (videogame) REFERENCES videogames (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_worker_sells_videogame FOREIGN KEY (worker) REFERENCES workers (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE logs
(
  id BIGINT IDENTITY(1,1),
  at TIME NOT NULL,
  message VARCHAR(max) NOT NULL,
  CONSTRAINT pk_id_logs PRIMARY KEY (id) 
);


--Funciones

CREATE OR ALTER PROCEDURE log (@message VARCHAR(max)) AS
BEGIN
	INSERT INTO logs (message, at) VALUES (@message, GETDATE());
END

