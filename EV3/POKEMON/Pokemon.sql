CREATE TABLE logs
(
  id BIGINT IDENTITY(1,1),
  at TIME NOT NULL,
  message VARCHAR(max) NOT NULL,
  CONSTRAINT pk_id_logs PRIMARY KEY (id) 
);

CREATE TABLE pokemons
(
  id BIGINT,
  initiative INT,
  name VARCHAR(50),
  life INT,
  damage INT,
  maxhp INT,
  accuracity FLOAT,
  damage_reduction FLOAT,
  
  CONSTRAINT pk_pokemon PRIMARY KEY(id),
  CONSTRAINT chk_maxhp CHECK( maxhp BETWEEN 0 AND 100),
  CONSTRAINT chk_damage CHECK (damage BETWEEN 0 AND 50),
  CONSTRAINT chk_life CHECK (life <= maxhp),
  CONSTRAINT chk_accuracity CHECK (accuracity BETWEEN 0 AND 1),
  CONSTRAINT chk_dmg_red CHECK (damage_reduction BETWEEN 0 AND 0.9),
);

INSERT INTO pokemons (id, initiative, name, life, damage,  maxhp, accuracity, damage_reduction) VALUES(1, 50, 'Nasus', 100, 25, 100, 0.8, 0.4);
INSERT INTO pokemons (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(2, 10, 'Vaporeon', 100, 3, 100, 0.4, 0.8);
INSERT INTO pokemons (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(3, 80, 'Piqueras', 70, 50, 70, 0.7, 0.1);
INSERT INTO pokemons (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(4, 100, 'Vinisiu', 85, 30, 85, 1, 0.3);
INSERT INTO pokemons (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(5, 95, 'Robert', 70, 40, 70, 0.5, 0.5);

CREATE OR ALTER PROCEDURE heal AS
BEGIN
	UPDATE pokemons SET life = maxhp;
END

CREATE OR ALTER PROCEDURE log (@message VARCHAR(max)) AS
BEGIN
	INSERT INTO logs (message, at) VALUES (@message, GETDATE());
END

CREATE OR ALTER PROCEDURE attack (@attacker_id BIGINT, @defender_id BIGINT) AS 
BEGIN
	DECLARE @message VARCHAR(max);
    set @message = CONCAT((SELECT name FROM pokemons WHERE @attacker_id = id),' ataca a ', 
                          (SELECT name FROM pokemons WHERE @defender_id = id));
	EXEC log @message;
	DECLARE @chance FLOAT;
    DECLARE @damage INT;
    DECLARE @accuracity FLOAT;
    SET @chance = RAND();
    SET @accuracity = (SELECT accuracity FROM pokemons WHERE id = @attacker_id);
    IF @accuracity > @chance
    BEGIN
    	SET @damage = (SELECT a.damage * (1- b.damage_reduction) 
                   FROM pokemons as a, pokemons as b 
                   WHERE a.id = @attacker_id AND b.id = @defender_id);
        UPDATE pokemons set life = life - @damage WHERE id = @defender_id
            SET @message = CONCAT((SELECT name FROM pokemons WHERE @defender_id = id), ' recibe un ataque de ', @damage,
                         ' hp por parte de ', (SELECT name FROM pokemons WHERE @attacker_id = id));
    EXEC log @message;
    END
	ELSE
    EXEC log 'El ataque no dio!';
END

CREATE OR ALTER PROCEDURE execute_round  AS
BEGIN
	DECLARE @attacker_id BIGINT;
    DECLARE @defender_id BIGINT;
    DECLARE pokemon_cursor CURSOR FOR SELECT id FROM pokemons WHERE life > 0 ORDER BY initiative DESC
    OPEN pokemon_cursor;
    WHILE 1 = 1
    BEGIN
    	FETCH NEXT FROM pokemon_cursor INTO @attacker_id;
        if @@FETCH_STATUS <> 0 BEGIN break; END
        SET @defender_id = (SELECT TOP(1) id FROM pokemons WHERE life > 0 AND id <> @attacker_id ORDER BY NEWID());
        EXEC attack @attacker_id, @defender_id;
    END
    CLOSE pokemon_cursor;
    DEALLOCATE pokemon_cursor;
END

CREATE OR ALTER PROCEDURE simulate_battle AS
BEGIN
	DECLARE @alive_count INT;
    DECLARE @log VARCHAR (max);
	WHILE 1 = 1
    BEGIN
    	set @alive_count = (SELECT COUNT(*) FROM pokemons WHERE life > 0);
        EXEC execute_round;
        IF @alive_count = 1 
        break;
    END
    set @log = CONCAT('El ganador es ', (SELECT name FROM pokemons WHERE life > 0));
    EXEC log @log;
END

EXEC heal 
EXEC execute_round;
SELECT * FROM pokemons;
SELECT * FROM logs;
SELECT * FROM pokemons;

EXEC simulate_battle;