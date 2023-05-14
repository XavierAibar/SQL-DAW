--Tablas
CREATE TABLE shops
(
  id BIGINT IDENTITY(1,1),
  location VARCHAR(max) NOT NULL,
  CONSTRAINT pk_id_shop PRIMARY KEY (id)
);

CREATE TABLE workers
(
  id BIGINT IDENTITY(1,1),
  sales INT,
  name VARCHAR(max) NOT NULL,
  dni CHAR(9),
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

CREATE TABLE songs
(
  id BIGINT IDENTITY(1,1),
  name VARCHAR(max) NOT NULL,
  band VARCHAR(max) DEFAULT 'Unknown',
  release_date DATE NOT NULL,
  minutes FLOAT NOT NULL,
  CONSTRAINT pk_songs PRIMARY KEY(id)
);

CREATE TABLE companies
(
  id BIGINT IDENTITY(1,1),
  name VARCHAR(max) NOT NULL,
  owner VARCHAR(max) NOT NULL,
  foundation_date DATE NOT NULL,
  CONSTRAINT pk_company PRIMARY KEY (id)
);

CREATE TABLE consoles
(
  id BIGINT IDENTITY(1,1),
  name VARCHAR(max) NOT NULL,
  stock INTEGER,
  release_date DATE NOT NULL,
  company BIGINT,
  CONSTRAINT pk_consoles PRIMARY KEY (id),
  CONSTRAINT fk_console_company FOREIGN KEY (company) REFERENCES companies(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE videogames
(
  id BIGINT IDENTITY(1,1),
  gendre VARCHAR(max) NOT NULL,
  name VARCHAR(max) NOT NULL,
  multiplayer BIT NOT NULL,
  release_date DATE NOT NULL,
  pegi VARCHAR(2) NOT NULL,
  company BIGINT,
  stock INTEGER
  CONSTRAINT pk_videogames PRIMARY KEY (id),
  CONSTRAINT ck_videogames_pegi CHECK (pegi = '3' OR pegi = '7' OR pegi = '12' OR pegi = '16' OR pegi = '18'),
  CONSTRAINT fk_videogame_company FOREIGN KEY (company) REFERENCES companies(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE characters
(
  id BIGINT IDENTITY(1,1),
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
  CONSTRAINT fk_ost_uses FOREIGN KEY (ost) REFERENCES videogames(id) ON DELETE CASCADE ON UPDATE CASCADE,
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


--Inserts
CREATE OR ALTER PROCEDURE log (@message VARCHAR(max)) AS
BEGIN
	INSERT INTO logs (message, at) VALUES (@message, GETDATE());
END

CREATE OR ALTER PROCEDURE insert_character (@name VARCHAR(max), @age INTEGER, @is_main BIT, @is_alive BIT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO characters (name, age, is_main, is_alive) VALUES (@name, @age, @is_main, @is_alive);
    SET @message = CONCAT('Se ha añadido el personaje ', @name ,' con id ',(SELECT COUNT(*) FROM characters), ', su edad es ', @age, 
                          IIF(@is_main = 1, ', es un personaje principal', ', es un personaje secundario'), 
                          IIF(@is_alive = 1, ' y está vivo', ' y está muerto.'));
    EXEC log @message;
END


CREATE OR ALTER PROCEDURE insert_company (@name VARCHAR(max), @owner VARCHAR(max), @foundation DATE) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO companies (name, owner, foundation_date) VALUES (@name, @owner, @foundation);
    set @message = CONCAT('Se ha añadido la empresa con id ',(SELECT COUNT(*) FROM companies), ' su owner es ', @owner, ' y fué fundado el ', @foundation);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_consoles (@name VARCHAR(max), @stock INTEGER, @release_date DATE, @company BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO consoles (name, stock, release_date, company) VALUES (@name, @stock, @release_date, @company);
    set @message = CONCAT('Se ha añadido la ' , @name, ' con id ',(SELECT COUNT(*) FROM consoles),
                          ' Que salió en ', @release_date, ' se tienen ', @stock, 
                          'consolas en stock y pertenece a ', @company);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_shop (@location VARCHAR(max)) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO shops (location) VALUES (@location);
    set @message = CONCAT('Se ha añadido la tienda con id ',(SELECT COUNT(*) FROM shops), ' ubicado en ', @location);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_videogame (@gendre VARCHAR(max), @name VARCHAR(max), @multiplayer BIT, @release_date DATE, @pegi VARCHAR(max), @company BIGINT, @stock INTEGER) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO videogames (gendre, name, multiplayer, release_date, pegi, company, stock) VALUES (@gendre, @name, @multiplayer, @release_date, @pegi, @company, @stock);
    set @message = CONCAT('Se ha añadido la videojuego ', @name , ' con id ',(SELECT COUNT(*) FROM videogames), 
                          IIF(@multiplayer = 1, ', tiene online', ', no tiene online'), ' salió el ', @release_date, ' Tiene un pegi ', @pegi,' hay en stock ', @stock ,' copias, y pertenece a ', @company); 
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE connect_characters (@videogame BIGINT, @character BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO has_characters (videogame, character) VALUES (@videogame, @character);
    set @message = CONCAT('Se ha conectado el personaje ', (SELECT name FROM characters WHERE id = @character),
                          ' con el id ', @character, ' en el videojuego ', (SELECT name FROM consoles WHERE id = @videogame), ' y tiene el id ', @videogame);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_videogame_in_consoles (@videogame BIGINT, @console BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO is_in (videogame, console) VALUES (@videogame, @console);
    set @message = CONCAT('El videojuego ', (SELECT name FROM videogames WHERE id = @videogame),
                          ' con el id ', @videogame, ' está vinculado con la consola ', (SELECT name FROM consoles WHERE id = @console), ' y tiene el id ', @console);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_song (@name VARCHAR(max), @band VARCHAR(max), @release_date DATE, @minutes FLOAT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    INSERT INTO songs (name, band, release_date, minutes) VALUES (@name, @band, @release_date, @minutes);
    SET @message = CONCAT('La cancion con el nombre ', @name, 'con el id ',(SELECT COUNT(*) FROM songs) , ', del grupo ', @band, ', salió en ', @release_date, ' y dura ', @minutes);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_workers (@sales INTEGER, @name VARCHAR(max), @dni CHAR(9), @age INTEGER, @born_date DATE, @shop BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    INSERT INTO workers (sales, name, dni, age, born_date, shop) VALUES (@sales, @name, @dni, @age, @born_date, @shop);
    SET @message = CONCAT('El trabajador con el nombre ', @name, 'con el id ',(SELECT COUNT(*) FROM workers) , ', con el dni ', @dni, ', tiene ', @age, ' años, nació el
                          ', @born_date, ' y pertenece a la tienda con el id ', @shop);
    EXEC log @message;
END


CREATE OR ALTER PROCEDURE insert_boss (@employee BIGINT, @boss BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO is_boss (employee, boss) VALUES (@employee, @boss);
    set @message = CONCAT('El empleado ', (SELECT name FROM workers WHERE id = @employee), ' con el id ', @employee, ' tiene el jefe ', (SELECT name FROM workers WHERE id = @boss),
                          ' y tiene el id ', @boss);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_console_sold (@shop BIGINT, @console BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO sells_consoles (shop, console, worker) VALUES (@shop, @console, @worker);
    set @message = CONCAT('La consola ', (SELECT name FROM consoles WHERE id = @console),
                          ' con el id ', @console, ' se ha vendido en la tienda con id ', @shop, ' y ha sido vendida por ',
                          (SELECT name FROM workers WHERE id = @worker), ' con id ', @worker);
    EXEC log @message;
	UPDATE consoles
	SET stock = stock - 1
	WHERE id = @console;
    
    UPDATE workers
	SET sales = sales + 1
	WHERE id = @worker;
END

CREATE OR ALTER PROCEDURE insert_videogame_sold (@shop BIGINT, @videogame BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO sells_videogames (shop, videogame, worker) VALUES (@shop, @videogame, @worker);
    set @message = CONCAT('El juego ', (SELECT name FROM videogame WHERE id = @videogame),
                          ' con el id ', @videogame, ' se ha vendido en la tienda con id ', @shop, ' y ha sido vendida por ',
                          (SELECT name FROM workers WHERE id = @worker), ' con id ', @worker);
    EXEC log @message;
	UPDATE videogames
	SET stock = stock - 1
	WHERE id = @videogame;
    
    UPDATE workers
	SET sales = sales + 1
	WHERE id = @worker;    
END

CREATE OR ALTER PROCEDURE insert_boss (@ost BIGINT, @song BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO uses_ost (ost, song) VALUES (@ost, @song);
    set @message = CONCAT('La cancion ', (SELECT name FROM songs WHERE id = @song), ' con el id ', @song, ' en el videojuego ', (SELECT name FROM videogames WHERE id = @ost),
                          ' y tiene el id ', @ost);
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_character (@character BIGINT) AS
BEGIN
	DELETE FROM characters
    WHERE id = @character
END








--delete

CREATE OR ALTER PROCEDURE delete_character (@character BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM characters
    WHERE id = @character
    SET @message = CONCAT('Se ha eliminado el personaje con nombre ', (SELECT name FROM characters WHERE id = @character), ' y con id ', @character)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_company (@company BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM companies
    WHERE id = @company
    SET @message = CONCAT('Se ha eliminado la empresa con nombre ', (SELECT name FROM companies WHERE id = @company), ' y con id ', @company)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_console (@console BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM consoles
    WHERE id = @console
    SET @message = CONCAT('La consola con nombre ', (SELECT name FROM consoles WHERE id = @console), ' y con id ', @console, ' ha sido descatalogada')
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_char_from_game (@character BIGINT, @game BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM has_characters
    WHERE character = @character AND videogame = @game
    SET @message = CONCAT('Se ha eliminado el personaje con nombre ', (SELECT name FROM characters WHERE id = @character), ' y con id ', @character, ' del
                          videjuego ', (SELECT name FROM videogames WHERE id = @game), ' con id ', @game)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_boss (@worker BIGINT, @boss BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM is_boss
    WHERE employee = @worker AND boss = @boss
    SET @message = CONCAT('El jefe ', (SELECT name FROM workers WHERE id = @boss), ' y con id ', @boss, ' ha dejado de ser jefe de ',
                          (SELECT name FROM workers WHERE id = @worker), ' con id ', @worker)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_videogame_from_console (@videogame BIGINT, @console BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM is_in
    WHERE videogame = @videogame AND console = @console
    SET @message = CONCAT('El videojuego ', (SELECT name FROM videogames WHERE id = @videogame), ' y con id ', @videogame, ' ya no es jugable en la ',
                          (SELECT name FROM consoles WHERE id = @console), ', consola con el id ', @console)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE empty_logs AS
BEGIN
	DELETE FROM logs
END

CREATE OR ALTER PROCEDURE delete_console_sold (@shop BIGINT, @console BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM sells_consoles
    WHERE shop = @shop AND console = @console AND worker = @worker
    SET @message = CONCAT('Una consola ', (SELECT name FROM consoles WHERE id = @console), ' y con id ', @console, ' ha sido rembolsada ',
                         ', de la tienda con id  ', @shop)
    EXEC log @message;
    
    UPDATE consoles
	SET stock = stock + 1
	WHERE id = @console;
    
    UPDATE workers
	SET sales = sales - 1
	WHERE id = @worker;      
END


CREATE OR ALTER PROCEDURE delete_videogame_sold (@shop BIGINT, @videogame BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM sells_videogames
    WHERE shop = @shop AND videogame = @videogame AND worker = @worker
    SET @message = CONCAT((SELECT name FROM videogames WHERE id = @videogame), ' con id ', @videogame, ' ha sido rembolsado',
                         ', de la tienda con id  ', @shop)
    EXEC log @message;
    
    UPDATE videogames
	SET stock = stock + 1
	WHERE id = @videogame;
    
    UPDATE workers
	SET sales = sales - 1
	WHERE id = @worker;      
END

CREATE OR ALTER PROCEDURE delete_shop (@shop BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM shops
    WHERE id = @shop
    SET @message = CONCAT('La tienda situada en ', (SELECT location FROM shops WHERE id = @shop), ' y con id ', @shop, ' ha sido eliminada')
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_song (@song BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM songs
    WHERE id = @song
    SET @message = CONCAT('La cancion llamada ', (SELECT name FROM songs WHERE id = @song), ' y con id ', @song, ' ha sido eliminada')
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_videogame_from_console (@videogame BIGINT, @song BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM uses_ost
    WHERE ost = @videogame AND song = @song
    SET @message = CONCAT('El videojuego ', (SELECT name FROM videogames WHERE id = @videogame), ' y con id ', @videogame, ' ya no tiene en su ost la cancion ',
                          (SELECT name FROM songs WHERE id = @song), ', consola con el id ', @song)
    EXEC log @message;
END


CREATE OR ALTER PROCEDURE delete_videogame (@videogame BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM videogames
    WHERE id = @videogame
    SET @message = CONCAT('El videojuego con nombre ', (SELECT name FROM videogames WHERE id = @videogame), ' y con id ', @videogame, ' ha sido descatalogada')
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE delete_worker (@worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	DELETE FROM workers
    WHERE id = @worker
    SET @message = CONCAT('El trabajador llamado ', (SELECT name FROM workers WHERE id = @worker), ' y con id ', @worker, ' ha sido despedido')
    EXEC log @message;
END



--Ver tablas

CREATE OR ALTER FUNCTION view_characters()
RETURNS TABLE
AS
RETURN SELECT * FROM characters;

CREATE OR ALTER FUNCTION view_consoles()
RETURNS TABLE
AS
RETURN SELECT * FROM consoles;

CREATE OR ALTER FUNCTION view_bosses()
RETURNS TABLE
AS
RETURN SELECT * FROM is_boss;

CREATE OR ALTER FUNCTION view_companies()
RETURNS TABLE
AS
RETURN SELECT * FROM companies;

CREATE OR ALTER FUNCTION view_has_characters()
RETURNS TABLE
AS
RETURN SELECT * FROM has_characters;

CREATE OR ALTER FUNCTION view_is_in() RETURNS TABLE AS
RETURN SELECT * FROM is_in;

CREATE OR ALTER FUNCTION view_logs()
RETURNS TABLE
AS
RETURN SELECT * FROM logs;

CREATE OR ALTER FUNCTION view_sells_consoles()
RETURNS TABLE
AS
RETURN SELECT * FROM sells_consoles;

CREATE OR ALTER FUNCTION view_sells_videogames()
RETURNS TABLE
AS
RETURN SELECT * FROM sells_videogames;

CREATE OR ALTER FUNCTION view_shops()
RETURNS TABLE
AS
RETURN SELECT * FROM shops;

CREATE OR ALTER FUNCTION view_songs()
RETURNS TABLE
AS
RETURN SELECT * FROM songs;

CREATE OR ALTER FUNCTION view_uses_ost()
RETURNS TABLE
AS
RETURN SELECT * FROM uses_ost;

CREATE OR ALTER FUNCTION view_videogames()
RETURNS TABLE
AS
RETURN SELECT * FROM videogames;

CREATE OR ALTER FUNCTION view_workers()
RETURNS TABLE
AS
RETURN SELECT * FROM workers;

--Inserts obligatorios

EXEC insert_shop 'Alicante'
EXEC insert_shop 'Madrid'
EXEC insert_shop 'Sevilla'
EXEC insert_shop 'Badajoz'
EXEC insert_shop 'Barcelona'
EXEC insert_shop 'A Coruña'
EXEC insert_shop 'Bilbao'


EXEC insert_character 'Nasus', 100, 0, 1
EXEC insert_character 'Mordekaiser', 534, 0, 0
EXEC insert_character 'Yone', 25, 1, 0
EXEC insert_character 'Volibear', 1500, 1, 1
EXEC insert_character 'Genji', 35, 1, 1
EXEC insert_character 'Hanzo', 35, 1, 1
EXEC insert_character 'Roadhog', 48, 0, 1
EXEC insert_character 'Reinhardt', 61, 1, 1
EXEC insert_character 'Master Chief', 25, 1, 1
EXEC insert_character 'Cortana', 19, 1, 0
EXEC insert_character 'Inquisidor', 18, 0, 1
EXEC insert_character 'Arthur Morgan', 36, 1, 0
EXEC insert_character 'John Marston', 34, 1, 0
EXEC insert_character 'Sadie', 24, 0, 1
EXEC insert_character 'Dutch Van Der Linde', 57, 1, 0
EXEC insert_character 'Lenny', 22, 0, 0
EXEC insert_character 'Nathan Drake', 33, 1, 1
EXEC insert_character 'Sulivan', 67, 1, 0
EXEC insert_character 'Elena Fisher', 31, 1, 1


EXEC insert_company 'Microsoft', 'Bill Gates', '1975-4-4'
EXEC insert_company 'Sony', 'Kenichiro Yoshida', '1946-5-7'
EXEC insert_company 'Nintendo', 'Tatsumi Kimishima', '1889-9-23'
EXEC insert_company 'Blizzard', 'Myke Ibarra', '2016-5-24'
EXEC insert_company 'Riot Games', 'Nicolo Laurent', '2006-9-1'
EXEC insert_company 'Bungie', 'Jason Jones', '1991-2-5'
EXEC insert_company 'Rockstar Games', 'Dan House', '1998-12-1'
EXEC insert_company 'Naughty Dog', 'Andy Gavin', '1984-5-6'


EXEC insert_consoles 'XBOX', 10000, '2020-11-10', 1
EXEC insert_consoles 'Play Station', 10000, '2020-11-12', 2
EXEC insert_consoles 'Nintendo Switch', 10000, '2017-3-3', 3

EXEC insert_videogame 'Shooter', 'Overwatch', 1, '2016-5-24', '12', 4, 10000
EXEC insert_videogame 'Triple A', 'Red Dead Redemption', 0, '2010-5-18', '18', 7, 10000
EXEC insert_videogame 'Triple A', 'Red Dead Redemption 2', 0, '2018-10-26', '18', 7, 10000
EXEC insert_videogame 'Shooter', 'Halo 3', 1, '2007-9-25', '16', 6, 10000
EXEC insert_videogame 'Shooter', 'Halo 4', 1, '2012-11-25', '16', 6, 10000
EXEC insert_videogame 'Moba', 'League Of Legends', 1, '2009-01-15', '12', 5, 10000
EXEC insert_videogame 'Aventura', 'Uncharted 3', 0, '2011-11-2', '18', 8, 10000
EXEC insert_videogame 'Aventura', 'Uncharted 4', 0, '2016-5-10', '18', 8, 10000


SELECT dbo.view_workers();
SELECT message FROM logs

EXEC empty_logs
