<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:thi="http://thi.ng/">
  <xsl:output method="text"/>
  <xsl:variable name="lcommentPrefix" select="';; '"/>
  <xsl:variable name="lcommentSuffix" select="''"/>
  <xsl:variable
      name="bcommentPrefix"
      select="';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;&#xA;;;'"/>
  <xsl:variable name="bcommentLPrefix" select="';; '"/>
  <xsl:variable
      name="bcommentSuffix"
      select="';;&#xA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'"/>
  <xsl:variable name="definePrefix" select="'(def '"/>
  <xsl:variable name="defineSuffix" select="')'"/>
  <xsl:variable name="sep" select="'-'"/>

  <xsl:function name="thi:lang-prologue">
    <xsl:text>(def &lt;&lt; bit-shift-left)&#xA;&#xA;</xsl:text>
  </xsl:function>

  <xsl:function name="thi:lang-epilogue">
  </xsl:function>

  <xsl:function name="thi:lang-def">
    <xsl:param name="sym" as="xs:string"/>
    <xsl:param name="val"/>
    <xsl:value-of select="concat('(def ',thi:lang-symbolname($sym),' ',$val,')')"/>
  </xsl:function>

  <xsl:function name="thi:lang-symbolname">
    <xsl:param name="body" as="xs:string"/>
    <xsl:value-of select="replace(fn:lower-case($body),'_','-')"/>
  </xsl:function>

  <xsl:function name="thi:lang-expr">
    <xsl:param name="op" as="xs:string"/>
    <xsl:param name="lhs"/>
    <xsl:param name="rhs"/>
    <xsl:value-of select="concat('(',$op,' ',$lhs,' ',$rhs,')')"/>
  </xsl:function>

  <xsl:include href="common.xsl"/>

</xsl:stylesheet>
