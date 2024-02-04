CREATE FUNCTION div_segura(@numerador FLOAT, @denominador FLOAT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @resultado FLOAT;
    BEGIN TRY
        SET @resultado = @numerador / NULLIF(@denominador, 0);
    END TRY
    BEGIN CATCH
        SET @resultado = NULL;
    END CATCH;

    RETURN @resultado;
END;