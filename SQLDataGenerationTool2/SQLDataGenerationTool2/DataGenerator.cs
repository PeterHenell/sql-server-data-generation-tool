using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Xml.Serialization;
using System.Xml;
using System.IO;
using System.Xml.Xsl;

namespace SQLDataGenerationTool2
{
    public class DataGenerator
    {
        public DataGenerator()
        {

        }

        internal void SerializeAndTransform(FullTableImage full, string outputFileName)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(FullTableImage));
            XmlWriter writer = XmlWriter.Create("tmp.xml");
            serializer.Serialize(writer, full);
            writer.Close();

            XslCompiledTransform transformer = new XslCompiledTransform();
            transformer.Load("ScriptGenerator.xslt");
            transformer.Transform("tmp.xml", outputFileName);
        }

        internal FullTableImage GenerateData(DatabaseTable table, bool includeWhenMatchedClause, bool useDefaultValues)
        {
            MetaDataAccess metaAccess = new MetaDataAccess();
            ConstraintAccess consAccess = new ConstraintAccess();
            DataAccess dataAccess = new DataAccess();

            FullTableImage full = new FullTableImage();
            full.Table = table;
            full.Constraints = consAccess.GetConstraintForTable(table);
            full.Schema = metaAccess.GetSchemaForTable(table);
            
            foreach (Column col in full.Schema.Columns)
            {
                if (col.IsIdentity)
                {
                    full.Table.HasIdentity = true;
                    full.Table.IdentityColumn = col.ColumnName;
                }

                if (!col.IsPartOfPrimaryKey && 
                    full.Constraints.Exists(x => x.IsUnique && 
                                     x.Columns.Exists(c => c.ColumnName == col.ColumnName)))
                {
                    full.Table.HasUniqueKeyOtherThanPK = true;
                }

                if (col.IsPartOfPrimaryKey && col.IsIdentity)
                {
                    full.Table.HasPKSameAsIdentity = true;
                }
                
            }

            // We want to include the WHEN MATCHED clause to enable updates of existing rows.
            full.Table.IncludeWhenMatchedClause = includeWhenMatchedClause;
            // If the entire table is made up by the primary key then we cannot do any updates to the table.
            if (full.Constraints.Where(x => x.IsPrimaryKey).Count() > 0)
            {
                if (full.Constraints.Where(x => x.IsPrimaryKey).SingleOrDefault().Columns.Count == full.Schema.Columns.Count())
                {
                    full.Table.IncludeWhenMatchedClause = false;
                }
                if (full.Constraints.Where(x => x.IsUnique).Count() == 1)
                {
                    if (full.Constraints.Where(x => x.IsUnique).Single().Columns.Count == full.Schema.Columns.Count()) 
                    {
                        full.Table.IncludeWhenMatchedClause = false;
                    }
                }
            }

            // Use DEFAULT values instead of the saved data for columns that have DEFAULT specified.
            full.Table.UseDefaultValues = useDefaultValues;

            // Use SET IDENTITY INSERT ON if
            // The identity is the only unique column in the table.
            
            // Do NOT use SET IDENTITY INSERT ON if
            // Identity is not the only column that is unique
            // PK is not identity
            // There exists a single unique constraint on the table (other than the identity)
            //      If there are multiple unique constraints on the table then that should result in a Manual Editing Required Exception (or something)

            int uniqueCount = (from a in full.Constraints
                               where a.IsPrimaryKey == false && a.IsUnique == true
                               select a).Count();

            full.Table.UseIdentityInsert = true;    
            
            if (!full.Table.HasIdentity)
            {
                full.Table.UseIdentityInsert = false;    
            }

            if (uniqueCount == 1 && full.Table.HasUniqueKeyOtherThanPK)
            {
                full.Table.UseIdentityInsert = false;    
            }

            if (full.Table.UseIdentityInsert)
            {
                full.Table.UseAsPrimaryKeyColumns = full.Schema.Columns.Where(x => x.IsPartOfPrimaryKey).ToList();
            }
            else
            {
                if (uniqueCount > 0)
                {
                    foreach (var cols in full.Constraints.Where(x => x.IsUnique).Select(constr => constr.Columns))
                    {
                        foreach (var col in cols)
                        {
                            full.Table.UseAsPrimaryKeyColumns.Add(col);
                        }
                    }
                }
                else
                {
                    full.Table.UseAsPrimaryKeyColumns.AddRange( 
                        full.Schema.Columns.Where(c => c.IsPartOfPrimaryKey));
                }
                
            }

            if (full.Table.UseIdentityInsert)
            {
                full.Table.InsertColumns = full.Schema.Columns;

                full.Table.UpdateColumns = full.Schema.Columns.Where(
                    c => c.IsPartOfPrimaryKey == false
                    ).ToList();
            }
            else
            {

                if (full.Table.HasIdentity)
                {
                    full.Table.InsertColumns = full.Schema.Columns.Where(
                    c =>
                    (full.Table.HasIdentity ^ full.Table.IdentityColumn == c.ColumnName)
                    ).ToList();

                    full.Table.UpdateColumns = full.Schema.Columns.Where(
                        c => !full.Table.UseAsPrimaryKeyColumns.Contains(c)
                        &&
                        (full.Table.HasIdentity ^ full.Table.IdentityColumn == c.ColumnName)
                        ).ToList();
                }
                else
                {
                    full.Table.InsertColumns = full.Schema.Columns;

                    full.Table.UpdateColumns = full.Schema.Columns.Where(c => c.IsPartOfPrimaryKey != true).ToList();
                }
                


            }

            full.Rows = dataAccess.GetDataForTable(table, full.Schema.Columns);


            return full;

        }
    }
}
