CREATE TABLE pokemon
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

INSERT INTO pokemon (id, initiative, name, life, damage,  maxhp, accuracity, damage_reduction) VALUES(1, 50, 'Nasus', 100, 25, 100, 0.8, 0.4);
INSERT INTO pokemon (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(2, 10, 'Vaporeon', 100, 3, 100, 0.4, 0.8);
INSERT INTO pokemon (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(3, 80, 'Piqueras', 70, 50, 70, 0.7, 0.1);
INSERT INTO pokemon (id, initiative, name, life, damage, maxhp, accuracity, damage_reduction) VALUES(4, 100, 'Vinisiu', 85, 30, 85, 1, 0.3);

CREATE OR ALTER PROCEDURE heal (@pokemon_id BIGINT) AS
BEGIN
	UPDATE pokemon SET life = maxhp WHERE id = @pokemon_id;
END


CREATE OR ALTER PROCEDURE attack (@attacker_id BIGINT, @defender_id BIGINT) AS 
BEGIN
	DECLARE @chance FLOAT;
    DECLARE @damage INT;
    DECLARE @accuracity FLOAT;
    SET @chance = RAND();
    SET @accuracity = (SELECT accuracity FROM pokemon WHERE id = @attacker_id);
    IF @accuracity > @chance
    BEGIN
    	SET @damage = (SELECT a.damage * (1- b.damage_reduction) 
                   FROM pokemon as a, pokemon as b 
                   WHERE a.id = @attacker_id AND b.id = @defender_id);
        UPDATE pokemon set life = life - damage WHERE id = @defender_id
    END
END

EXEC attack 1, 4;
SELECT * FROM pokemon;
EXEC attack 4, 1;
EXEC heal 3;
SELECT * FROM pokemon;



