using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace SQLDataGenerationTool2
{
    public class DatabaseTable
    {
        public string TableName { get; set; }
        public string SchemaName { get; set; }
        public bool HasIdentity { get; set; }
        public bool HasUniqueKeyOtherThanPK { get; set; }
        public bool HasPKSameAsIdentity { get; set; }

        public bool IncludeWhenMatchedClause { get; set; }

        public string IdentityColumn { get; set; }
        public bool UseIdentityInsert { get; set; }

        public bool UseDefaultValues { get; set; }

        public List<Column> UseAsPrimaryKeyColumns { get; set; }
        public List<Column> InsertColumns { get; set; }
        public List<Column> UpdateColumns { get; set; }

        public int SortIndex { get; set; }



        public DatabaseTable()
        {
            UseAsPrimaryKeyColumns = new List<Column>();
            InsertColumns = new List<Column>();
            UpdateColumns = new List<Column>();
        }

        public string FullName
        {
            get
            {
                return SchemaName + "." + TableName;
            }
        }

        public override string ToString()
        {
            return FullName;
        }


    }
}
