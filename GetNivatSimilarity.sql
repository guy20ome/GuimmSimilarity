-- ***************************************************************************************************
-- Calculate a similarity score between 2 strings based on T-SQL standard functions and trigram splits
-- V1.0 : August 2024 / Guillaume Nivat
-- ***************************************************************************************************

CREATE FUNCTION [tools].[GetNivatSimilarity]
(
    @s      NVARCHAR(4000),
    @t      NVARCHAR(4000)
)
RETURNS FLOAT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE  @v0		NVARCHAR(4000)
            ,@i             INT	= 0
			,@lenGram		INT = 3
			,@cntSim		FLOAT = 0.0
			,@maxSim		INT = 0
            ,@sLen          INT = DATALENGTH(@s) / DATALENGTH(LEFT(LEFT(@s, 1) + '.', 1)) /* length of smaller string */
            ,@tLen          INT = DATALENGTH(@t) / DATALENGTH(LEFT(LEFT(@t, 1) + '.', 1)) /* length of larger string */
            ,@lenDiff       INT                                                           /* difference in length between the two strings */


    IF (@sLen > @tLen)
    BEGIN
        SELECT @v0 = @s,
               @i  = @sLen; /* temporarily use v0 for swap */ 
        SELECT @s = @t,
               @sLen = @tLen;
        SELECT @t = @v0,
               @tLen = @i;
    END;

	SELECT @maxSim=@sLen/@lenGram;

	IF (@s=@t) RETURN 1.0;
	IF (@maxSim=0) RETURN 0.0;
	IF (left(@s,@lenGram)=left(@t,@lenGram)) SELECT @cntSim=@cntSim+1;
	IF (right(@s,@lenGram)=right(@t,@lenGram)) SELECT @cntSim=@cntSim+1;
	
	IF (@maxSim<2) 
		RETURN @cntSim/(@maxSim+1);

	SELECT @i = 4
    WHILE (@i/@lenGram <= @maxSim)
    BEGIN
		IF (@t like concat('%',substring(@s,@i,@lenGram),'%')) SELECT @cntSim=@cntSim+1*(@sLen/(@tLen*1.0));
		SELECT @i=@i+@lenGram
    END;
	
    RETURN @cntSim/(cast(@maxSim+1 as float));
END;