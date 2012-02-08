SELECT DISTINCT
	  c.name AS ColumnName
	, c.column_id
	, c.Is_Identity AS IsIdentity
	, TYPE_NAME(system_type_id) AS TypeName
	, CAST(CASE WHEN EXISTS(SELECT 1
			FROM 
				sys.indexes I2 
			INNER JOIN sys.index_columns ic2
				ON i2.object_id = ic2.object_id AND I2.index_id = ic2.index_id
			INNER JOIN sys.columns c2
				ON i2.object_id = c2.object_id AND ic2.column_id = c2.column_id
			
			WHERE 
				is_primary_key = 1
				AND c2.column_id = c.column_id 
				AND i2.OBJECT_ID = t.object_id) THEN 1 ELSE 0 END AS BIT) AS IsPartOfPrimaryKey 
	
FROM 
	sys.objects t
INNER JOIN sys.columns c
	ON c.object_id = t.object_id
WHERE 
	t.type = 'u' 
	AND t.name = '{0}' 
	AND SCHEMA_NAME(t.SCHEMA_ID) = '{1}'
	AND is_computed = 0
ORDER BY 
	c.column_id
	
	
	