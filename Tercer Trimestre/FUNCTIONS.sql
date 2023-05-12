--1
--ALTER FUNCTION GetMaxMin (@n1 INTEGER, @n2 INTEGER)
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

SELECT dbo.GetMaxMin(2,4)

--2
--ALTER FUNCTION GetMinMax (@n1 integer, @n2 integer) RETURNS INTEGER AS
CREATE FUNCTION GetMinMax (@n1 integer, @n2 integer) RETURNS INTEGER AS
BEGIN
	DECLARE @res INTEGER = 0;
    IF @n1 > @n2
    	SET @res = -1;
    ELSE
    	SET @res = 1;
    RETURN @res;
END

SELECT dbo.GetMinMax(12,22)

--3
--ALTER FUNCTION AvgTemps (@n1 FLOAT, @n2 FLOAT) RETURNS FLOAT AS
CREATE FUNCTION AvgTemps (@n1 FLOAT, @n2 FLOAT) RETURNS FLOAT AS
BEGIN
	RETURN (@n1 + @n2) / 2;
END

SELECT dbo.AvgTemps(5,10)

--4
--ALTER FUNCTION GetBinarynum(@n INTEGER) RETURNS VARCHAR(264) AS
CREATE FUNCTION GetBinarynum(@n INTEGER) RETURNS VARCHAR(264) AS
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

SELECT dbo.GetBinarynum(5)

--5
--ALTER FUNCTION CountNums (@n INTEGER)RETURNS VARCHAR(256) AS
CREATE FUNCTION CountNums (@n INTEGER)RETURNS VARCHAR(256) AS
BEGIN
  DECLARE @result VARCHAR(256)='';
  WHILE @n > 0
  BEGIN
      SET @result = CONCAT (@n, ', ', @result);
      SET @n = @n - 1;
  END
  SET @result = LEFT(@result, LEN(@result) - 1);
  RETURN @result;
END

SELECT dbo.CountNums(4)

--6 
--ALTER FUNCTION GetMultiplication (@n INTEGER) RETURNS VARCHAR(256) AS
CREATE FUNCTION GetMultiplication (@n INTEGER) RETURNS VARCHAR(256) AS
BEGIN
	DECLARE @result VARCHAR(256)='';
    DECLARE @value INTEGER = 0;
    DECLARE @i INTEGER = 1;
    WHILE 12 >= @i
    BEGIN
    	SET @value = @n * @i;
        SET @result = CONCAT (@result, @n, ' * ', @i, ' = ', @value, ' ');
        SET @i = @i + 1;
    END
    RETURN @result;
END

SELECT dbo.GetMultiplication(10);

--7 Mal
ALTER FUNCTION GetSerie(@n BIGINT) RETURNS VARCHAR(265) AS
--CREATE FUNCTION GetSerie(@n INTEGER) RETURNS VARCHAR(265) AS
BEGIN
    DECLARE @serie VARCHAR(265) = '';
    DECLARE @sign INTEGER = 1;
    DECLARE @i BIGINT = 1;
    DECLARE @term BIGINT = -1;

    WHILE @i <= @n
    BEGIN
        SET @serie = CONCAT(@serie, @term, ', ');
        SET @sign = @sign * -1;
        SET @term = @term * 2 * @sign;
    END

    SET @serie = LEFT(@serie, LEN(@serie) - 2);
    RETURN @serie;
END

SELECT dbo.GetSerie(10);

--8
--ALTER FUNCTION IsPrime (@n INTEGER) RETURNS BIT AS
CREATE FUNCTION IsPrime (@n INTEGER) RETURNS BIT AS
BEGIN
    IF @n <= 1
        RETURN 0;
        
    DECLARE @isPrime BIT = 1;
    DECLARE @i INTEGER = 2;
    
    WHILE @i < @n AND @isPrime = 1
    BEGIN
        IF @n % @i = 0
            SET @isPrime = 0;
        SET @i = @i + 1;
    END

    RETURN @isPrime;
END
SELECT dbo.IsPrime(6);

--9
--ALTER FUNCTION PrimeSum (@n1 INTEGER, @n2 INTEGER) RETURNS BIGINT AS
CREATE FUNCTION PrimeSum (@n1 INTEGER, @n2 INTEGER) RETURNS BIGINT AS
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

SELECT dbo.PrimeScale(5,5);

--10
--ALTER FUNCTION PrimeFactors (@n INTEGER) RETURNS VARCHAR(250) AS 
CREATE FUNCTION PrimeFactors (@n INTEGER) RETURNS VARCHAR(265) AS
BEGIN
    DECLARE @result VARCHAR(265) = '';
    DECLARE @factor INTEGER = 2;
    
    WHILE @n > 1
    BEGIN
        IF @n % @factor = 0
        BEGIN
            SET @result = CONCAT(@result, @factor, ' · ');
            SET @n = @n / @factor;
        END
        ELSE
        BEGIN
            SET @factor = @factor + 1;
        END
    END
    RETURN LEFT(@result, LEN(@result) - 2);
END
SELECT dbo.PrimeFactors(60)

--11
--ALTER FUNCTION GetCollatz  (@num INTEGER) RETURNS VARCHAR(256) AS
CREATE FUNCTION GetCollatz  (@num INTEGER) RETURNS VARCHAR(256) AS
BEGIN
	DECLARE @result VARCHAR(260) = '';
    WHILE @num > 1
    BEGIN
    	SET @result = CONCAT(@result, @num, ', ');
        IF @num % 2 = 0
        	SET @num = @num / 2;
        ELSE
        	SET @num = @num * 3 + 1;
    END
    SET @result += '1';
    RETURN @result;
END	

SELECT dbo.GetCollatz(20);

--12

CREATE FUNCTION CalcPI (@num INTEGER) RETURNS FLOAT AS
BEGIN
    DECLARE @pi FLOAT = 0.0;
    DECLARE @sign FLOAT = 1.0;
    DECLARE @denominator FLOAT = 1.0;
    DECLARE @i INTEGER = 0;
    
    WHILE @i < @num
    BEGIN
        SET @pi = @pi + @sign * (1.0 / @denominator);
        SET @sign = @sign * -1.0;
        SET @denominator = @denominator + 2.0;
        SET @i = @i + 1;
    END
    
    SET @pi = @pi * 4.0;
    RETURN @pi;
END;
            
SELECT dbo.CalcPI(1000000);
            
--13

CREATE FUNCTION GetGreatestCommonDivisor(@n1 INTEGER, @n2 INTEGER) RETURNS INTEGER
AS BEGIN
    DECLARE @remainder INTEGER = @n1 % @n2;
    WHILE @remainder != 0
    BEGIN
        SET @n1 = @n2;
        SET @n2 = @remainder;
        SET @remainder = @n1 % @b;
    END
    RETURN @n2;
END;

CREATE FUNCTION ReduceFraction(@numerator INT, @denominator INT) RETURNS VARCHAR(50)
AS BEGIN
    DECLARE @mcd INT;
    DECLARE @newNumerator INT;
    DECLARE @newDenominator INT;
    SET @mcd = dbo.GetGreatestCommonDivisor(@numerator, @denominator);
    SET @newNumerator = @numerator / @mcd;
    SET @newDenominator = @denominator / @mcd;
    RETURN CONCAT(@newNumerator, '/', @newDenominator);
END;

SELECT dbo.ReduceFraction(6,4)
            
            
                        
            
            
            
    