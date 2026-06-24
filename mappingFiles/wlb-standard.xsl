<?xml version="1.0" encoding="UTF-8" ?>
<!--
 *
 * (c) Kitodo. Key to digital objects e. V. <contact@kitodo.org>
 *
 * This file is part of the Kitodo project.
 *
 * It is licensed under GNU General Public License version 3 or later.
 *
 * For the full copyright and license information, please read the
 * GPL3-License.txt file that was distributed with this source code.
 *
-->

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:dv="https://dfg-viewer.de/profil-der-metadaten/"
                xmlns:kitodo="http://meta.kitodo.org/v1/" 
                xmlns:mods="http://www.loc.gov/mods/v3" 
                xmlns:mets="http://www.loc.gov/METS/" 
                xmlns:xlink="http://www.w3.org/1999/xlink" 
                xmlns:wlb="http://digital.wlb-stuttgart.de/ns/wlb" 
                xmlns:zvdd="http://zvdd.gdz-cms.de/" 
                >
    <xsl:output method="xml" indent="yes" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/*">
        <xsl:copy>
            <xsl:namespace name="dv">
                <xsl:value-of select="'https://dfg-viewer.de/profil-der-metadaten/'"/>
            </xsl:namespace>
            <xsl:namespace name="kitodo">
                <xsl:value-of select="'http://meta.kitodo.org/v1/'"/>
            </xsl:namespace>
            <xsl:namespace name="mods">
                <xsl:value-of select="'http://www.loc.gov/mods/v3'"/>
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
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mets:dmdSec/mets:mdWrap">
        <xsl:copy>
            <xsl:attribute name="MDTYPE">MODS</xsl:attribute>
            <xsl:apply-templates select="@*[local-name() != 'MDTYPE' and local-name() != 'OTHERMDTYPE'] | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:rightsMD/mets:mdWrap">
        <xsl:copy>
            <xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
            <xsl:attribute name="MIMETYPE">text/xml</xsl:attribute>
            <xsl:attribute name="OTHERMDTYPE">DVRIGHTS</xsl:attribute>
            <xsl:apply-templates select="@*[local-name() != 'MDTYPE' and local-name() != 'OTHERMDTYPE' and local-name() != 'MIMETYPE'] | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:digiprovMD/mets:mdWrap">
        <xsl:copy>
            <xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
            <xsl:attribute name="MIMETYPE">text/xml</xsl:attribute>
            <xsl:attribute name="OTHERMDTYPE">DVLINKS</xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- add TYPE if not present -->
    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']/mets:div">
        <xsl:copy>
            <xsl:attribute name="TYPE">physSequence</xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- change TYPE if present (BoundBook) -->
    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']/mets:div/@TYPE">
        <xsl:attribute name="TYPE">physSequence</xsl:attribute>
    </xsl:template>


    <xsl:template match="mets:fileGrp">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()[not(self::mets:file)]"/>
            <xsl:apply-templates select="mets:file">
                <xsl:sort select="mets:FLocat/@xlink:href" order="ascending"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="mets:amdSec/mets:rightsMD/mets:mdWrap/mets:xmlData/kitodo:kitodo">
        <xsl:variable name="owner" select="kitodo:metadata[@name='owner']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerContact" select="kitodo:metadata[@name='ownerContact']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerLogo" select="kitodo:metadata[@name='ownerLogo']"/><!-- metadata from project configuration -->
        <xsl:variable name="ownerSiteURL" select="kitodo:metadata[@name='ownerSiteURL']"/><!-- metadata from project configuration -->
        <xsl:variable name="rights" select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='AccessLicense']"/><!-- metadata from the dmdSec -->
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
        <xsl:variable name="catalogIDDigital" select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='CatalogIDDigital']"/>
        <xsl:variable name="url" select="/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='URL']"/>
        <dv:links>
            <dv:presentation>
                <xsl:value-of select="normalize-space($url)"/>
            </dv:presentation>
            <xsl:if test="$catalogIDDigital">
                <dv:reference>
                    <xsl:value-of select="normalize-space(concat('https://swb.bsz-bw.de/DB=2.1/PPNSET?PPN=',$catalogIDDigital))"/>
                </dv:reference>
            </xsl:if>
        </dv:links>
    </xsl:template>

    <xsl:template name="dmdSec" match="mets:dmdSec/mets:mdWrap/mets:xmlData/kitodo:kitodo">
        <xsl:variable name="title" select="kitodo:metadata[@name='TitleDocMain']"/>
        <xsl:variable name="subTitle" select="kitodo:metadata[@name='TitleDocSub']"/>
        <xsl:variable name="personGroup" select="kitodo:metadataGroup[@name='Person']"/>
        <xsl:variable name="publicationPlace" select="kitodo:metadata[@name='PlaceOfPublication']"/>
        <xsl:variable name="publisher" select="kitodo:metadata[@name='PublisherName']"/>
        <xsl:variable name="language" select="kitodo:metadata[@name='DocLanguage']"/>
        <xsl:variable name="collection" select="kitodo:metadata[@name='singleDigCollection']"/>
        <xsl:variable name="recordIdentifierHost" select="kitodo:metadata[@name='URNanchor']"/>
        <xsl:variable name="processTitle" select="kitodo:metadata[@name='processTitle']"/>
        <xsl:variable name="catalogIDDigital" select="kitodo:metadata[@name='CatalogIDDigital']"/>
        <xsl:variable name="shelfLocator" select="kitodo:metadata[@name='shelfmarksource']"/>
        <xsl:variable name="rights" select="kitodo:metadata[@name='AccessLicense']"/>
        <xsl:variable name="TSL_ATS" select="kitodo:metadata[@name='TSL_ATS']"/>
        <!-- WLB -->
        <!--
        <xsl:variable name="" select="kitodo:metadata[@name='']"/>
        -->
        <xsl:variable name="dateIssued" select="kitodo:metadata[@name='PublicationYearNonsort']"/>
        <xsl:variable name="dateIssuedKeydate" select="kitodo:metadata[@name='PublicationYear']"/>
        <xsl:variable name="dateOfPublication" select="kitodo:metadata[@name='DateOfPublication']"/>
        <xsl:variable name="publicationRun" select="kitodo:metadata[@name='PublicationRun']"/>
        <xsl:variable name="publicationRunCatalogue" select="kitodo:metadata[@name='PublicationRunCatalogue']"/>
        <xsl:variable name="dateCaptured" select="kitodo:metadata[@name='datedigit']"/>
        <xsl:variable name="url" select="kitodo:metadata[@name='URL']"/>
        <xsl:variable name="urn" select="kitodo:metadata[@name='URN']"/>
        <xsl:variable name="bszppn" select="kitodo:metadata[@name='SwbCatalogIDDigital']"/>
        <xsl:variable name="catalogIDSource" select="kitodo:metadata[@name='CatalogIDSource']"/>
        <xsl:variable name="catalogIDPeriodicalDB" select="kitodo:metadata[@name='CatalogIDPeriodicalDB']"/>
        <xsl:variable name="titleDocMainShort" select="kitodo:metadata[@name='TitleDocMainShort']"/>
        <xsl:variable name="alternativeTitle" select="kitodo:metadata[@name='AlternativeTitle']"/>
        <xsl:variable name="titleDocVaryingForm" select="kitodo:metadata[@name='TitleDocVaryingForm']"/>
        <xsl:variable name="titleDocAdditional" select="kitodo:metadata[@name='TitleDocAdditional']"/>
        <xsl:variable name="titleDocParallel" select="kitodo:metadata[@name='TitleDocParallel']"/>
        <xsl:variable name="subject" select="kitodo:metadata[@name='Subject']"/>
        <xsl:variable name="sizeSourcePrint" select="kitodo:metadata[@name='SizeSourcePrint']"/>
        <xsl:variable name="titleWord" select="kitodo:metadata[@name='TitleWord']"/>
        <xsl:variable name="partNumber" select="kitodo:metadata[@name='CurrentNo']"/>
        <xsl:variable name="partOrder" select="kitodo:metadata[@name='CurrentNoSorting']"/>
        <xsl:variable name="titleDocMainNote" select="kitodo:metadata[@name='TitleDocMainNote']"/>
        <xsl:variable name="note" select="kitodo:metadata[@name='Note']"/>
        <xsl:variable name="noteWithoutSubfields" select="kitodo:metadata[@name='NoteWithoutSubfields']"/>
        <xsl:variable name="custodialHistory" select="kitodo:metadata[@name='CustodialHistory']"/>
        <xsl:variable name="custodialHistoryInfo" select="kitodo:metadata[@name='CustodialHistoryInfo']"/>
        <xsl:variable name="custodialHistoryLeoBw" select="kitodo:metadata[@name='CustodialHistoryLeoBw']"/>
        <xsl:variable name="scale" select="kitodo:metadata[@name='Scale']"/>
        <xsl:variable name="containedWorkInfo" select="kitodo:metadata[@name='ContainedWorkInfo']"/>
        <xsl:variable name="enclosedWorkInfo" select="kitodo:metadata[@name='EnclosedWorkInfo']"/>
        <xsl:variable name="edition" select="kitodo:metadata[@name='Edition']"/>
        <mods:mods>
            <xsl:if test="$title or $subTitle">
                <mods:titleInfo>
                    <xsl:if test="$title">
                        <xsl:for-each select="$title">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$subTitle">
                        <xsl:for-each select="$subTitle">
                            <mods:subTitle>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:subTitle>
                        </xsl:for-each>
                    </xsl:if>
                </mods:titleInfo>
            </xsl:if>
            <xsl:if test="$personGroup">
                <xsl:apply-templates select="$personGroup"/>
            </xsl:if>
            <xsl:if test="$titleDocMainShort">
                <xsl:for-each select="$titleDocMainShort">
                    <mods:titleInfo type="alternative">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                    </mods:titleInfo>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$alternativeTitle">
                <xsl:for-each select="$alternativeTitle">
                    <mods:titleInfo type="alternative">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                    </mods:titleInfo>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$titleDocVaryingForm">
                <xsl:for-each select="$titleDocVaryingForm">
                    <mods:titleInfo type="alternative">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                    </mods:titleInfo>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$titleDocAdditional">
                <xsl:for-each select="$titleDocAdditional">
                    <mods:titleInfo type="alternative">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                    </mods:titleInfo>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$titleDocParallel">
                <xsl:for-each select="$titleDocParallel">
                    <mods:titleInfo type="alternative">
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                    </mods:titleInfo>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$titleWord">
                <mods:extension>
                    <zvdd:zvddWrap>
                        <zvdd:titleWord>
                            <xsl:value-of select="normalize-space($titleWord)"/>
                        </zvdd:titleWord>
                    </zvdd:zvddWrap>
                </mods:extension>
            </xsl:if>
            <xsl:if test="$publicationPlace or $publisher or $dateIssued or $dateIssuedKeydate or $dateOfPublication or $publicationRun or $publicationRunCatalogue or $edition">
                <mods:originInfo eventType="publication">
                    <xsl:if test="$publicationPlace">
                        <mods:place>
                            <xsl:for-each select="$publicationPlace">
                                <mods:placeTerm type="text">
                                    <xsl:value-of select="(.)"/>
                                </mods:placeTerm>
                            </xsl:for-each>
                        </mods:place>
                    </xsl:if>
                    <xsl:if test="$publisher">
                        <xsl:for-each select="$publisher">
                            <mods:publisher>
                                <xsl:value-of select="(.)"/>
                            </mods:publisher>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$dateIssued">
                        <xsl:for-each select="$dateIssued">
                            <mods:dateIssued>
                                <xsl:value-of select="(.)"/>
                            </mods:dateIssued>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$dateIssuedKeydate">
                        <mods:dateIssued encoding="iso8601" keyDate="yes">
                            <xsl:value-of select="normalize-space($dateIssuedKeydate)"/>
                        </mods:dateIssued>
                    </xsl:if>
                    <xsl:if test="$dateOfPublication">
                        <mods:dateIssued encoding="iso8601" keyDate="yes">
                            <xsl:value-of select="normalize-space($dateOfPublication)"/>
                        </mods:dateIssued>
                    </xsl:if>
                    <xsl:if test="$publicationRun">
                        <xsl:for-each select="$publicationRun">
                            <mods:dateOther>
                                <xsl:value-of select="(.)"/>
                            </mods:dateOther>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$publicationRunCatalogue">
                        <xsl:for-each select="$publicationRunCatalogue">
                            <mods:dateOther>
                                <xsl:value-of select="(.)"/>
                            </mods:dateOther>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$edition">
                        <xsl:for-each select="$edition">
                            <mods:edition>
                                <xsl:value-of select="(.)"/>
                            </mods:edition>
                        </xsl:for-each>
                    </xsl:if>
                </mods:originInfo>
            </xsl:if>
            <xsl:if test="$dateCaptured">
                <mods:originInfo eventType="digitization">
                    <xsl:if test="$dateCaptured">
                        <xsl:for-each select="$dateCaptured">
                            <mods:dateCaptured encoding="iso8601">
                                <xsl:value-of select="(.)"/>
                            </mods:dateCaptured>
                        </xsl:for-each>
                    </xsl:if>
                </mods:originInfo>
            </xsl:if>
            <xsl:if test="$language">
                <mods:language>
                    <xsl:if test="($language != '')">
                        <xsl:for-each select="$language">
                            <mods:languageTerm type="code" authority="iso639-2b">
                                <xsl:value-of select="(.)"/>
                            </mods:languageTerm>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="($language = '') or not($language)">
                        <mods:languageTerm type="code" authority="iso639-2b">
                            <xsl:text>und</xsl:text>
                        </mods:languageTerm>
                    </xsl:if>
                </mods:language>
            </xsl:if>
            <xsl:if test="$collection">
                <xsl:for-each select="$collection">
                    <mods:classification authority="WLB">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:classification>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$sizeSourcePrint">
                <mods:physicalDescription>
                    <mods:extent>
                        <xsl:value-of select="normalize-space($sizeSourcePrint)"/>
                    </mods:extent>
                </mods:physicalDescription>
            </xsl:if>
            <xsl:if test="$titleDocMainNote">
                <xsl:for-each select="$titleDocMainNote">
                    <mods:note type="TitleNote">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$note">
                <xsl:for-each select="$note">
                    <mods:note>
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$noteWithoutSubfields">
                <xsl:for-each select="$noteWithoutSubfields">
                    <mods:note type="NoteWithoutSubfields">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$custodialHistory">
                <xsl:for-each select="$custodialHistory">
                    <mods:note type="custodialHistory">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$custodialHistoryInfo">
                <xsl:for-each select="$custodialHistoryInfo">
                    <mods:note type="ownership">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$custodialHistoryLeoBw">
                <xsl:for-each select="$custodialHistoryLeoBw">
                    <mods:note type="ownership_leo-bw">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$scale">
                <xsl:for-each select="$scale">
                    <mods:note type="scale">
                        <xsl:value-of select="normalize-space(.)"/>
                    </mods:note>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$containedWorkInfo">
                <xsl:for-each select="$containedWorkInfo">
                    <mods:part type="constituent">
                        <mods:detail>
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                        </mods:detail>
                    </mods:part>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$enclosedWorkInfo">
                <xsl:for-each select="$enclosedWorkInfo">
                    <mods:part type="constituent">
                        <mods:detail>
                            <mods:title>
                                <xsl:value-of select="normalize-space(.)"/>
                            </mods:title>
                        </mods:detail>
                    </mods:part>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$collection">
                <mods:extension>
                    <wlb:wlb>
                        <xsl:if test="$collection">
                            <xsl:for-each select="$collection">
                                <wlb:collection>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </wlb:collection>
                            </xsl:for-each>
                        </xsl:if>
                    </wlb:wlb>
                </mods:extension>
            </xsl:if>
            <xsl:if test="$recordIdentifierHost">
                <mods:relatedItem type="host">
                    <mods:recordInfo>
                        <mods:recordIdentifier source="urn">
                            <xsl:value-of select="normalize-space($recordIdentifierHost)"/>
                        </mods:recordIdentifier>
                    </mods:recordInfo>
                </mods:relatedItem>
            </xsl:if>
            <xsl:if test="$partNumber or $partOrder">
                <mods:part>
                    <xsl:if test="$partOrder">
                        <xsl:attribute name="order">
                            <xsl:value-of select="$partOrder"/>
                        </xsl:attribute>
                    </xsl:if>
                    <mods:detail type="volume">
                        <xsl:if test="$partNumber">
                            <mods:number>
                                <xsl:value-of select="$partNumber"/>
                            </mods:number>
                        </xsl:if>
                        <xsl:if test="not($partNumber) and $partOrder">
                            <mods:number>
                                <xsl:value-of select="$partOrder"/>
                            </mods:number>
                        </xsl:if>
                    </mods:detail>
                </mods:part>
            </xsl:if>
            <xsl:if test="$urn">
                <mods:identifier type="urn">
                    <xsl:value-of select="normalize-space($urn)"/>
                </mods:identifier>
            </xsl:if>
            <xsl:if test="$catalogIDDigital">
                <mods:identifier type="kxp-ppn">
                    <xsl:value-of select="normalize-space($catalogIDDigital)"/>
                </mods:identifier>
            </xsl:if>
            <xsl:if test="$catalogIDSource">
                <mods:identifier type="PPNanalog">
                    <xsl:value-of select="normalize-space($catalogIDSource)"/>
                </mods:identifier>
            </xsl:if>
            <xsl:if test="$catalogIDPeriodicalDB">
                <mods:identifier type="zdb">
                    <xsl:value-of select="normalize-space($catalogIDPeriodicalDB)"/>
                </mods:identifier>
            </xsl:if>
            <xsl:if test="$bszppn">
                <mods:identifier type="bsz-ppn">
                    <xsl:value-of select="normalize-space($bszppn)"/>
                </mods:identifier>
            </xsl:if>
            <xsl:if test="$url">
                <mods:location>
                    <mods:url access="object in context">
                        <xsl:value-of select="normalize-space($url)"/>
                    </mods:url>
                </mods:location>
            </xsl:if>
            <xsl:if test="$shelfLocator">
                <mods:location>
                    <mods:shelfLocator>
                        <xsl:value-of select="normalize-space($shelfLocator)"/>
                    </mods:shelfLocator>
                    <mods:physicalLocation valueURI="https://ld.zdb-services.de/resource/organisations/DE-24">
                        <xsl:text>Württembergische Landesbibliothek Stuttgart</xsl:text>
                    </mods:physicalLocation>
                </mods:location>
            </xsl:if>
            <xsl:if test="$rights">
                <xsl:choose>
                    <xsl:when test="($rights = 'https://creativecommons.org/publicdomain/mark/1.0/')">
                        <mods:accessCondition type="use and reproduction" xlink:href ="https://creativecommons.org/publicdomain/mark/1.0/">
                            <xsl:text>Public Domain Mark 1.0</xsl:text>
                        </mods:accessCondition>
                        <mods:accessCondition displayLabel="Access Status" type="restriction on access" xlink:href="http://purl.org/coar/access_right/c_abf2">
                            <xsl:text>Open Access</xsl:text>
                        </mods:accessCondition>
                    </xsl:when>
                    <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz/1.0/')">
                        <mods:accessCondition type="use and reproduction" xlink:href ="http://rightsstatements.org/vocab/InC/1.0/">
                            <xsl:text>Urheberrechtsschutz</xsl:text>
                        </mods:accessCondition>
                        <mods:accessCondition type="local terms of use" xlink:href ="http://digital.wlb-stuttgart.de/lizenzen/rv-fz/1.0/">
                            <xsl:text>Rechte vorbehalten - Freier Zugang</xsl:text>
                        </mods:accessCondition>
                        <mods:accessCondition displayLabel="Access Status" type="restriction on access" xlink:href="http://purl.org/coar/access_right/c_abf2">
                            <xsl:text>Open Access</xsl:text>
                        </mods:accessCondition>
                    </xsl:when>
                    <xsl:when test="($rights = 'http://digital.wlb-stuttgart.de/lizenzen/rv-fz-andere/1.0/')">
                        <mods:accessCondition type="use and reproduction" xlink:href ="http://rightsstatements.org/vocab/NoC-OKLR/1.0/">
                            <xsl:text>Kein Urheberrechtsschutz - Andere rechtliche Beschränkungen</xsl:text>
                        </mods:accessCondition>
                        <mods:accessCondition type="local terms of use" xlink:href ="http://digital.wlb-stuttgart.de/lizenzen/rv-fz-andere/1.0/">
                            <xsl:text>Rechte vorbehalten - Freier Zugang</xsl:text>
                        </mods:accessCondition>
                        <mods:accessCondition displayLabel="Access Status" type="restriction on access" xlink:href="http://purl.org/coar/access_right/c_abf2">
                            <xsl:text>Open Access</xsl:text>
                        </mods:accessCondition>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$urn">
                <mods:recordInfo>
                    <mods:recordIdentifier source="urn">
                        <xsl:value-of select="normalize-space($urn)"/>
                    </mods:recordIdentifier>
                </mods:recordInfo>
            </xsl:if>
        </mods:mods>
    </xsl:template>

    <!-- remove BoundBook dmdSec (pathimagefiles) -->
    <xsl:variable name="boundbookdmdid" select="//mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='BoundBook']/@DMDID"/>

    <xsl:template match="mets:dmdSec[@ID=normalize-space($boundbookdmdid)]">
    </xsl:template>

    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']/mets:div[@TYPE='BoundBook' and @DMDID=normalize-space($boundbookdmdid)]/@DMDID">
    </xsl:template>

    <!-- change pagination from uncounted to " - " -->
    <xsl:template match="mets:structMap[@TYPE='PHYSICAL']/mets:div/mets:div[@TYPE='page'][@ORDERLABEL='uncounted']/@ORDERLABEL">
        <xsl:attribute name="ORDERLABEL"> - </xsl:attribute>
    </xsl:template>


    <!-- add LABELS to div from dmdSec - https://github.com/kitodo/kitodo-production/issues/5016#issuecomment-1378852324 --> 
    <xsl:template match="@DMDID">
        <xsl:variable name="dmSecId" select="."/>
        <xsl:variable name="TitleDocMain" select="/mets:mets/mets:dmdSec[@ID=$dmSecId]/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='TitleDocMain']"/>
        <xsl:variable name="TitleDocMainShort" select="/mets:mets/mets:dmdSec[@ID=$dmSecId]/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='TitleDocMainShort']"/>
        <xsl:variable name="CurrentNoSorting" select="/mets:mets/mets:dmdSec[@ID=$dmSecId]/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='CurrentNoSorting']"/>
        <xsl:if test="$TitleDocMain !=''">
            <xsl:attribute name="LABEL">
               <xsl:value-of select="/mets:mets/mets:dmdSec[@ID=$dmSecId]/mets:mdWrap/mets:xmlData/kitodo:kitodo/kitodo:metadata[@name='TitleDocMain']"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="$TitleDocMainShort !=''">
            <xsl:attribute name="ORDERLABEL">
                <xsl:choose>
                    <xsl:when test="starts-with($TitleDocMainShort, 'Der')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMainShort,'Der ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMainShort, 'Die')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMainShort,'Die ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMainShort, 'Das')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMainShort,'Das ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMainShort, 'Eine')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMainShort,'Eine ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMainShort, 'Ein')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMainShort,'Ein ', ''))"/>
                    </xsl:when>
                   <xsl:otherwise>
                        <xsl:value-of select="($TitleDocMainShort)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="not($TitleDocMainShort) and $TitleDocMain !=''">
            <xsl:attribute name="ORDERLABEL">
                <xsl:choose>
                    <xsl:when test="starts-with($TitleDocMain, 'Der')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMain,'Der ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMain, 'Die')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMain,'Die ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMain, 'Das')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMain,'Das ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMain, 'Eine')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMain,'Eine ', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with($TitleDocMain, 'Ein')">
                        <xsl:value-of select="normalize-space(replace($TitleDocMain,'Ein ', ''))"/>
                    </xsl:when>
                   <xsl:otherwise>
                        <xsl:value-of select="($TitleDocMain)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>



    <xsl:template name="personGroup" match="kitodo:kitodo/kitodo:metadataGroup[@name='Person']">
        <xsl:variable name="firstName" select="kitodo:metadata[@name='FirstName']"/>
        <xsl:variable name="lastName" select="kitodo:metadata[@name='LastName']"/>
        <xsl:variable name="displayForm" select="kitodo:metadata[@name='DisplayForm']"/>
        <xsl:variable name="personalName" select="kitodo:metadata[@name='PersonalName']"/>
        <xsl:variable name="additionalMetadataPerson" select="kitodo:metadata[@name='AdditionalMetadataPerson']"/>
        <xsl:variable name="count" select="kitodo:metadata[@name='Count']"/>
        <xsl:variable name="roleCode" select="kitodo:metadata[@name='RoleCode']"/>
        <xsl:variable name="identifierGND" select="kitodo:metadata[@name='IdentifierGND']"/>
        <xsl:variable name="identifierGNDURI" select="kitodo:metadata[@name='IdentifierGNDURI']"/>
        <xsl:variable name="authority" select="kitodo:metadata[@name='Authority']"/>
        <mods:name type="personal">
            <xsl:if test="$identifierGNDURI">
                <xsl:attribute name="valueURI">
                    <xsl:value-of select="$identifierGNDURI"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$personalName">
                <mods:namePart>
                    <xsl:value-of select="normalize-space($personalName)"/>
                </mods:namePart>
            </xsl:if>
            <xsl:if test="$lastName">
                <mods:namePart type="family">
                    <xsl:value-of select="normalize-space($lastName)"/>
                </mods:namePart>
            </xsl:if>
            <xsl:if test="$firstName">
                <mods:namePart type="given">
                    <xsl:value-of select="normalize-space($firstName)"/>
                </mods:namePart>
            </xsl:if>
            <xsl:if test="$additionalMetadataPerson">
                <mods:namePart type="termsOfAddress">
                    <xsl:choose>
                        <xsl:when test="(boolean($additionalMetadataPerson) = boolean($count))">
                            <xsl:value-of select="concat($count, ', ',$additionalMetadataPerson)"/>
                        </xsl:when>
                        <xsl:when test="(boolean($additionalMetadataPerson) != boolean($count))">
                            <xsl:value-of select="($additionalMetadataPerson)"/>
                        </xsl:when>
                    </xsl:choose>
                </mods:namePart>
            </xsl:if>
            <xsl:if test="$displayForm">
                <mods:displayForm>
                    <xsl:value-of select="normalize-space($displayForm)"/>
                </mods:displayForm>
            </xsl:if>
            <xsl:if test="$roleCode">
                <xsl:for-each select="$roleCode">
                    <mods:role>
                        <mods:roleTerm type="code" authority="marcrelator">
                            <xsl:attribute name="valueURI">
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/relators/', normalize-space(.))"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </mods:roleTerm>
                    </mods:role>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="$identifierGND or $authority or $identifierGNDURI">
                <mods:nameIdentifier>
                    <xsl:if test="$authority">
                        <xsl:attribute name="type">
                            <xsl:value-of select="$authority"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$identifierGNDURI">
                        <xsl:attribute name="typeURI">
                            <xsl:value-of select="$identifierGNDURI"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$identifierGND">
                        <xsl:value-of select="normalize-space($identifierGND)"/>
                    </xsl:if>
                </mods:nameIdentifier>
            </xsl:if>
        </mods:name>
    </xsl:template>

    <xsl:template match="@TYPE">
        <xsl:attribute name="TYPE">
            <xsl:choose>
                <xsl:when test=". = 'Article'">
                    <xsl:text>article</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Chapter'">
                    <xsl:text>chapter</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'ContainedWork'">
                    <xsl:text>contained_work</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Manuscript'">
                    <xsl:text>manuscript</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Monograph'">
                    <xsl:text>monograph</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'MultiVolumeWork'">
                    <xsl:text>multivolume_work</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Newspaper'">
                    <xsl:text>newspaper</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'NewspaperYear'">
                    <xsl:text>year</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'NewspaperMonth'">
                    <xsl:text>month</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'NewspaperDay'">
                    <xsl:text>day</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'NewspaperIssue'">
                    <xsl:text>issue</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Periodical'">
                    <xsl:text>periodical</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'PeriodicalIssue'">
                    <xsl:text>issue</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'PeriodicalVolume'">
                    <xsl:text>volume</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'PeriodicalPart'">
                    <xsl:text>section</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Volume'">
                    <xsl:text>volume</xsl:text>
                </xsl:when>
                <!-- WLB veraltete Vorgaenge mit BoundBook korrekt exportieren fuer DFG-Viewer -->
                <xsl:when test=". = 'BoundBook'">
                    <xsl:text>physSequence</xsl:text>
                </xsl:when>
                <!-- WLB-Besonderheiten bei Umwandlung -->
                <xsl:when test=". = 'Cover'">
                    <xsl:text>binding</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Illustration'">
                    <xsl:text>illustration</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'ImprintColophon'">
                    <xsl:text>imprint</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Index'">
                    <xsl:text>index</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Map'">
                    <xsl:text>map</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Music'">
                    <xsl:text>musical_notation</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'TableList'">
                    <xsl:text>table</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'TableOfContents'">
                    <xsl:text>contents</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'TextSection'">
                    <xsl:text>text</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'TitlePage'">
                    <xsl:text>title_page</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- pass-through rule -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
