using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SQLDataGenerationTool2
{
    public class Constraint
    {
        public bool IsPrimaryKey { get; set; }
        public bool IsUnique { get; set; }
        public string ConstraintName { get; set; }
        public List<Column> Columns { get; set; }
        public int IndexId { get; set; }

        public Constraint()
        {
            Columns = new List<Column>();
        }
    }
}
