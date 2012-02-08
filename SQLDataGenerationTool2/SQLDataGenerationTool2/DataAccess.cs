using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace SQLDataGenerationTool2
{
    public class DataAccess
    {
        internal List<TableRow> GetDataForTable(DatabaseTable table, List<Column> schema)
        {
            List<TableRow> rows = new List<TableRow>();
            using (SqlCommand cmd = CommandFactory.Create(string.Format(@"select * from {0}  WITH(NOLOCK)", table.FullName)))
            {
                cmd.Connection.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    TableRow row = new TableRow();
                    foreach (Column col in schema)
                    {
                        row.Columns.Add(new Column { 
                            ColumnName = col.ColumnName,
                            DataType = col.DataType,
                            Data = reader[col.ColumnName].ToString().Replace("'", "''"),
                            IsIdentity = col.IsIdentity,
                            DefaultValue = col.DefaultValue
                        });
                    }

                    rows.Add(row);
                }
            }

            return rows;
        }
    }
}
