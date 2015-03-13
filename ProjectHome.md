Tool used to extract data from a SQL Server to scripts files. These scripts will include insert commands to insert all the extracted data.

The tool will generate one file for each table in the database. The files will be numbered (using a prefix) so that if you run them one by one there will not be any foreign key constraint errors.

This tools is useful for extracting small sets of configuration data that you want to version control or need for testing.