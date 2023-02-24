--ALTER
CREATE 
FUNCTION sum (@num INTEGER, @num2 INTEGER) RETURNS INTEGER AS
BEGIN
RETURN @num + @num2
END

SELECT dbo.sum(1, 2);

ALTER
--CREATE 
FUNCTION getMajor (@num INTEGER, @num2 INTEGER, @num3 INTEGER) RETURNS INTEGER AS
BEGIN
 DECLARE @major INTEGER
	IF  @num >= @num2 AND @num >= @num3
		BEGIN
		SET @major = @num
		END
     IF @num2 >= @num AND @num2 >= @num3
    	BEGIN
    	SET @major = @num2
    	END
        IF @num3 >= @num2 AND @num3 >= @num
    	BEGIN
        set @major = @num3
    	END

        RETURN @major
END;

SELECT dbo.getMajor(2,5,1);