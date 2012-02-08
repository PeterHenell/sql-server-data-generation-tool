using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace SQLDataGenerationTool2
{
    public class FullTableImage
    {
        public DatabaseTable Table { get; set; }

        public List<Constraint> Constraints { get; set; }
        public DatabaseTableSchema Schema { get; set; }
        public List<TableRow> Rows { get; set; }

      

        public FullTableImage()
        {
            Table = new DatabaseTable();
            Rows = new List<TableRow>();
            
        }
    }
}
