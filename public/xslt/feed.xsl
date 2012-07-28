<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom">

  <xsl:output method="html" encoding="utf-8"/>

  <xsl:template match="atom:feed">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">

      <!-- head -->
      <xsl:text>&#10;&#10;</xsl:text>
      <head>
        <link rel="stylesheet" href="/stylesheets/markdown/active4d.css" type="text/css" />
        <title><xsl:value-of select="atom:title"/></title>
      </head>

      <xsl:text>&#10;&#10;</xsl:text>
      <body>
        <xsl:text>&#10;</xsl:text>
        <h1><xsl:value-of select="atom:title"/></h1>
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:apply-templates select="atom:entry"/>
        <xsl:text>&#10;&#10;</xsl:text>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="atom:entry">
    <xsl:text>&#10;&#10;</xsl:text>
    <div>
      <!-- entry title -->
      <xsl:text>&#10;</xsl:text>
      <h3><xsl:value-of select="atom:title"/></h3>

      <!-- entry content -->
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
    </div>

  </xsl:template>
</xsl:stylesheet>