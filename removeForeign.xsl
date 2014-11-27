<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
	xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
	xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
	xmlns:db="urn:oasis:names:tc:opendocument:xmlns:database:1.0"
	xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
	xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
	xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0"
	xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
	xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
	xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
	xmlns:odf="http://docs.oasis-open.org/ns/office/1.2/meta/odf#"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0">
	<xsl:output encoding="utf-8" indent="no" method="xml"
		omit-xml-declaration="no"></xsl:output>
	<xsl:template match="@*">
	</xsl:template>
    <xsl:template match="processing-instruction('DOCTYPE')">
    </xsl:template>
	<!-- only copy attributes from allowed namespaces -->
	<xsl:template
		match="@anim:*|@chart:*|@config:*|@db:*|@dr3d:*|@draw:*|@form:*|@manifest:*|@meta:*|@number:*|@office:*|@presentation:*|@script:*|@table:*|@text:*|@style:*|@odf:*|@fo:*|@svg:*|@smil:*|@xml:*|node()">
		<xsl:copy>
			<xsl:apply-templates
				select="@*|node()" />
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>