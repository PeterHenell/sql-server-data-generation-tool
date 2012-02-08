using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SQLDataGenerationTool2
{
    public class TableRow
    {
        public List<Column> Columns { get; set; }


        public TableRow()
        {
            Columns = new List<Column>();
        }
    }
}
