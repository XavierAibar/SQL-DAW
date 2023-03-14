--1
CREATE FUNCTION GetMaxMin (@n1 INTEGER, @n2 INTEGER)
RETURNS VARCHAR(60) AS
BEGIN
DECLARE @max INTEGER = @n1;
DECLARE @min INTEGER = @n2;
DECLARE @result VARCHAR(60) = ''; 
	IF @n1 < @n2
	BEGIN
    	set @max = @n2;
        SET @min = @n1;
    END
SET @result = CONCAT('Max is ', @max, ' And min is ', @min);
RETURN @result;
END
SELECT dbo.GetMaxMin(5,3)
--2
CREATE FUNCTION GetMaxMin (@n1 integer, @n2 integer)RETURNS INTEGER AS
BEGIN
	DECLARE @res INTEGER = 0;
    IF @n1 > @n2
    	SET @res = -1;
    ELSE
    	SET @res = 1;
    RETURN @res;
END
--3
CREATE FUNCTION avgtemps (@n1 DECIMAL, @n2 DECIMAL) RETURNS DECIMAL AS
BEGIN
	RETURN (@n1 + @n2) / 2;
END
--4
CREATE FUNCTION binarynum(@n INTEGER) RETURNS VARCHAR(264) AS
BEGIN
    DECLARE @result VARCHAR(256)='';
    DECLARE @module INTEGER;
    WHILE @n > 0
    BEGIN
    	SET @module = @n % 2;
        SET @result = CONCAT (@module, @result);
        SET @n = @n / 2;
	END
    RETURN @result;
END
SELECT dbo.binarynum(20)
--5 mal
CREATE FUNCTION scale (@n INTEGER)RETURNS VARCHAR AS
BEGIN
  DECLARE @result VARCHAR(256)='';
  DECLARE @i INTEGER = 0;
  WHILE @n > @i
  BEGIN
      SET @i = @i + 1;
      SET @result = CONCAT (@i, @result);
  END
  RETURN @result;
END
--6 mal
CREATE FUNCTION multiplication (@n INTEGER) RETURNS VARCHAR AS
BEGIN
	DECLARE @result VARCHAR(256)='';
    DECLARE @i INTEGER = 0;
    WHILE 12 >= @i
    BEGIN
        SET @result = CONCAT (@i * @n, @result);
        SET @i = @i + 1;
    END
    RETURN @result;
END
SELECT dbo.multiplication(1);
--7
CREATE FUNCTION scale2 (@max INTEGER) RETURNS VARCHAR AS
BEGIN
	DECLARE @result VARCHAR(256)='';
    DECLARE @i INTEGER = 0;
    DECLARE @n INTEGER = -1
    WHILE @max >= @i
    BEGIN
        SET @result = CONCAT (@n, @result);
        SET @n = @n * -2
        SET @i = @i + 1;
    END
    RETURN @result;
END
--8
CREATE FUNCTION IsPrime (@n INTEGER) RETURNS BIT AS
BEGIN
	DECLARE @isPrime BIT = 1;
    DECLARE @i INTEGER = 2;
    WHILE @i<@n AND @isPrime = 1
    BEGIN
   		IF @n % @i = 0
       		SET @isPrime = 0;
        SET @i = @i + 1;
    END
RETURN @isPrime
END
SELECT dbo.IsPrime(11);
--9
CREATE FUNCTION PrimeScale (@n1 INTEGER, @n2 INTEGER) RETURNS BIGINT AS
BEGIN
	DECLARE @result BIGINT = 0;
    DECLARE @i INTEGER = 2;
    WHILE @i <= @n1
    BEGIN
    	IF dbo.IsPrime(@i) = 1
        	SET @result = @result + @i;
        set @i = @i + 1;
    END
    set @i = 2;
        WHILE @i <= @n2
    BEGIN
    	IF dbo.IsPrime(@i) = 1
        	SET @result = @result + @i;
        set @i = @i + 1;
    END
    RETURN @result;
END
SELECT dbo.PrimeScale(2,5);
--10

CREATE FUNCTION DecomposeNumber (@n INTEGER) RETURNS VARCHAR(250) AS 
BEGIN
	DECLARE @result VARCHAR(250) = '';
    DECLARE @i INTEGER = 2;
    WHILE @i <= @n
    BEGIN
    	IF dbo.IsPrime(@i) = 1
        	SET @result = CONCAT (@result, @i, ' ');
        set @i = @i + 1;
    END
    RETURN @result;
END
SELECT dbo.DecomposeNumber(15)
            
            
            
            
            
    