using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace SQLDataGenerationTool2
{
    public class MetaDataAccess
    {

        //public 
        internal DatabaseTableSchema GetSchemaForTable(DatabaseTable table)
        {
            DatabaseTableSchema dbs = new DatabaseTableSchema();

            string sql = string.Format(@"
SELECT DISTINCT
	  c.name AS ColumnName
	, c.column_id
	, c.Is_Identity AS IsIdentity
	, TYPE_NAME(system_type_id) AS TypeName
    , def.definition AS DEFAULT_VALUE
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
LEFT OUTER JOIN
	sys.default_constraints def
	ON c.column_id = def.parent_column_id AND c.object_id = def.parent_object_id
WHERE 
	t.type = 'u' 
	AND t.name = '{0}' 
	AND SCHEMA_NAME(t.SCHEMA_ID) = '{1}'
	AND is_computed = 0
ORDER BY 
	c.column_id
", table.TableName, table.SchemaName);

            using (SqlCommand cmd = CommandFactory.Create(sql))
            {
                cmd.Connection.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    dbs.Columns.Add(new Column { 
                        ColumnName = reader.GetString(reader.GetOrdinal("ColumnName")),
                        DataType = reader.GetString(reader.GetOrdinal("TypeName")),
                        IsIdentity = reader.GetBoolean(reader.GetOrdinal("IsIdentity")), 
                        IsPartOfPrimaryKey = reader.GetBoolean(reader.GetOrdinal("IsPartOfPrimaryKey")),
                        DefaultValue = reader.IsDBNull(reader.GetOrdinal("DEFAULT_VALUE")) ? null : reader.GetString(reader.GetOrdinal("DEFAULT_VALUE"))
                    });
                }


                cmd.Connection.Close();

            }

            return dbs;
        }

        public List<DatabaseTable> GetAllTables()
        {
            List<DatabaseTable> tables = new List<DatabaseTable>();
            //string sql = @"select table_name, table_Schema from information_Schema.tables where table_Type = 'BASE TABLE' order by table_schema, table_name";
            string sql = @"

WITH base AS (

	
select 
	tbl.name as [Table_Name]
	,SCHEMA_NAME(tbl.schema_id) AS Table_Schema
	,tbl2.name AS [ReferencedTable]
from 
	sys.tables as tbl
left join 
	sys.foreign_keys as cstr
	on cstr.parent_object_id=tbl.object_id
left join 
	sys.foreign_key_columns as fk
	on fk.constraint_object_id=cstr.object_id
left join 
	sys.columns as cfk
	on fk.parent_column_id = cfk.column_id
	and fk.parent_object_id = cfk.object_id
left join 
	sys.columns as crk
	on fk.referenced_column_id = crk.column_id
	and fk.referenced_object_id = crk.object_id

left JOIN 
	sys.tables AS tbl2
	ON fk.referenced_object_id = tbl2.object_id
	)
,
more AS
(
	SELECT 
		Table_name
		, Table_Schema
		, [ReferencedTable]
		, 0 AS [level]
		
	FROM 
		base
	WHERE 
		[ReferencedTable] IS NULL
	
	UNION ALL
	
	SELECT 
		  b.Table_name
		, b.Table_Schema
		, b.[ReferencedTable]
		, m.[Level] + 1 AS [Level]
		
	FROM 
		base b
	INNER JOIN 
		more m
		ON	b.[ReferencedTable] = m.Table_Name
)
		
		SELECT DISTINCT
			Table_Name
            , Table_Schema
            , ReferencedTable
            , [level]
			, ROW_NUMBER() OVER (ORDER BY m.level) AS RowNumber
		FROM 
			more m
		WHERE NOT EXISTS(SELECT 1 FROM more m2 WHERE m2.level > m.level AND m2.table_name = m.table_name)
		ORDER BY 
			m.[level]";

            using (SqlCommand cmd = CommandFactory.Create(sql))
            {
                cmd.Connection.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string tableName = reader.GetString(reader.GetOrdinal("Table_name"));
                    string schemaName = reader.GetString(reader.GetOrdinal("Table_Schema"));
                    
                    if (! tables.Exists(x => x.TableName == tableName && x.SchemaName == schemaName  ))
                    {
                        tables.Add(new DatabaseTable
                        {
                            SchemaName = schemaName,
                            TableName = tableName
                        });    
                    }
                    
                }
            }

            return tables;
        }
    }
}
