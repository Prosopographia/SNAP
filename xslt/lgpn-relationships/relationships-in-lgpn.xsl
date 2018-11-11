<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="tei:TEI">
        <listRelation>
            <xsl:text>&#xa;</xsl:text>
            <xsl:for-each-group select="//tei:person[child::tei:state[@key='#relationship']]"
                group-by="child::tei:birth/tei:placeName/@key">
                <xsl:comment select="child::tei:birth/tei:placeName"/>
                <xsl:text>&#xa;   </xsl:text>
                <xsl:variable name="allcity">
                    <xsl:sequence select="current-group()"/>
                </xsl:variable>
                <xsl:for-each select="$allcity/tei:person">
                    <xsl:variable name="currid" select="@xml:id"/>
                    <xsl:variable name="birthdate" select="concat(tei:birth/@notBefore,'/',tei:birth/@notAfter)"/>
                    <xsl:for-each select="child::tei:state[@key='#relationship']">
                        <xsl:variable name="state">
                            <xsl:sequence select="."/>
                        </xsl:variable>
                        <xsl:variable name="relative"
                            select="normalize-space(normalize-unicode(child::tei:label/tei:persName[1]/tokenize(@nymRef,' ')[last()]))"/>
                        <xsl:variable name="myname"
                            select="normalize-space(normalize-unicode(parent::tei:person/tei:persName[1]/@nymRef))"/>
                        <xsl:variable name="mybibl"
                            select="normalize-space(following-sibling::bibl[1])"/>
                        <xsl:variable name="reltype">
                            <xsl:choose>
                                <xsl:when test="starts-with(normalize-space($state), 'f./m.')"><xsl:text>Parent</xsl:text></xsl:when>
                                <xsl:when test="starts-with(normalize-space($state), 's./d.')"><xsl:text>Child</xsl:text></xsl:when>
                                <xsl:when test="normalize-space(substring-before($state, '.'))='m'"><xsl:text>Mother</xsl:text></xsl:when>
                                <xsl:when test="normalize-space(substring-before($state, '.'))='f'"><xsl:text>Father</xsl:text></xsl:when>
                                <xsl:when test="normalize-space(substring-before($state, '.'))='d'"><xsl:text>Daughter</xsl:text></xsl:when>
                                <xsl:when test="normalize-space(substring-before($state, '.'))='s'"><xsl:text>Son</xsl:text></xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="relgeneric">
                            <xsl:choose>
                                <xsl:when test="$reltype = ('Father','Mother','Parent')"><xsl:text>Parent</xsl:text></xsl:when>
                                <xsl:when test="$reltype = ('Son','Daughter','Child')"><xsl:text>Child</xsl:text></xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="target">
                            <xsl:choose>
                                <!-- when there is only one person (apart from me) with the name of my relative in this city -->
                                <xsl:when
                                    test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative])=1">
                                    <xsl:value-of select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]/@xml:id"/>
                                </xsl:when>
                                <!-- when there is only one person with the name of my relative in this city,
                                    who has a relative listed who has my name -->
                                <xsl:when
                                    test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                    [tei:state[@key='#relationship']/tei:label/tei:persName[1]/@nymRef[.=$myname]])=1">
                                    <xsl:value-of
                                        select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                        [tei:state[@key='#relationship']/tei:label/tei:persName[1]/@nymRef[.=$myname]]/@xml:id"/>
                                </xsl:when>
                                <!-- when there is only one person with the name of my relative in this city
                                    who cites the same bibliography as I do -->
                                <xsl:when
                                    test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                    [normalize-space(tei:bibl[1])=$mybibl])=1">
                                    <xsl:value-of
                                        select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                        [normalize-space(tei:bibl[1])=$mybibl]/@xml:id"/>
                                </xsl:when>
                                <!-- when there is only one person with the name of my relative in this city
                                    who cites the same pre-comma bibliography-string as I do -->
                                <xsl:when
                                    test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                    [substring-before(normalize-space(tei:bibl[1]),',')=substring-before($mybibl,',')])=1">
                                    <xsl:value-of
                                        select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                        [substring-before(normalize-space(tei:bibl[1]),',')=substring-before($mybibl,',')]/@xml:id"/>
                                </xsl:when>
                                <!-- when there is only one person with the name of my relative in this city
                                who has a parent with my name (if I'm a child) or a child with my name (if I'm a parent)-->
                                <xsl:when test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                    [tei:state[@key='#relationship']
                                    [(normalize-space(substring-before(., '.'))=('f','m') and $relgeneric='Child')
                                    or (normalize-space(substring-before(., '.'))=('s','d') and $relgeneric='Parent')]
                                    /tei:label[1]/tei:persName[1]/@nymRef[tokenize(.,' ')[last()]=$myname]])=1">
                                    <xsl:value-of select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                        [tei:state[@key='#relationship']
                                        [(normalize-space(substring-before(., '.'))=('f','m') and $relgeneric='Child')
                                        or (normalize-space(substring-before(., '.'))=('s','d') and $relgeneric='Parent')]
                                        /tei:label[1]/tei:persName[1]/@nymRef[tokenize(.,' ')[last()]=$myname]]/@xml:id"/>
                                </xsl:when>
                                <!-- when there is only one person with the name of my relative in this city
                                who has a parent with my name (if I'm a child) or a child with my name (if I'm a parent)
                                and who has exactly the same dates as me -->
                                <xsl:when test="count($allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                    [tei:state[@key='#relationship']
                                    [(normalize-space(substring-before(., '.'))=('f','m') and $relgeneric='Child')
                                    or (normalize-space(substring-before(., '.'))=('s','d') and $relgeneric='Parent')]
                                    /tei:label[1]/tei:persName[1]/@nymRef[tokenize(.,' ')[last()]=$myname]]
                                    [concat(child::tei:birth/@notBefore,'/',child::tei:birth/@notAfter) = $birthdate])=1">
                                    <xsl:value-of select="$allcity/tei:person[@xml:id!=$currid][normalize-space(normalize-unicode(child::tei:persName[1]/@nymRef))=$relative]
                                        [tei:state[@key='#relationship']
                                        [(normalize-space(substring-before(., '.'))=('f','m') and $relgeneric='Child')
                                        or (normalize-space(substring-before(., '.'))=('s','d') and $relgeneric='Parent')]
                                        /tei:label[1]/tei:persName[1]/@nymRef[tokenize(.,' ')[last()]=$myname]]
                                        [concat(child::tei:birth/@notBefore,'/',child::tei:birth/@notAfter) = $birthdate]/@xml:id"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="string($target)">
                            <relation>
                                <xsl:attribute name="n" select="position()"/>
                                <xsl:attribute name="active" select="concat('http://www.lgpn.ox.ac.uk/id/',$currid)"/>
                                <xsl:attribute name="passive" select="concat('http://www.lgpn.ox.ac.uk/id/',$target)"/>
                                <xsl:attribute name="name" select="concat('snap:',$reltype,'Of')"/>
                            </relation>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each-group>
        </listRelation>
    </xsl:template>

</xsl:stylesheet>
