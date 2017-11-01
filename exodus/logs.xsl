<?xml version="1.0" ?> 
<xsl:stylesheet version="1.0" xmlns:client="jabber:client" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:stream="http://etherx.jabber.org/streams">
<xsl:variable name="from" select="substring-before(stream:stream/@from, '@')" /> 
<xsl:variable name="to" select="substring-before(stream:stream/@to, '@')" /> 
<xsl:template match="/">
<html>
<head>
<title>Message log</title> 
</head>
<body>
<p>
Conversation with: 
<b>
<xsl:value-of select="stream:stream/@to" /> 
</b>
</p>
<table border="0">
<xsl:apply-templates select="stream:stream/client:message/client:body" /> 
</table>
</body>
</html>
</xsl:template>
<xsl:template match="client:message/client:body">
<tr>
<td align="right" style="color: blue;">
&lt;
<xsl:value-of select="$to" /> 
&gt;
</td>
<td>
<xsl:value-of select="text()" /> 
</td>
</tr>
</xsl:template>
<xsl:template match="client:message[@to=/stream:stream/@to]/client:body">
<tr>
<td align="right" style="color: red;">
&lt;
<xsl:value-of select="$from" /> 
&gt; 
</td>
<td>
<xsl:value-of select="text()" /> 
</td>
</tr>
</xsl:template>
</xsl:stylesheet>