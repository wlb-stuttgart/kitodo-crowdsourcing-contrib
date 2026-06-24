<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns="http://www.loc.gov/mods/v3"
                xmlns:kitodo="http://meta.kitodo.org/v1/"
                xmlns:wlb="http://digital.wlb-stuttgart.de/ns/wlb"
                xmlns:dv="https://dfg-viewer.de/profil-der-metadaten/"
                exclude-result-prefixes="kitodo">
    <xsl:output method="xml"
                indent="yes"
                encoding="utf-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/*">
        <xsl:copy>
            <xsl:namespace name="dv">
                <xsl:value-of select="'https://dfg-viewer.de/profil-der-metadaten/'"/>
            </xsl:namespace>
            <xsl:namespace name="xlink">
                <xsl:value-of select="'http://www.w3.org/1999/xlink'"/>
            </xsl:namespace>
            <xsl:namespace name="wlb">
                <xsl:value-of select="'http://digital.wlb-stuttgart.de/ns/wlb'"/>
            </xsl:namespace>
            <xsl:namespace name="zvdd">
                <xsl:value-of select="'http://zvdd.gdz-cms.de/'"/>
            </xsl:namespace>
            <xsl:namespace name="">
                <xsl:value-of select="'http://www.loc.gov/mods/v3'"/>
            </xsl:namespace>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mets:mets">
        <mets:mets>
            <xsl:apply-templates select="@*|node()"/>
        </mets:mets>
    </xsl:template>

    <!-- ### METS header -->
    <xsl:template match="mets:metsHdr">
        <mets:metsHdr>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="node()"/>
        </mets:metsHdr>
    </xsl:template>

    <xsl:template match="mets:dmdSec[@ID!='']">
        <mets:dmdSec>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </mets:dmdSec>
    </xsl:template>

    <xsl:template match="mets:amdSec[@ID!='']">
        <mets:amdSec>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </mets:amdSec>
    </xsl:template>

    <!-- Replace existing mdWrap with new, empty MODS mdWrap and metadata placeholder -->
    <xsl:template match="mets:dmdSec/mets:mdWrap[@MDTYPE='OTHER' and @OTHERMDTYPE='KITODO']">
        <mets:mdWrap MDTYPE="MODS">
            <mets:xmlData>
                <mods>
                    <xsl:apply-templates/>
                    METADATAPLACEHOLDER <!-- this placeholder is replaced with result of marc21slim2mods transformation -->
                </mods>
            </mets:xmlData>
        </mets:mdWrap>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:rightsMD/mets:mdWrap">
        <mets:amdSec>
            <mets:rightsMD>
                <xsl:copy>
                    <xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
                    <xsl:attribute name="MIMETYPE">text/xml</xsl:attribute>
                    <xsl:attribute name="OTHERMDTYPE">DVRIGHTS</xsl:attribute>
                    <xsl:apply-templates
                            select="@*[local-name() != 'MDTYPE' and local-name() != 'OTHERMDTYPE' and local-name() != 'MIMETYPE'] | node()"/>
                </xsl:copy>
            </mets:rightsMD>
        </mets:amdSec>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:digiprovMD/mets:mdWrap">
        <mets:amdSec>
            <mets:digiprovMD>
                <xsl:copy>
                    <xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
                    <xsl:attribute name="MIMETYPE">text/xml</xsl:attribute>
                    <xsl:attribute name="OTHERMDTYPE">DVLINKS</xsl:attribute>
                    <xsl:apply-templates
                            select="@*[local-name() != 'MDTYPE' and local-name() != 'OTHERMDTYPE' and local-name() != 'MIMETYPE'] | node()"/>
                </xsl:copy>
            </mets:digiprovMD>
        </mets:amdSec>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:rightsMD/mets:mdWrap/mets:xmlData/kitodo:kitodo">
        <xsl:variable name="owner" select="kitodo:metadata[@name='owner']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerContact"
                      select="kitodo:metadata[@name='ownerContact']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerLogo"
                      select="kitodo:metadata[@name='ownerLogo']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerSiteURL"
                      select="kitodo:metadata[@name='ownerSiteURL']"/><!-- metadata from project configuration -->
        <xsl:variable name="rights"
                      select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='Zugriffslizenz']"/><!-- metadata from the dmdSec -->
        <dv:rights>
            <xsl:if test="$owner">
                <dv:owner>
                    <xsl:value-of select="normalize-space($owner)"/>
                </dv:owner>
            </xsl:if>
            <xsl:if test="$ownerLogo">
                <dv:ownerLogo>
                    <xsl:value-of select="normalize-space($ownerLogo)"/>
                </dv:ownerLogo>
            </xsl:if>
            <xsl:if test="$ownerSiteURL">
                <dv:ownerSiteURL>
                    <xsl:value-of select="normalize-space($ownerSiteURL)"/>
                </dv:ownerSiteURL>
            </xsl:if>
            <xsl:if test="$ownerContact">
                <dv:ownerContact>
                    <xsl:value-of select="normalize-space($ownerContact)"/>
                </dv:ownerContact>
            </xsl:if>
            <xsl:if test="$rights">
                <dv:license>
                    <xsl:choose>
                        <xsl:when test="($rights = 'https://creativecommons.org/publicdomain/mark/1.0/')">
                            <xsl:text>https://creativecommons.org/publicdomain/mark/1.0/</xsl:text>
                        </xsl:when>
                        <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz/1.0/')">
                            <xsl:text>http://rightsstatements.org/vocab/InC/1.0/</xsl:text>
                        </xsl:when>
                        <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz-andere/1.0/')">
                            <xsl:text>http://rightsstatements.org/vocab/NoC-OKLR/1.0/</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </dv:license>
            </xsl:if>
        </dv:rights>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:digiprovMD/mets:mdWrap/mets:xmlData/kitodo:kitodo">
        <xsl:variable name="ppn"
                      select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='0100']"/>
        <xsl:variable name="url"
                      select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='4950']"/>
        <dv:links>
            <dv:presentation>
                <xsl:value-of select="normalize-space($url)"/>
            </dv:presentation>
            <xsl:if test="$ppn">
                <dv:reference>
                    <xsl:value-of select="normalize-space(concat('https://swb.bsz-bw.de/DB=2.1/PPNSET?PPN=',$ppn))"/>
                </dv:reference>
            </xsl:if>
        </dv:links>
    </xsl:template>


    <!-- Zugriffslizenz -->
    <xsl:template match="kitodo:metadata[@name='Zugriffslizenz']">
        <xsl:variable name="rights" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="($rights = 'https://creativecommons.org/publicdomain/mark/1.0/')">
                <accessCondition type="use and reproduction"
                                      xlink:href="https://creativecommons.org/publicdomain/mark/1.0/">
                    <xsl:text>Public Domain Mark 1.0</xsl:text>
                </accessCondition>
                <accessCondition displayLabel="Access Status" type="restriction on access"
                                      xlink:href="http://purl.org/coar/access_right/c_abf2">
                    <xsl:text>Open Access</xsl:text>
                </accessCondition>
            </xsl:when>
            <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz/1.0/')">
                <accessCondition type="use and reproduction"
                                      xlink:href="http://rightsstatements.org/vocab/InC/1.0/">
                    <xsl:text>Urheberrechtsschutz</xsl:text>
                </accessCondition>
                <accessCondition type="local terms of use"
                                      xlink:href="http://digital.wlb-stuttgart.de/lizenzen/rv-fz/1.0/">
                    <xsl:text>Rechte vorbehalten - Freier Zugang</xsl:text>
                </accessCondition>
                <accessCondition displayLabel="Access Status" type="restriction on access"
                                      xlink:href="http://purl.org/coar/access_right/c_abf2">
                    <xsl:text>Open Access</xsl:text>
                </accessCondition>
            </xsl:when>
            <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz-andere/1.0/')">
                <accessCondition type="use and reproduction"
                                      xlink:href="http://rightsstatements.org/vocab/NoC-OKLR/1.0/">
                    <xsl:text>Kein Urheberrechtsschutz - Andere rechtliche Beschränkungen</xsl:text>
                </accessCondition>
                <accessCondition type="local terms of use"
                                      xlink:href="http://digital.wlb-stuttgart.de/lizenzen/rv-fz-andere/1.0/">
                    <xsl:text>Rechte vorbehalten - Freier Zugang</xsl:text>
                </accessCondition>
                <accessCondition displayLabel="Access Status" type="restriction on access"
                                      xlink:href="http://purl.org/coar/access_right/c_abf2">
                    <xsl:text>Open Access</xsl:text>
                </accessCondition>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Digitale Kollektionen -->
    <xsl:template match="kitodo:metadata[@name='DigitaleKollektion']">
        <xsl:variable name="collection" select="."/>
        <xsl:if test="$collection">
            <xsl:for-each select="$collection">
                <classification authority="WLB">
                    <xsl:value-of select="normalize-space(.)"/>
                </classification>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$collection">
            <extension>
                <wlb:wlb>
                    <xsl:if test="$collection">
                        <xsl:for-each select="$collection">
                            <wlb:collection>
                                <xsl:value-of select="normalize-space(.)"/>
                            </wlb:collection>
                        </xsl:for-each>
                    </xsl:if>
                </wlb:wlb>
            </extension>
        </xsl:if>
    </xsl:template>

    <!-- Volltext -->
    <xsl:template match="kitodo:metadata[@name='Volltext']">
        <xsl:if test="normalize-space(.)">
            <!-- TODO: verify that this mapping is ok -->
            <note type="fulltext">
                <xsl:value-of select="normalize-space(.)"/>
            </note>
        </xsl:if>
    </xsl:template>

    <!-- Signatur -->
    <xsl:template match="kitodo:metadata[@name='Signatur']">
        <xsl:if test="normalize-space(.)">
            <location>
                <shelfLocator>
                    <xsl:value-of select="normalize-space(.)"/>
                </shelfLocator>
                <physicalLocation valueURI="https://ld.zdb-services.de/resource/organisations/DE-24">
                    <xsl:text>Württembergische Landesbibliothek Stuttgart</xsl:text>
                </physicalLocation>
            </location>
        </xsl:if>
    </xsl:template>

    <!-- PPN -->
    <xsl:template match="kitodo:metadata[@name='0100']">
        <xsl:if test="normalize-space(.)">
            <identifier type="kxp-ppn">
                <xsl:value-of select="normalize-space(.)"/>
            </identifier>
        </xsl:if>
    </xsl:template>

    <!-- URN -->
    <xsl:template match="kitodo:metadata[@name='2050']">
        <xsl:if test="normalize-space(.)">
            <identifier type="urn">
                <xsl:value-of select="normalize-space(.)"/>
            </identifier>
        </xsl:if>
    </xsl:template>

    <!-- ### File Section -->
    <xsl:template match="mets:fileSec">
        <mets:fileSec>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="node()"/>
        </mets:fileSec>
    </xsl:template>

    <!-- ### LOGICAL structure map -->
    <xsl:template match="mets:structMap[@TYPE='LOGICAL']">
        <mets:structMap>
            <xsl:copy-of select="@*"/>
            <!-- TYPE='physSequence' in the physical root div is required by Kitodo.Presentation -->
            <xsl:for-each select="mets:div">
                <xsl:call-template name="logical_div_template"/>
            </xsl:for-each>
        </mets:structMap>
    </xsl:template>

    <!-- ### DIVs in logical struct map ### -->
    <xsl:template name="logical_div_template">
        <xsl:element name="mets:div">
            <!-- add title metadata of corresponding dmdSec as label -->
            <xsl:variable name="dmdid" select="./@DMDID"/>
            <xsl:if test="$dmdid !=''">
                <!--add ADMDID to primary mets:div-->
                <xsl:if test="$dmdid = /mets:mets/mets:dmdSec[1]/@ID">
                    <xsl:attribute name="ADMID">AMD</xsl:attribute>
                </xsl:if>
                <!-- only use "titles" without "type"! -->
                <xsl:variable name="title"
                              select="/mets:mets/mets:dmdSec[@ID=$dmdid]/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadataGroup[@name='4000'][not(kitodo:metadata[@name='type'])]/kitodo:metadata[@name='4000_1']/text()"/>
                <xsl:if test="$title!=''">
                    <xsl:attribute name="LABEL">
                        <xsl:value-of select="$title"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:copy-of select="@*"/>
            <!-- Map 'Plakat' to 'poster' _after_ copying all element attributes (otherwise 'poster' is overwritten by 'Plakat' again) -->
            <xsl:variable name="type" select="./@TYPE"/>
            <xsl:choose>
                <xsl:when test="$type='Plakat'">
                    <xsl:attribute name="TYPE">poster</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="TYPE"><xsl:value-of select="$type"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="mets:mptr"/>
            <xsl:for-each select="mets:div">
                <xsl:call-template name="logical_div_template"/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <!-- ### PHYSICAL structure map -->
    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']">
        <xsl:if test="count(mets:div) gt 0 and count(mets:div/mets:div) gt 0">
            <mets:structMap>
                <xsl:copy-of select="@*"/>
                <!-- TYPE='physSequence' in the physical root div is required by Kitodo.Presentation -->
                <xsl:for-each select="mets:div">
                    <xsl:element name="mets:div">
                        <xsl:attribute name="TYPE">physSequence</xsl:attribute>
                        <xsl:copy-of select="@*"/>
                        <xsl:copy-of select="node()"/>
                    </xsl:element>
                </xsl:for-each>
            </mets:structMap>
        </xsl:if>
    </xsl:template>

    <!-- ### Structure links -->
    <xsl:template match="mets:structLink">
        <xsl:if test="count(mets:smLink) gt 0">
            <mets:structLink>
                <xsl:copy-of select="@*"/>
                <xsl:copy-of select="node()"/>
            </mets:structLink>
        </xsl:if>
    </xsl:template>

    <!-- ### Ignore unmapped text ### -->
    <xsl:template match="text()"/>

</xsl:stylesheet>