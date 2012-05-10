<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="r" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:r="http://www.example.org/documenttests">
	<xsl:output encoding="utf-8" indent="yes" method="xml"
		omit-xml-declaration="no"></xsl:output>
	<xsl:strip-space elements="*"></xsl:strip-space>
	<xsl:template match="r:error">
		<dt>
			<xsl:value-of select="@type" />
		</dt>
		<dd>
			<xsl:value-of select="@message" />
		</dd>
	</xsl:template>
	<xsl:template match="r:validation">
		<xsl:if test="count(r:error)&gt;0">
			<div class="popup">
				<h3>Validation errors:</h3>
				<dl>
					<xsl:apply-templates select="r:error" />
				</dl>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="r:xpath">
		<tr>
			<td>
				<xsl:value-of select="@result" />
			</td>
			<td>
				<xsl:value-of select="@expr" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="r:file">
		<div>
			<h3>
				<xsl:value-of select="@path" />
			</h3>
			<table>
				<xsl:apply-templates select="r:xpath" />
			</table>
		</div>
	</xsl:template>
	<xsl:template match="r:input|r:output">
		<div class="popup">
			<a>
				<xsl:attribute name="href">
				<xsl:value-of select="@path" />
			</xsl:attribute>
				<xsl:value-of select='local-name(.)' />
			</a>
			size:
			<xsl:value-of select="@size" />
		</div>
	</xsl:template>
	<xsl:template name="xpathresults">
		<xsl:param name="xpath" />
		<xsl:for-each
			select="../../../../r:target/r:output/r:file/r:xpath[@expr=$xpath]">
			<td>
				<xsl:value-of select="@result" />
			</td>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="r:testreport">
		<div class="testreport">
			<h1>
				<xsl:value-of select="@name" />
			</h1>
			<table>
				<tr>
					<td></td>
					<td>
						input
						<xsl:apply-templates select="r:input" />
					</td>
					<xsl:for-each select="r:target">
						<td>
							<xsl:value-of select="@name" />
							<xsl:apply-templates select="r:output" />
						</td>
					</xsl:for-each>
				</tr>
				<tr>
					<td>valid ODF</td>
					<td>
						<xsl:value-of select="count(r:input/r:validation/r:error)=0" />
						<xsl:apply-templates select="r:input/r:validation" />
					</td>
					<xsl:for-each select="r:target">
						<td>
							<xsl:value-of select="count(r:output/r:validation/r:error)=0" />
							<xsl:apply-templates select="r:output/r:validation" />
						</td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="r:target[position()=1]/r:output/r:file/r:xpath">
					<tr>
						<td>
							<xsl:value-of select="@expr" />
						</td>
						<td />
						<xsl:call-template name="xpathresults">
							<xsl:with-param name="xpath" select="@expr" />
						</xsl:call-template>
					</tr>
				</xsl:for-each>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="/r:documenttestsreport">
		<html>
			<head>
				<title>ODF Automatic tests report</title>
				<link rel="stylesheet" type="text/css" href="report.css" />
			</head>
			<body>
				<xsl:apply-templates select="r:testreport" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>