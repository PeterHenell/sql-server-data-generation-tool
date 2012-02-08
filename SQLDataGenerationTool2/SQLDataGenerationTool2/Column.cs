using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SQLDataGenerationTool2
{
    public class Column : IComparable<Column>, IComparable, IEquatable<Column>, IEqualityComparer<Column>
    {
        public string ColumnName { get; set; }
        public string DataType { get; set; }
        public bool IsIdentity { get; set; }
        public bool IsPartOfPrimaryKey { get; set; }
        public string DefaultValue { get; set; }

        public string Data { get; set; }

        public int CompareTo(Column other)
        {
            return this.ColumnName.CompareTo(other.ColumnName);
        }

        public int CompareTo(object obj)
        {
            if (!(obj is Column))
            {
                throw new IndexOutOfRangeException("obj");
            }

            return this.ColumnName.CompareTo(((Column)obj).ColumnName);
        }



        public bool Equals(Column other)
        {
            return this.ColumnName == other.ColumnName;
        }

        public bool Equals(Column x, Column y)
        {
            return x.ColumnName == y.ColumnName;
        }

        public int GetHashCode(Column obj)
        {
            return obj.ColumnName.GetHashCode();
        }
    }
}
