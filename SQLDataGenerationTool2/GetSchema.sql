

SELECT * FROM information_schema.tables
SELECT * FROM sys.objects WHERE TYPE = 'u' AND SCHEMA_NAME(SCHEMA_ID) = 'dbo'
SELECT OBJECT_NAME(OBJECT_ID),* FROM sys.columns 
SELECT * FROM sys.key_constraints
SELECT * FROM sys.index_columns


SELECT DISTINCT
	  t.Name AS TableName
	, c.name AS ColumnName
	, c.column_id
	, c.Is_Identity AS IsIdentity
	--, c.Is_Computed AS IsComputed
	, TYPE_NAME(system_type_id) AS TypeName
FROM 
	sys.objects t
INNER JOIN sys.columns c
	ON c.object_id = t.object_id
WHERE 
	t.type = 'u' 
	AND t.name = 'Accounts' 
	AND SCHEMA_NAME(t.SCHEMA_ID) = 'dbo'
	AND is_computed = 0
ORDER BY 
	c.column_id


-- if (Primary key Is Identity) and (Table have one unique key) then unique key is key



--SELECT 
--	* 
--FROM
--	sys.key_constraints kc
--WHERE
--	parent_object_id = OBJECT_ID('dbo.Accounts')
	
	
	
	
	
