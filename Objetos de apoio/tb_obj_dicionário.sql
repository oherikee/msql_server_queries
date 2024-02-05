-- Criação da tabela responsável por armazenar os objetos e suas mensagens de apoio
CREATE TABLE obj_dicionario (
    obj_tipo NVARCHAR(50),
    obj_nome NVARCHAR(128),
    param_nome NVARCHAR(128),
    param_tipo NVARCHAR(128),
    mensagem NVARCHAR(4000)
);
GO
-- Script para popular a tabela-dicionário com informações sobre funções e seus parâmetros
INSERT INTO obj_dicionario (obj_tipo, obj_nome, param_nome, param_tipo, mensagem)
SELECT 
    'FUNCTION' AS obj_tipo,
    ROUTINE_NAME AS obj_nome,
    PARAMETER_NAME AS param_nome,
    DATA_TYPE AS param_tipo,
    'Mensagem para o parâmetro ' + ROUTINE_NAME + '.' + PARAMETER_NAME AS mensagem
FROM INFORMATION_SCHEMA.PARAMETERS
WHERE SPECIFIC_SCHEMA = 'dbo' AND OBJECT_NAME(OBJECT_ID) IS NOT NULL;
GO
-- Script para popular a tabela-dicionário com informações sobre procedures e parâmetros
INSERT INTO obj_dicionario (obj_tipo, obj_nome, param_nome, param_tipo, mensagem)
SELECT 
    'PROCEDURE' AS obj_tipo,
    ROUTINE_NAME AS obj_nome,
    PARAMETER_NAME AS param_nome,
    DATA_TYPE AS param_tipo,
    'Mensagem para o parâmetro ' + ROUTINE_NAME + '.' + PARAMETER_NAME AS mensagem
FROM INFORMATION_SCHEMA.PARAMETERS
WHERE SPECIFIC_SCHEMA = 'dbo' AND OBJECT_NAME(OBJECT_ID) IS NULL;
GO
-- Criação do trigger responsável por alimentar automáticamente a tabela-dicionário com objetos futuramente criados
CREATE TRIGGER ObjectDDLTrigger
ON DATABASE
FOR CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION, CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE
AS
BEGIN
    DECLARE @info_evento XML = EVENTDATA();
    DECLARE @evento NVARCHAR(50);
    DECLARE @obj_tipo NVARCHAR(50);
    DECLARE @obj_nome NVARCHAR(128);
    DECLARE @param_nome NVARCHAR(128);
    DECLARE @param_tipo NVARCHAR(128);
    DECLARE @mensagem NVARCHAR(4000);

    SET @evento = @info_evento.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)');
    SET @obj_tipo = CASE 
                        WHEN @info_evento.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(50)') = 'FUNCTION' THEN 'FUNCTION'
                        WHEN @info_evento.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(50)') = 'PROCEDURE' THEN 'PROCEDURE'
                    END;
    SET @obj_nome = @info_evento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)');

    -- Consulta de apoio para obter informações sobre os parâmetros de uma função ou procedure
    IF @obj_tipo IN ('FUNCTION', 'PROCEDURE')
    BEGIN
        SELECT @param_nome = parameter_name,
               @param_tipo = data_type
        FROM INFORMATION_SCHEMA.PARAMETERS
        WHERE SPECIFIC_NAME = @obj_nome;
    END
    SET @mensagem = 'Mensagem para ' + @obj_nome + '.' + COALESCE(@param_nome, '');

    -- Especificação da reação baseada no evento
    IF @evento = 'CREATE'
    -- Insert, caso um objeto seja criado
    BEGIN
        INSERT INTO obj_dicionario (obj_tipo, obj_nome, param_nome, param_tipo, mensagem)
        VALUES (@obj_tipo, @obj_nome, @param_nome, @param_tipo, @mensagem);
    END
    ELSE IF @evento = 'ALTER'
    -- Update, caso um objeto seja alterado
    BEGIN
        UPDATE obj_dicionario
        SET param_nome = @param_nome,
            param_tipo = @param_tipo,
            mensagem = @mensagem
        WHERE obj_tipo = @obj_tipo AND obj_nome = @obj_nome;
    END
    ELSE IF @evento = 'DROP'
    -- Delete, caso um objeto seja dropado
    BEGIN
        DELETE FROM obj_dicionario
        WHERE obj_tipo = @obj_tipo AND obj_nome = @obj_nome;
    END
END;
GO
