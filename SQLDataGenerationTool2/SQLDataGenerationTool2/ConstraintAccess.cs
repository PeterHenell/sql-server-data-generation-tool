using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace SQLDataGenerationTool2
{
    public class ConstraintAccess
    {
        public List<Constraint> GetConstraintForTable(DatabaseTable table)
        {
            List<Constraint> constraints = new List<Constraint>();
            string sql = string.Format(@"	SELECT 
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
		i.object_id = OBJECT_ID('{0}')
		AND is_included_column = 0 
		and Is_Disabled = 0
	ORDER BY 
		IndexId", table.FullName);


            using (SqlDataAdapter ad = CommandFactory.CreateAdapter(sql))
            {
                ad.SelectCommand.Connection.Open();

                DataSet ds = new DataSet();
                ad.Fill(ds);

                DataTable tbl = ds.Tables[0];

                int prevConstraint = -1;


                for (int i = 0; i < tbl.Rows.Count; i++)
                {
                    Constraint cons = new Constraint();

                    if (prevConstraint == -1 || prevConstraint != tbl.Rows[i].Field<int>("IndexId"))
                    {

                        cons.IsPrimaryKey = tbl.Rows[i].Field<bool>("IsPrimaryKey");
                        cons.IsUnique = tbl.Rows[i].Field<bool>("IsUnique");
                        cons.ConstraintName = tbl.Rows[i].Field<string>("ConstraintName");
                        cons.IndexId = tbl.Rows[i].Field<int>("IndexId");

                        constraints.Add(cons);

                        prevConstraint = tbl.Rows[i].Field<int>("IndexId");
                    }

                    // Add all columns in the index
                    // First the first column
                    cons.Columns.Add(new Column
                    {
                        ColumnName = tbl.Rows[i].Field<string>("ColumnName"),
                        DataType = tbl.Rows[i].Field<string>("DataType"),
                        IsIdentity = tbl.Rows[i].Field<bool>("IsIdentity")
                    });

                    if (i + 1 == tbl.Rows.Count)
                        break;

                    // Then the rest of the columns, if there are any
                    while (tbl.Rows[i + 1].Field<int>("IndexId") == prevConstraint)
                    {
                        i++;
                        cons.Columns.Add(new Column
                        {
                            ColumnName = tbl.Rows[i].Field<string>("ColumnName"),
                            DataType = tbl.Rows[i].Field<string>("DataType"),
                            IsIdentity = tbl.Rows[i].Field<bool>("IsIdentity")
                        });
                        if (i + 1 == tbl.Rows.Count)
                            break;
                    }
                }

                ad.SelectCommand.Connection.Close();
            }

            return constraints;
        }
    }
}
