<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:thi="http://thi.ng/">

  <xsl:param name="only" as="xs:string" required="no">
    <xsl:value-of select="''"/>
  </xsl:param>

  <xsl:param name="excl" as="xs:string" required="no">
    <xsl:value-of select="''"/>
  </xsl:param>

  <xsl:variable name="NL" select="'&#xA;'"/>

  <xsl:variable name="bitMasks" as="element()*">
    <Item>0x1</Item>
    <Item>0x3</Item>
    <Item>0x7</Item>
    <Item>0xf</Item>
    <Item>0x1f</Item>
    <Item>0x3f</Item>
    <Item>0x7f</Item>
    <Item>0xff</Item>
    <Item>0x1ff</Item>
    <Item>0x3ff</Item>
    <Item>0x7ff</Item>
    <Item>0xfff</Item>
    <Item>0x1fff</Item>
    <Item>0x3fff</Item>
    <Item>0x7fff</Item>
    <Item>0xffff</Item>
    <Item>0x1ffff</Item>
    <Item>0x3ffff</Item>
    <Item>0x7ffff</Item>
    <Item>0xfffff</Item>
    <Item>0x1fffff</Item>
    <Item>0x3fffff</Item>
    <Item>0x7fffff</Item>
    <Item>0xffffff</Item>
    <Item>0x1ffffff</Item>
    <Item>0x3ffffff</Item>
    <Item>0x7ffffff</Item>
    <Item>0xfffffff</Item>
    <Item>0x1fffffff</Item>
    <Item>0x3fffffff</Item>
    <Item>0x7fffffff</Item>
    <Item>0xffffffff</Item>
  </xsl:variable>

  <xsl:function name="thi:line-comment">
    <xsl:param name="body" as="xs:string"/>
    <xsl:value-of select="concat(' ',$lcommentPrefix,fn:normalize-space($body),$lcommentSuffix,$NL)"/>
  </xsl:function>

  <xsl:function name="thi:block-comment">
    <xsl:param name="body" as="xs:string"/>
    <xsl:value-of select="concat($bcommentPrefix,$NL,$bcommentLPrefix,replace($body,$NL,concat($NL,$bcommentLPrefix)),$NL,$bcommentSuffix,$NL)"/>
  </xsl:function>

  <xsl:template match="/device">
    <xsl:variable name="header">
      <xsl:value-of select="name"/>
      <xsl:text> SVD peripherals &amp; registers&#xA;generated @ </xsl:text>
      <xsl:value-of select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]', 'en', (), ())"/>
      <xsl:text>&#xA;&#xA;DO NOT EDIT! This file was auto-generated with:</xsl:text>
      <xsl:text>&#xA;http://github.com/postspectacular/cmsis-svd-srcgen</xsl:text>
    </xsl:variable>
    <xsl:value-of select="thi:block-comment($header)"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="thi:lang-prologue()"/>
    <xsl:for-each select="peripherals/peripheral/name[(not($only) or fn:contains($only, text())) and (not($excl) or not(fn:contains($excl, text())))]/..">
      <xsl:variable name="derived" select="@derivedFrom"/>
      <xsl:choose>
        <xsl:when test="$derived">
          <xsl:call-template name="peripheral-derived">
            <xsl:with-param name="src" select="../peripheral/name[text()=$derived]/.."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="peripheral"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="thi:lang-epilogue()"/>
  </xsl:template>

  <xsl:template name="peripheral">
    <xsl:variable name="device" select="thi:lang-symbolname(name)"/>
    <xsl:choose>
      <xsl:when test="description">
        <xsl:value-of select="thi:block-comment(fn:normalize-space(description))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="concat(thi:lang-def($device,fn:lower-case(baseAddress)),$NL)"/>
    <xsl:for-each select="registers/register">
      <xsl:call-template name="register">
        <xsl:with-param name="device" select="$device"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="peripheral-derived">
    <xsl:param name="src"/>
    <xsl:variable name="srcName" select="$src/name"/>
    <xsl:variable name="device" select="thi:lang-symbolname(name)"/>
    <xsl:choose>
      <xsl:when test="$src/description">
        <xsl:value-of select="thi:block-comment(concat(fn:normalize-space($src/description), ' (derived from ', $srcName, ')'))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="concat(thi:lang-def($device,fn:lower-case(baseAddress)),$NL)"/>
    <xsl:for-each select="$src/registers/register">
      <xsl:call-template name="register">
        <xsl:with-param name="device" select="$device"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="register" >
    <xsl:param name="device"/>
    <xsl:variable name="reg" select="concat($device,$sep,name)"/>
    <xsl:variable name="offset" select="fn:lower-case(addressOffset)"/>
    <xsl:value-of select="thi:lang-def($reg,thi:lang-expr('+',$device,$offset))"/>
    <xsl:value-of select="thi:line-comment(description)"/>
    <xsl:value-of select="concat(thi:lang-def(concat($reg,$sep,'OFFSET'),$offset),$NL)"/>
    <xsl:choose>
      <xsl:when test="resetValue">
        <xsl:value-of select="concat(thi:lang-def(concat($reg,$sep,'RESET'),resetValue),$NL)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:for-each select="fields/field">
      <xsl:variable name="bw" as="xs:integer" select="bitWidth"/>
      <xsl:variable name="boff" as="xs:integer" select="bitOffset"/>
      <xsl:variable name="zmask" as="xs:string" select="$bitMasks[$bw]"/>
      <xsl:variable name="fname" as="xs:string" select="concat($reg,$sep,name)"/>
      <xsl:variable name="mask">
        <xsl:choose>
          <xsl:when test="$boff > 0">
            <xsl:value-of select="thi:lang-expr('&lt;&lt;',$zmask,$boff)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$zmask"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- field shifted bitmask -->
      <xsl:value-of select="concat(thi:lang-def($fname,$mask),$NL)"/>
      <!-- field bit shift -->
      <xsl:value-of
          select="concat(thi:lang-def(concat($fname,$sep,'SHIFT'),$boff),$NL)"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
