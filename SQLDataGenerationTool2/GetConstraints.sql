
	SELECT 
		is_primary_key AS IsPrimaryKey
		, is_unique_constraint AS IsUnique
		, OBJECT_NAME(i.object_id) AS TableName
		, c.name AS ColumnName
		, TYPE_NAME(c.system_type_id) AS DataType
		, c.is_identity AS IsIdentity
		, i.name AS ConstraintName
		, ic.index_id AS IndexId
	FROM 
		sys.indexes I 
	INNER JOIN sys.index_columns ic
		ON i.object_id = ic.object_id AND I.index_id = ic.index_id
	INNER JOIN sys.columns c
		ON i.object_id = c.object_id AND ic.column_id = c.column_id
	WHERE 
		i.object_id = OBJECT_ID('dbo.Accounts')
		AND is_included_column = 0 
		and Is_Disabled = 0
	ORDER BY 
		IndexId
		

SELECT * FROM sys.columns
SELECT * FROM sys.key_constraints WHERE parent_object_id = object_id('account')
