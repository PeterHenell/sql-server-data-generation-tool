<?xml version="1.0" encoding="utf-8" ?>


<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt" version="1.0" xml:space="default">
<xsl:output method="text"/>


  <xsl:variable name="UseIdentityInsert">
    <xsl:value-of select="/FullTableImage/Table/UseIdentityInsert"/>
  </xsl:variable>

  <xsl:variable name="UseWhenMatchedClause" select="/FullTableImage/Table/IncludeWhenMatchedClause" />
  
  
  <xsl:template match="/">

    SET QUOTED_IDENTIFIER ON

    <xsl:if test="$UseIdentityInsert = 'true'">
    SET IDENTITY_INSERT <xsl:value-of select="/FullTableImage/Table/SchemaName" />.<xsl:value-of select="/FullTableImage/Table/TableName" /> ON
    </xsl:if>
    
    MERGE <xsl:value-of select="/FullTableImage/Table/SchemaName" />.<xsl:value-of select="/FullTableImage/Table/TableName" /> AS TARGET
    USING
    (
<xsl:call-template name="MassOfSelectStatements"></xsl:call-template>
    ) 
    AS SOURCE (<xsl:call-template name="AllColumnsColonSeparated" /> )

    ON (<xsl:call-template name="OnStatement" />)


<xsl:if test="$UseWhenMatchedClause = 'true'">
    WHEN MATCHED THEN
    UPDATE SET
    <xsl:call-template name="UpdateStatement" />
</xsl:if>

    WHEN NOT MATCHED BY TARGET THEN
      INSERT (<xsl:call-template name="InsertAbleColumnsColonSeparated" />)
      VALUES (<xsl:call-template name="InsertValuesColonSeparated" />)

    -- OUTPUT $ACTION, INSERTED.*

    ;
    
    <xsl:if test="$UseIdentityInsert = 'true'">
      SET IDENTITY_INSERT <xsl:value-of select="/FullTableImage/Table/SchemaName" />.<xsl:value-of select="/FullTableImage/Table/TableName" /> OFF
    </xsl:if>
  </xsl:template>


  <xsl:template name="MassOfSelectStatements">
    <xsl:for-each select="/FullTableImage/Rows/TableRow" >
      <xsl:text>      SELECT </xsl:text>
      <xsl:for-each select="./Columns/Column">

        <xsl:choose>
          <xsl:when test="Data != ''">
              <xsl:call-template name="FormatData" />
          </xsl:when>
          <xsl:otherwise>
              <xsl:text>NULL</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="position()!=last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="position()!=last()">
        <xsl:text> UNION ALL
</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="FormatData">
    
    <xsl:choose>    
      
      <xsl:when test="DataType = 'datetime' or DataType = 'varchar' or DataType = 'char' or DataType = 'nvarchar' or DataType = 'nchar' or DataType = 'text' or DataType = 'text' or DataType = 'date' or DataType = 'time' or DataType = 'smalldatetime' or DataType = 'image' or DataType = 'datetime2'">
        <xsl:choose>
          <xsl:when test="DefaultValue and /FullTableImage/Table[UseDefaultValues = 'true']">
            <xsl:value-of select="DefaultValue"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>'</xsl:text>
            <xsl:value-of select="Data"/>
            <xsl:text>'</xsl:text>    
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="DataType = 'float' or DataType = 'decimal' or DataType = 'numeric'  or DataType = 'money' or DataType = 'smallmoney'">
        <xsl:variable name="cleanData">
          <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="Data" />
            <xsl:with-param name="replace" select="','" />
            <xsl:with-param name="by" select="'.'" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$cleanData"/>
        
      </xsl:when>
      
      <xsl:when test="DataType = 'bit'">
        <xsl:choose>
          <xsl:when test="Data = 'True'">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>0</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:value-of select="Data"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="OnStatement">
    <xsl:for-each select="/FullTableImage/Table/UseAsPrimaryKeyColumns/Column">
      <xsl:text>TARGET.[</xsl:text>
      <xsl:value-of select="./ColumnName"/>
      <xsl:text>] = SOURCE.[</xsl:text>
      <xsl:value-of select="./ColumnName"/>
      <xsl:text>]</xsl:text>
      <xsl:if test="position()!=last()">
        <xsl:text> AND </xsl:text>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template name="UpdateStatement">
    <xsl:for-each select="/FullTableImage/Table/UpdateColumns/Column">
      <xsl:text>[</xsl:text><xsl:value-of select="./ColumnName"/>] = SOURCE.[<xsl:value-of select="./ColumnName"/>]
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="InsertValuesColonSeparated">
     
    <xsl:for-each select="/FullTableImage/Table/InsertColumns/Column">
      <xsl:text>SOURCE.[</xsl:text>
      <xsl:value-of select="ColumnName"/>
      <xsl:text>]</xsl:text>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="InsertAbleColumnsColonSeparated">
    <xsl:for-each select="/FullTableImage/Table/InsertColumns/Column">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="ColumnName"/>
      <xsl:text>]</xsl:text>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="AllColumnsColonSeparated">
    <xsl:for-each select="/FullTableImage/Schema/Columns/Column">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="ColumnName"/>
      <xsl:text>]</xsl:text>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>