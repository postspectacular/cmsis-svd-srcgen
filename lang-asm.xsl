<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:thi="http://thi.ng/">
  <xsl:output method="text"/>
  <xsl:variable name="lcommentPrefix" select="'// '"/>
  <xsl:variable name="lcommentSuffix" select="''"/>
  <xsl:variable
      name="bcommentPrefix"
      select="'/****************************************************************'"/>
  <xsl:variable name="bcommentLPrefix" select="' * '"/>
  <xsl:variable
      name="bcommentSuffix"
      select="' ****************************************************************/'"/>
  <xsl:variable name="definePrefix" select="'.equ '"/>
  <xsl:variable name="defineSuffix" select="''"/>
  <xsl:variable name="sep" select="'_'"/>

  <xsl:function name="thi:lang-prologue">
    <xsl:text>#ifndef _CMSIS_SVD_H&#xA;#define _CMSIS_SVD_H&#xA;&#xA;</xsl:text>
  </xsl:function>

  <xsl:function name="thi:lang-epilogue">
    <xsl:text>#endif&#xA;</xsl:text>
  </xsl:function>

  <xsl:function name="thi:lang-def">
    <xsl:param name="sym" as="xs:string"/>
    <xsl:param name="val"/>
    <xsl:value-of select="concat('.equ ',thi:lang-symbolname($sym),', ',$val)"/>
  </xsl:function>

  <xsl:function name="thi:lang-symbolname">
    <xsl:param name="body" as="xs:string"/>
    <xsl:value-of select="$body"/>
  </xsl:function>

  <xsl:function name="thi:lang-expr">
    <xsl:param name="op" as="xs:string"/>
    <xsl:param name="lhs"/>
    <xsl:param name="rhs"/>
    <xsl:value-of select="concat('(',$lhs,' ',$op,' ',$rhs,')')"/>
  </xsl:function>

  <xsl:include href="common.xsl"/>

</xsl:stylesheet>
