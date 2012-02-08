using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SQLDataGenerationTool2
{
    public class DatabaseTableSchema
    {
        public List<Column> Columns { get; set; }


        public DatabaseTableSchema()
        {
            Columns = new List<Column>();
        }
    }
}
