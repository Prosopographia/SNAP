<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:s='http://www.w3.org/2005/sparql-results#'
    xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output media-type="text/plain" encoding="UTF-8" omit-xml-declaration="yes"/>
    
    <xsl:variable name="start" select="671972"/>
    
    <xsl:template match="/">
       <xsl:text disable-output-escaping="yes">
           @prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
           @prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
           @prefix prov: &lt;http://www.w3.org/ns/prov#&gt; .
        
        </xsl:text>
        
        <xsl:apply-templates select="//s:results/s:result/s:binding/s:uri"/>
        
    </xsl:template>
    
 
    <xsl:template match="//s:results/s:result/s:binding/s:uri">
        
<xsl:text disable-output-escaping="yes">&lt;http://data.snapdrgn.net/person/</xsl:text><xsl:value-of select="$start + position()"/><!--<xsl:number level="any"/> --><xsl:text disable-output-escaping="yes">&gt;
            prov:wasDerivedFrom &lt;</xsl:text><xsl:value-of select="."/><xsl:text disable-output-escaping="yes">&gt; .
            
        </xsl:text>        
    </xsl:template> 
    
    
</xsl:stylesheet>