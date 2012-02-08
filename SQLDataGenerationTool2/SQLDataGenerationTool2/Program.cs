using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Xsl;

namespace SQLDataGenerationTool2
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {

                DataGenerator gen = new DataGenerator();
                MetaDataAccess mea = new MetaDataAccess();

                List<DatabaseTable> tables = new List<DatabaseTable>();

                Console.WriteLine("Using this connection:");
                Console.WriteLine(System.Configuration.ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);
                Console.WriteLine();

                Console.WriteLine("Enter the name of the table you wish to generate data for, use <schema_name>.<table_name> format. Leave blank to generate for ALL tables: ");
                string manualInput = Console.ReadLine();

               // manualInput = "Common_Cnfg.PermissionInRole";
                

                Console.WriteLine("Include WHEN MATCHED clause to enable updating of existing rows? [Y/N]");
                bool includeWhenMatchedClause = Console.ReadKey().KeyChar.ToString().ToLower() == "y" ? true : false;
                Console.WriteLine();

                Console.WriteLine("Use DEFAULT values instead of saved data for datetime columns? [Y/N]");
                bool useDefaultValues = Console.ReadKey().KeyChar.ToString().ToLower() == "y" ? true : false;
                Console.WriteLine();

                if (string.IsNullOrEmpty(manualInput))
                {
                    tables = mea.GetAllTables();
                }
                else
                {
                    string schemaName = string.Empty;
                    if (!manualInput.Contains('.'))
                    {
                        schemaName = "dbo";
                    }
                    else
                    {
                        schemaName = manualInput.Substring(0, manualInput.IndexOf('.'));
                    }

                    string tableName = manualInput.Substring(manualInput.IndexOf('.') + 1);
                    tables.Add(new DatabaseTable { TableName = tableName, SchemaName = schemaName });
                }

                Console.WriteLine("Excluding tables with no data");
                Console.WriteLine("Creating scripts");
                Console.WriteLine("Rows\t\t Table Name");

                int i = 1;
                foreach (var table in tables)
                {
                    try
                    {
                        FullTableImage full = gen.GenerateData(table, includeWhenMatchedClause, useDefaultValues);

                        if (full.Rows.Count > 0)
                        {
                            Console.WriteLine("{0}\t\t {1}", full.Rows.Count, table.ToString());

                            string folderName = System.Configuration.ConfigurationManager.AppSettings["outputFolder"];
                            string fileName = string.Format("{2}{3}_{0}.{1}.sql", table.SchemaName, table.TableName, folderName, i++ * (1000 - i * 10) + 1000000);
                            gen.SerializeAndTransform(full, fileName);
                        }
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("Error while processing " + table.FullName);
                        throw;
                    }
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine(ex.ToString());
                Console.ReadKey();
            }
        }
    }
}

