CREATE FUNCTION div_segura(@numerador FLOAT, @denominador FLOAT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @resultado FLOAT;
    BEGIN TRY
        SET @resultado = @numerador / @denominador
    END TRY
    BEGIN CATCH
        SET @resultado = NULL;
    END CATCH;

    RETURN @resultado;
END;
