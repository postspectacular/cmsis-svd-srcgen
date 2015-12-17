<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:thi="http://thi.ng/">
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
    <xsl:value-of select="concat(' ',$lcommentPrefix,fn:normalize-space($body),$lcommentSuffix,'&#xA;')"/>
  </xsl:function>

  <xsl:function name="thi:block-comment">
    <xsl:param name="body" as="xs:string"/>
    <xsl:value-of select="concat($bcommentPrefix,fn:normalize-space($body),'&#xA;',$bcommentSuffix,'&#xA;')"/>
  </xsl:function>

  <xsl:template match="/device">
    <xsl:value-of select="thi:block-comment(concat(name, ' SVD peripherals &amp; registers'))"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:for-each select="peripherals/peripheral">
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
  </xsl:template>

  <xsl:template name="peripheral">
    <xsl:variable name="device" select="name"/>
    <xsl:choose>
      <xsl:when test="description">
        <xsl:value-of select="thi:block-comment(description)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="concat($definePrefix,$device,' ',fn:lower-case(baseAddress),$defineSuffix,'&#xA;')"/>
    <xsl:for-each select="registers/register">
      <xsl:call-template name="register">
        <xsl:with-param name="device" select="$device"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="peripheral-derived">
    <xsl:param name="src"/>
    <xsl:variable name="srcName" select="$src/name"/>
    <xsl:variable name="device" select="name"/>
    <xsl:choose>
      <xsl:when test="$src/description">
        <xsl:value-of select="thi:block-comment(concat($src/description, ' (derived from ', $srcName, ')'))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="concat($definePrefix,$device,' ',fn:lower-case(baseAddress),$defineSuffix,'&#xA;')"/>
    <xsl:for-each select="$src/registers/register">
      <xsl:call-template name="register">
        <xsl:with-param name="device" select="$device"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="register" >
    <xsl:param name="device"/>
    <xsl:variable name="reg" select="concat($device,$sep,name)"/>
    <xsl:value-of select="concat($definePrefix,$reg,' ',thi:lang-expr('+',$device,addressOffset),$defineSuffix)"/>
    <xsl:value-of select="thi:line-comment(description)"/>
    <xsl:for-each select="fields/field">
      <xsl:variable name="bw" as="xs:integer" select="bitWidth"/>
      <xsl:variable name="boff" as="xs:integer" select="bitOffset"/>
      <xsl:variable name="bmask" as="xs:string" select="$bitMasks[$bw]"/>
      <!-- field bit shift -->
      <xsl:value-of select="concat($definePrefix,$reg,$sep,name,$sep,'SHIFT ',$boff,$defineSuffix,'&#xA;')"/>
      <!-- field bit width -->
      <xsl:value-of select="concat($definePrefix,$reg,$sep,name,$sep,'RMASK ',$bmask,$defineSuffix,'&#xA;')"/>
      <!-- field shifted bitmask -->
      <xsl:value-of select="concat($definePrefix,$reg,$sep,name,$sep,'MASK ')"/>
      <xsl:choose>
        <xsl:when test="$boff > 0">
          <xsl:value-of select="thi:lang-expr('&lt;&lt;',$bmask,$boff)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$bmask"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$defineSuffix"/>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
