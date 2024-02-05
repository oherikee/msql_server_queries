CREATE OR ALTER FUNCTION tabela_por_coluna(
    @col_cod VARCHAR(30)
)
RETURNS TABLE
AS
RETURN
SELECT 
	col.name coluna,
	tab.name tabela
FROM 
	sys.columns col
JOIN 
	sys.tables tab
	ON col.object_id = tab.object_id
WHERE 
	col.name LIKE @col_cod;
GO
SELECT * FROM tabela_por_coluna('CAI_COD')
