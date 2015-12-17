<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
  <xsl:output method="text"/>
  <xsl:variable name="lcommentPrefix" select="'// '" />
  <xsl:variable name="lcommentSuffix" select="''" />
  <xsl:variable
      name="bcommentPrefix"
      select="'/****************************************************************&#xA; * '" />
  <xsl:variable
      name="bcommentSuffix"
      select="' ****************************************************************/'" />
  <xsl:variable name="definePrefix" select="'#define '"/>
  <xsl:variable name="defineSuffix" select="''"/>
  
  <xsl:include href="common.xsl" />
  
</xsl:stylesheet>
