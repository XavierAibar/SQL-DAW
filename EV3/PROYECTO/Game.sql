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
  gender CHAR(1) NOT NULL,
  age INT NOT NULL,
  born_date DATE NOT NULL,
  shop BIGINT,
  CONSTRAINT pk_id_workers PRIMARY KEY (id),
  CONSTRAINT uk_dni_workers UNIQUE(id),
  CONSTRAINT ck_age_workers CHECK ( age BETWEEN 16 AND 70),
  CONSTRAINT ck_gender_workers CHECK ( gender = 'M' OR gender = 'F'),
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
  band VARCHAR(max),
  release_date DATE NOT NULL,
  seconds INTEGER NOT NULL,
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
  date DATETIME,
  CONSTRAINT pk_sells_consoles PRIMARY KEY (shop, console, worker, date),
  CONSTRAINT fk_shop_sells_console FOREIGN KEY (shop) REFERENCES shops (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_console_is_sold FOREIGN KEY (console) REFERENCES consoles (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_worker_sells_console FOREIGN KEY (worker) REFERENCES workers (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE sells_videogames
(
  shop BIGINT,
  videogame BIGINT,
  worker BIGINT,
  date DATETIME,
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

CREATE OR ALTER PROCEDURE insert_song (@name VARCHAR(max), @band VARCHAR(max), @release_date DATE, @seconds INTEGER) AS
BEGIN
	DECLARE @message VARCHAR(max);
    INSERT INTO songs (name, band, release_date, seconds) VALUES (@name, @band, @release_date, @seconds);
    SET @message = CONCAT('La cancion con el nombre ', @name, 'con el id ',(SELECT COUNT(*) FROM songs) , ', del grupo ', @band, ', salió en ', @release_date, ' y dura ', @seconds, ' segundos.');
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE insert_workers (@sales INTEGER, @name VARCHAR(max), @dni CHAR(9), @age INTEGER, @gender CHAR(1), @born_date DATE, @shop BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    INSERT INTO workers (sales, name, dni, age, gender, born_date, shop) VALUES (@sales, @name, @dni, @age, @gender, @born_date, @shop);
    SET @message = CONCAT(IIF (@gender = 'M','El trabajador ', 'La trabajadora '), 'con el nombre ', @name, 'con el id ',(SELECT COUNT(*) FROM workers) , ' y con el dni ', @dni, ', tiene ', @age, ' años, nació el
                          ', @born_date, ' y pertenece a la tienda con el id ', @shop);
    EXEC log @message;
END


CREATE OR ALTER PROCEDURE insert_boss (@employee BIGINT, @boss BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    IF ((SELECT shop FROM workers WHERE id = @employee) = (SELECT shop FROM workers WHERE id = @boss))
    BEGIN
    		INSERT INTO is_boss (employee, boss) VALUES (@employee, @boss);
    		set @message = CONCAT('El empleado ', (SELECT name FROM workers WHERE id = @employee), ' con el id ', @employee, ' tiene el jefe ', (SELECT name FROM workers WHERE id = @boss),
                          ' y tiene el id ', @boss);
    		EXEC log @message;
    END
END

CREATE OR ALTER PROCEDURE insert_console_sold (@shop BIGINT, @console BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    IF (SELECT stock FROM consoles WHERE id = @console) IS NOT NULL
    BEGIN
    	IF (@shop = (SELECT shop FROM workers WHERE id = @worker))
      	BEGIN
        	INSERT INTO sells_consoles (shop, console, worker, date) VALUES (@shop, @console, @worker, GETDATE());
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
    END
    ELSE
    BEGIN
        RAISERROR('No se puede realizar la venta ya que no hay en stock.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END

CREATE OR ALTER PROCEDURE insert_videogame_sold (@shop BIGINT, @videogame BIGINT, @worker BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
    IF (SELECT stock FROM videogames WHERE id = @videogame) IS NOT NULL
    BEGIN	
    	IF (@shop = (SELECT shop FROM workers WHERE id = @worker))
		BEGIN
    		INSERT INTO sells_videogames (shop, videogame, worker, date) VALUES (@shop, @videogame, @worker,GETDATE());
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
	END
    ELSE
    BEGIN
        RAISERROR('No se puede realizar la venta ya que no hay en stock.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END

CREATE OR ALTER PROCEDURE insert_song_on_ost (@ost BIGINT, @song BIGINT) AS
BEGIN
	DECLARE @message VARCHAR(max);
	INSERT INTO uses_ost (ost, song) VALUES (@ost, @song);
    set @message = CONCAT('La cancion ', (SELECT name FROM songs WHERE id = @song), ' con el id ', @song, ' en el videojuego ', (SELECT name FROM videogames WHERE id = @ost),
                          ' y tiene el id ', @ost);
    EXEC log @message;
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

CREATE OR ALTER PROCEDURE delete_console_sold (@shop BIGINT, @console BIGINT, @worker BIGINT, @date DATETIME) AS
BEGIN
    DECLARE @message VARCHAR(max);
    DECLARE @rowCount INT;
    
    DELETE FROM sells_consoles
    WHERE shop = @shop AND console = @console AND worker = @worker AND date LIKE @date;
    
    SET @rowCount = @@ROWCOUNT; -- Almacenar la cantidad de filas eliminadas
    
    IF @rowCount > 0
    BEGIN
        SET @message = CONCAT('Una consola ', (SELECT name FROM consoles WHERE id = @console), ' y con id ', @console, ' ha sido reembolsada ',
                              'de la tienda con id ', @shop);
        
        EXEC log @message;
        
        UPDATE consoles
        SET stock = stock + 1
        WHERE id = @console;
        
        UPDATE workers
        SET sales = sales - 1
        WHERE id = @worker;
    END
     ELSE
    BEGIN
        RAISERROR('No se encontraron ventas para los parámetros especificados.', 16, 1);
    END
END



CREATE OR ALTER PROCEDURE delete_videogame_sold (@shop BIGINT, @videogame BIGINT, @worker BIGINT, @date DATETIME) AS
BEGIN
	DECLARE @message VARCHAR(max);
    DECLARE @rowCount INT;
    
	DELETE FROM sells_videogames
    WHERE shop = @shop AND videogame = @videogame AND worker = @worker AND date LIKE @date
    
    SET @rowCount = @@ROWCOUNT; 
    
    IF @rowCount > 0
    BEGIN
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
    ELSE
    BEGIN
        RAISERROR('No se encontraron ventas para los parámetros especificados.', 16, 1);
    END
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



--Procedures no inserts ni deletes

CREATE OR ALTER PROCEDURE fill_console_stock (@amount INTEGER, @console BIGINT) as
BEGIN
	DECLARE @message VARCHAR(max);
	IF (SELECT stock FROM consoles WHERE id = @console) IS NOT NULL
    BEGIN
		UPDATE consoles
    	SET stock = stock + @amount
    	FROM consoles
    	WHERE id = @console
    END
    
    ELSE
    BEGIN
    	UPDATE consoles
    	SET stock = @amount
    	FROM consoles
    	WHERE id = @console
    END
    SET @message = CONCAT('Se han añadido unas nuevas ', @amount,' consolas con nombre ', (SELECT name FROM consoles WHERE id = @console), ' y con id ', @console)
    EXEC log @message;
END

CREATE OR ALTER PROCEDURE fill_videogame_stock (@amount INTEGER, @videogame BIGINT) as
BEGIN
	DECLARE @message VARCHAR(max);
	IF (SELECT stock FROM videogames WHERE id = @videogame) IS NOT NULL
    BEGIN
		UPDATE videogames
    	SET stock = stock + @amount
    	FROM videogames
    	WHERE id = @videogame
    END
    
    ELSE
    BEGIN
    	UPDATE videogames
    	SET stock = @amount
    	FROM videogames
    	WHERE id = @videogame
    END
    SET @message = CONCAT('Se han añadido unas nuevas ', @amount,' consolas con nombre ', (SELECT name FROM consoles WHERE id = @console), ' y con id ', @console)
    EXEC log @message;
END


CREATE OR ALTER PROCEDURE new_owner (@id BIGINT, @name VARCHAR(max)) AS
BEGIN
    
    UPDATE companies
    set owner = @name
    WHERE id = @id
END

CREATE OR ALTER PROCEDURE kill_character (@id BIGINT) AS 
BEGIN
	IF (SELECT is_alive FROM characters WHERE id = @id) = 1
    BEGIN
        UPDATE characters
        set is_alive = 0
        WHERE id = @id
    END
    ELSE
    RAISERROR('El personaje ya está muerto.', 1, 16)
END


CREATE OR ALTER PROCEDURE change_workplace (@worker BIGINT, @shop BIGINT) AS
BEGIN
	UPDATE workers
    set shop = @shop
    WHERE id = @worker
END


--Funciones 


--DROP FUNCTION most_seller_worker
CREATE FUNCTION most_seller_worker()
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @name VARCHAR(max);
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM workers
    WHERE sales > 0;

    IF @count > 0
    BEGIN
        SET @name = (SELECT TOP 1 name
                     FROM workers
                     WHERE sales > 0
                     ORDER BY sales DESC);
    END
    ELSE
    BEGIN
        SET @name = 'No se ha vendido nada aún';
    END
    
    RETURN @name;
END;


--DROP FUNCTION least_seller_worker
CREATE FUNCTION least_seller_worker() RETURNS VARCHAR(max) AS
BEGIN
	DECLARE @name VARCHAR(max);
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM workers
    WHERE sales > 0;

    IF @count > 0
    BEGIN
        SET @name = (SELECT TOP 1 name
                     FROM workers
                     WHERE sales > 0
                     ORDER BY sales);
    END
    ELSE
    BEGIN
        SET @name = 'No se ha vendido nada aún';
    END
    
    RETURN @name;
END



--DROP FUNCTION avg_songtime_from_game
CREATE FUNCTION avg_songtime_from_game (@videogame BIGINT) RETURNS INTEGER AS
BEGIN 
RETURN 
(
  			SELECT avg(seconds)
            FROM videogames v INNER JOIN uses_ost ost on v.id = ost.ost
            INNER JOIN songs s ON ost.song = s.id
            WHERE v.id = @videogame
);
END



CREATE FUNCTION most_sold_console () RETURNS @result TABLE (consola VARCHAR(20), cantidad_vendida INT) AS
BEGIN
	INSERT INTO @result (consola, cantidad_vendida)
	SELECT TOP 1 c.name, COUNT(*)
	FROM sells_consoles sc INNER JOIN consoles c ON sc.console = c.id
	GROUP BY sc.console, c.name
	ORDER BY COUNT(*) DESC

	RETURN;
END;

CREATE FUNCTION most_sold_videogame () RETURNS @result TABLE (videojuego VARCHAR(20), cantidad_vendida INT) AS
BEGIN
	INSERT INTO @result (videojuego, cantidad_vendida)
	SELECT TOP 1 v.name, COUNT(*)
	FROM sells_videogames sv INNER JOIN videogames v ON sv.videogame = v.id
	GROUP BY sv.videogame, v.name
	ORDER BY COUNT(*) DESC

	RETURN;
END;

CREATE FUNCTION most_sold_videogame () RETURNS @result TABLE (videojuego VARCHAR(20), cantidad_vendida INT) AS
BEGIN
	INSERT INTO @result (videojuego, cantidad_vendida)
	SELECT TOP 1 v.name, COUNT(*)
	FROM sells_videogames sv INNER JOIN videogames v ON sv.videogame = v.id
	GROUP BY sv.videogame, v.name
	ORDER BY COUNT(*) DESC

	RETURN;
END;


CREATE FUNCTION first_company_ever() RETURNS VARCHAR(max) AS
BEGIN
RETURN 
(
  			SELECT TOP 1 name 
            FROM companies
            ORDER BY foundation_date
);
END

CREATE FUNCTION first_console_ever() RETURNS VARCHAR(max) AS
BEGIN
	RETURN (SELECT TOP 1 name 
            FROM consoles
            ORDER BY release_date)
END

CREATE FUNCTION first_videogame_ever() RETURNS VARCHAR(max) AS
BEGIN
RETURN     
(
  			SELECT TOP 1 name 
            FROM videogames
            ORDER BY release_date
);
END

CREATE FUNCTION last_company_ever() RETURNS VARCHAR(max) AS
BEGIN
RETURN 
(
  			SELECT TOP 1 name 
            FROM companies
            ORDER BY foundation_date DESC
);
END

CREATE FUNCTION last_console_ever() RETURNS VARCHAR(max) AS
BEGIN
RETURN 
(
  			SELECT TOP 1 name 
            FROM consoles
            ORDER BY release_date DESC
);
END

CREATE FUNCTION last_videogame_ever() RETURNS VARCHAR(max) AS
BEGIN
RETURN 
(			
  			SELECT TOP 1 name 
            FROM videogames
            ORDER BY release_date DESC
);
END

CREATE FUNCTION consoles_sold_today() RETURNS INTEGER AS
BEGIN   
RETURN 
(
    SELECT COUNT(*)
    FROM sells_consoles
    WHERE CONVERT(DATE, date) = CONVERT(DATE, GETDATE())
);    
END

CREATE FUNCTION videogames_sold_today() RETURNS INTEGER AS
BEGIN   
    RETURN 
    (SELECT COUNT(*)
    FROM sells_videogames
    WHERE CONVERT(DATE, date) = CONVERT(DATE, GETDATE()));    
END

CREATE FUNCTION company_owner(@id BIGINT) RETURNS VARCHAR(max) AS
BEGIN
RETURN
(
     SELECT owner
     FROM companies
     WHERE id = @id
);
END

     
CREATE FUNCTION mains_from_game(@id BIGINT)
RETURNS TABLE
AS
RETURN
(
	SELECT c.name
	FROM videogames v INNER JOIN has_characters hc on v.id = hc.videogame INNER JOIN characters c ON hc.character = c.id
	WHERE c.is_main = 1 AND v.id = @id
);  

CREATE FUNCTION dead_characters_from_game(@id BIGINT)
RETURNS TABLE
AS
RETURN
(
	SELECT c.name
	FROM videogames v INNER JOIN has_characters hc on v.id = hc.videogame INNER JOIN characters c ON hc.character = c.id
	WHERE c.is_alive = 0 AND v.id = @id
);  





--Triggers

CREATE TRIGGER set_unknown_name ON songs AFTER INSERT
AS
BEGIN
    UPDATE songs
    SET band = 'Desconocida'
    WHERE band IS NULL;
END



CREATE TRIGGER set_console_stock_to_null ON consoles AFTER UPDATE
AS
BEGIN
	UPDATE consoles
    SET stock = NULL
    FROM consoles c INNER JOIN inserted i ON c.id = i.id
    WHERE i.stock = 0
END



CREATE TRIGGER set_videogame_stock_to_null ON videogames AFTER UPDATE
AS
BEGIN
	UPDATE videogames
    SET stock = NULL
    FROM videogames v INNER JOIN inserted i ON v.id = i.id
    WHERE i.stock = 0
END


CREATE OR ALTER TRIGGER prevent_same_hierarchy ON is_boss INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN is_boss b ON i.boss = b.employee
        INNER JOIN workers w ON i.employee = w.id AND b.boss = w.id
    )
    BEGIN
        RAISERROR('No se puede asignar a alguien como jefe de su propio jefe.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO is_boss (employee, boss)
    SELECT employee, boss
    FROM inserted;
END


CREATE TRIGGER prevent_videogame_before_company ON videogames INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i INNER JOIN companies c ON i.company = c.id
        WHERE i.release_date < c.foundation_date
    )
    BEGIN
        RAISERROR('No se puede asignar un videojuego a una empresa si el videojuego salió antes que la empresa se fundara.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO videogames (gendre, name, multiplayer, release_date, pegi, company, stock)
    SELECT gendre, name, multiplayer, release_date, pegi, company, stock
    FROM inserted;
END

CREATE TRIGGER prevent_console_before_company ON consoles INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i INNER JOIN companies c ON i.company = c.id
        WHERE i.release_date < c.foundation_date
    )
    BEGIN
        RAISERROR('No se puede asignar una consola a una empresa si la consola salió antes que la empresa se fundara.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO consoles (name, stock, release_date, company)
    SELECT name, stock, release_date, company
    FROM inserted;
END






--Cursores 

CREATE FUNCTION get_song_names_by_videogame(@videogameId BIGINT)
RETURNS @songNames TABLE (Name VARCHAR(max))
AS
BEGIN
    DECLARE @songName VARCHAR(max);
    
    DECLARE songCursor CURSOR FOR
    SELECT Name
    FROM songs s
    INNER JOIN uses_ost uo ON uo.song = s.id
    WHERE uo.ost = @videogameId;
    
    OPEN songCursor;
        
    WHILE 1=1
    BEGIN
        FETCH NEXT FROM songCursor INTO @songName;
      	IF @@FETCH_STATUS <> 0
	      	BREAK;

		INSERT INTO @songNames (Name) VALUES (@songName);
            
    END
    
    CLOSE songCursor;
    DEALLOCATE songCursor;
    
    RETURN
END


CREATE OR ALTER FUNCTION get_top_seller_per_shop_cursor()
RETURNS @resultTable TABLE ( location VARCHAR(max), mayorvendedor VARCHAR(max))
AS
BEGIN
    DECLARE @shopId BIGINT;
    DECLARE @workerName VARCHAR(max);
    
    DECLARE cursorShops CURSOR FOR
    SELECT id
    FROM shops;
    
    OPEN cursorShops;
        
    WHILE 1=1
    BEGIN
        FETCH NEXT FROM cursorShops INTO @shopId;
        SELECT TOP 1 @workerName = name
        FROM workers
        WHERE shop = @shopId
        ORDER BY sales DESC;
        IF @@FETCH_STATUS <> 0
        	BREAK;
        INSERT INTO @resultTable (location, mayorvendedor)
        VALUES ((SELECT location FROM shops WHERE id = @shopId), @workerName)
    END
    
    CLOSE cursorShops;
    DEALLOCATE cursorShops;
    
    RETURN
END


--Inserts obligatorios

EXEC insert_shop 'Alicante'
EXEC insert_shop 'Madrid'
EXEC insert_shop 'Sevilla'
EXEC insert_shop 'Badajoz'
EXEC insert_shop 'Barcelona'
EXEC insert_shop 'A Coruña'
EXEC insert_shop 'Bilbao'


EXEC insert_workers 0, 'Xavier', '74532182A', 19, 'M', '2003-9-29', 1
EXEC insert_workers 0, 'Robert', '54326543C', 19, 'M',  '2003-10-27', 1
EXEC insert_workers 0, 'Ivens', '86512234B', 38, 'M',  '1985-2-10', 1
EXEC insert_workers 0, 'Paco', '13479034B', 68, 'M',  '1954-10-30', 2
EXEC insert_workers 0, 'María', '5634235K', 18, 'F', '2005-2-27', 2
EXEC insert_workers 0, 'Pablo', '52662234N', 25, 'M', '1998-1-27', 2
EXEC insert_workers 0, 'Lucia', '86512234B', 38, 'F',  '1985-2-10', 3
EXEC insert_workers 0, 'Alba', '4587935H', 18, 'F',  '2004-9-30', 3
EXEC insert_workers 0, 'Juan', '34897634O', 56, 'M', '1967-3-15', 3
EXEC insert_workers 0, 'Sofia', '34869254V', 46, 'F',  '1978-9-24', 4
EXEC insert_workers 0, 'Kevin', '73849483C', 34, 'M', '1989-4-6', 4
EXEC insert_workers 0, 'Belen', '74786384J', 26, 'F',  '1997-5-3', 4
EXEC insert_workers 0, 'Basilio', '18340594G', 23, 'M', '1999-8-15', 5
EXEC insert_workers 0, 'Juan', '73980127F', 36, 'M', '1987-1-1', 5
EXEC insert_workers 0, 'Alvaro', '83950645B', 34, 'M', '1989-8-15', 5
EXEC insert_workers 0, 'Paco', '73648593G', 64, 'M', '1958-11-20', 6
EXEC insert_workers 0, 'Alba', '34834953V', 58, 'F',  '1964-7-24', 6
EXEC insert_workers 0, 'Carlos', '12345567S', 50, 'M', '1973-2-10', 6




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
EXEC insert_character 'Mario', 24, 1, 1
EXEC insert_character 'Luigi', 24, 1, 1
EXEC insert_character 'Peach', 21, 0, 1
EXEC insert_character 'Bowser', 35, 1, 1
EXEC insert_character 'Pikachu', 7, 0, 1
EXEC insert_character 'Red', 14, 1, 1
EXEC insert_character 'Pidgey', 4, 0, 1
EXEC insert_character 'Ratata', 4, 0, 1
EXEC insert_character 'Bulbasaur', 4, 0, 1
EXEC insert_character 'Ursaring', 10, 0, 1





EXEC insert_company 'Microsoft', 'Bill Gates', '1975-4-4'
EXEC insert_company 'Sony', 'Kenichiro Yoshida', '1946-5-7'
EXEC insert_company 'Nintendo', 'Tatsumi Kimishima', '1889-9-23'
EXEC insert_company 'Blizzard', 'Myke Ibarra', '2016-5-24'
EXEC insert_company 'Riot Games', 'Nicolo Laurent', '2006-9-1'
EXEC insert_company 'Bungie', 'Jason Jones', '1991-2-5'
EXEC insert_company 'Rockstar Games', 'Dan House', '1998-12-1'
EXEC insert_company 'Naughty Dog', 'Andy Gavin', '1984-5-6' 
EXEC insert_company 'Game Freak', 'Junichi Masuda', '1989-4-7'

EXEC insert_consoles 'XBOX', 10, '2020-11-10', 1
EXEC insert_consoles 'Play Station', 10, '2020-11-12', 2
EXEC insert_consoles 'Nintendo Switch', 10, '2017-3-3', 3
EXEC insert_consoles 'PC', 10, '1941-8-13', 3




EXEC insert_videogame 'Shooter', 'Overwatch', 1, '2016-5-24', '12', 4, 10
EXEC insert_videogame 'Triple A', 'Red Dead Redemption', 0, '2010-5-18', '18', 7, 10
EXEC insert_videogame 'Triple A', 'Red Dead Redemption 2', 0, '2018-10-26', '18', 7, 10
EXEC insert_videogame 'Shooter', 'Halo 3', 1, '2007-9-25', '16', 6, 10
EXEC insert_videogame 'Shooter', 'Halo 4', 1, '2012-11-25', '16', 6, 10
EXEC insert_videogame 'Moba', 'League Of Legends', 1, '2009-01-15', '12', 5, 10
EXEC insert_videogame 'Aventura', 'Uncharted 3', 0, '2011-11-2', '18', 8, 10
EXEC insert_videogame 'Aventura', 'Uncharted 4', 0, '2016-5-10', '18', 8, 10
EXEC insert_videogame 'Plataformas', 'Super Mario Bros', 0, '1985-9-13', '3', 3, 10
EXEC insert_videogame 'RPG', 'Pokemon Rojo Fuego', 0, '2004-10-1', '3', 3, 10
EXEC insert_videogame 'RPG', 'Pokemon Plata', 0, '2001-4-6', '3', 3, 10

EXEC insert_song 'Fire', 'Pepe y Pepa', '2010-2-3', 54
EXEC insert_song 'Awaken', 'Riquelme', '1990-8-9', 44
EXEC insert_song 'Mercy', 'Pepe y Pepa', '1989-6-21', 150
EXEC insert_song 'Agua y Mar', 'Riquelme', '2014-4-2', 259
EXEC insert_song 'Look', 'Pepe y Pepa', '2001-12-3', 350
EXEC insert_song 'Save me', 'Riquelme', '2002-5-6', 223
EXEC insert_song 'Get that hope', 'Riquelme', '1962-5-6', 59
EXEC insert_song 'To the beach', 'The Manolos', '2012-3-5', 623
EXEC insert_song 'Bravo', 'The Manolos', '2003-2-15', 290
EXEC insert_song 'Pontevedra', 'The Manolos', '1989-6-12', 43
EXEC insert_song 'Sinmas', 'The Manolos', '1978-6-2', 900
EXEC insert_song 'Nose', 'The Manolos', '2005-4-12', 143
EXEC insert_song 'Hola', 'David Bisbal', '2008-5-12', 150
EXEC insert_song 'Popo', 'David Bisbal', '2017-7-17', 90
EXEC insert_song 'Aaaaa', 'David Bisbal', '2019-10-18', 120
EXEC insert_song 'JuanTrotamundos', 'Meningitis', '2020-5-12', 314
EXEC insert_song 'Flow Violento', 'YoSoyPlex', '1999-5-6', 180


EXEC insert_boss  3, 1
EXEC insert_boss  3, 2
EXEC insert_boss  5, 4
EXEC insert_boss  6, 4
EXEC insert_boss  7, 8
EXEC insert_boss  8, 9
EXEC insert_boss  10, 12
EXEC insert_boss  11, 12
EXEC insert_boss  15, 13
EXEC insert_boss  15, 14
EXEC insert_boss  18, 16
EXEC insert_boss  17, 18

EXEC connect_characters 6, 1
EXEC connect_characters 6, 2
EXEC connect_characters 6, 3
EXEC connect_characters 6, 4
EXEC connect_characters 1, 5
EXEC connect_characters 1, 6
EXEC connect_characters 1, 7
EXEC connect_characters 1, 8
EXEC connect_characters 4, 9
EXEC connect_characters 4, 10
EXEC connect_characters 4, 11
EXEC connect_characters 5, 9
EXEC connect_characters 5, 10
EXEC connect_characters 5, 11
EXEC connect_characters 3, 12
EXEC connect_characters 3, 13
EXEC connect_characters 2, 13
EXEC connect_characters 3, 14
EXEC connect_characters 3, 15
EXEC connect_characters 2, 15
EXEC connect_characters 3, 16
EXEC connect_characters 7, 17
EXEC connect_characters 8, 17
EXEC connect_characters 7, 18
EXEC connect_characters 8, 18
EXEC connect_characters 7, 19
EXEC connect_characters 8, 19
EXEC connect_characters 9, 20
EXEC connect_characters 9, 21
EXEC connect_characters 9, 22
EXEC connect_characters 9, 23
EXEC connect_characters 10, 24
EXEC connect_characters 10, 25
EXEC connect_characters 10, 26
EXEC connect_characters 10, 27
EXEC connect_characters 11, 24
EXEC connect_characters 11, 26
EXEC connect_characters 11, 27

EXEC insert_videogame_in_consoles 1, 1
EXEC insert_videogame_in_consoles 1, 2
EXEC insert_videogame_in_consoles 1, 4
EXEC insert_videogame_in_consoles 2, 1
EXEC insert_videogame_in_consoles 3, 1
EXEC insert_videogame_in_consoles 3, 2
EXEC insert_videogame_in_consoles 3, 4
EXEC insert_videogame_in_consoles 4, 1
EXEC insert_videogame_in_consoles 5, 1
EXEC insert_videogame_in_consoles 6, 4
EXEC insert_videogame_in_consoles 7, 2
EXEC insert_videogame_in_consoles 7, 4
EXEC insert_videogame_in_consoles 8, 2
EXEC insert_videogame_in_consoles 8, 4
EXEC insert_videogame_in_consoles 9, 3
EXEC insert_videogame_in_consoles 10, 3
EXEC insert_videogame_in_consoles 11, 3

EXEC insert_song_on_ost 1, 1
EXEC insert_song_on_ost 1, 5
EXEC insert_song_on_ost 1, 7
EXEC insert_song_on_ost 2, 2
EXEC insert_song_on_ost 2, 8
EXEC insert_song_on_ost 2, 4
EXEC insert_song_on_ost 3, 2
EXEC insert_song_on_ost 3, 3
EXEC insert_song_on_ost 3, 6
EXEC insert_song_on_ost 4, 9
EXEC insert_song_on_ost 4, 14
EXEC insert_song_on_ost 4, 17
EXEC insert_song_on_ost 5, 16
EXEC insert_song_on_ost 5, 15
EXEC insert_song_on_ost 5, 11
EXEC insert_song_on_ost 6, 12
EXEC insert_song_on_ost 6, 13
EXEC insert_song_on_ost 6, 14
EXEC insert_song_on_ost 7, 1
EXEC insert_song_on_ost 7, 12
EXEC insert_song_on_ost 7, 9
EXEC insert_song_on_ost 8, 5
EXEC insert_song_on_ost 8, 6
EXEC insert_song_on_ost 8, 7
EXEC insert_song_on_ost 9, 8
EXEC insert_song_on_ost 9, 5
EXEC insert_song_on_ost 9, 15
EXEC insert_song_on_ost 10, 17
EXEC insert_song_on_ost 10, 15
EXEC insert_song_on_ost 10, 1
EXEC insert_song_on_ost 11, 4
EXEC insert_song_on_ost 11, 3
EXEC insert_song_on_ost 11, 7


--Pruebas mias


SELECT * FROM logs
EXEC insert_song 'a', NULL, '1999-5-6', 100

EXEC fill_console_stock 1, 1
EXEC insert_console_sold 1, 1, 1
EXEC delete_console_sold 1, 1, 1, '2023-05-26 15:47:15'

SELECT dbo.most_seller_worker();

SELECT * FROM sells_consoles
SELECT * FROM consoles
SELECT * FROM workers;
SELECT * FROM characters
SELECT * FROM songs



EXEC insert_boss  1, 3
EXEC delete_boss 1, 3
SELECT * FROM is_boss


SELECT * from uses_ost
SELECT * FROM songs
SELECT dbo.avg_songtime_from_game(1)

SELECT Location, TopSellerName
FROM dbo.get_top_seller_per_shop_cursor();

SELECT * FROM workers

SELECT * FROM dbo.get_song_names_by_videogame(1)


EXEC insert_console_sold 1,3,3

SELECT * FROM sells_consoles
SELECT * FROM consoles
SELECT * FROM workers;
